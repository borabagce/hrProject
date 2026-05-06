import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import api from '@/lib/api';

const ROLE_LABELS = { admin: 'Yönetici', hr: 'İK Direktörü', employee: 'Personel' };

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null);
  const accessToken = ref(localStorage.getItem('accessToken'));
  const refreshToken = ref(localStorage.getItem('refreshToken'));

  const isAuthenticated = computed(() => !!accessToken.value);
  const roleLabel = computed(() => ROLE_LABELS[user.value?.role] ?? '');
  const initials = computed(() => {
    if (!user.value?.fullName) return '?';
    return user.value.fullName
      .split(' ')
      .slice(0, 2)
      .map((w) => w[0])
      .join('')
      .toUpperCase();
  });

  async function login(email, password) {
    const { data } = await api.post('/api/auth/login', { email, password });
    const { user: u, accessToken: at, refreshToken: rt } = data.data;
    user.value = u;
    accessToken.value = at;
    refreshToken.value = rt;
    localStorage.setItem('accessToken', at);
    localStorage.setItem('refreshToken', rt);
  }

  async function fetchMe() {
    const { data } = await api.get('/api/auth/me');
    user.value = data.data;
  }

  function logout() {
    user.value = null;
    accessToken.value = null;
    refreshToken.value = null;
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
  }

  return { user, accessToken, refreshToken, isAuthenticated, roleLabel, initials, login, fetchMe, logout };
});
