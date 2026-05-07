import { defineStore } from 'pinia';
import { ref } from 'vue';
import api from '@/lib/api';

export const useUserStore = defineStore('user', () => {
  const users = ref([]);
  const total = ref(0);

  async function fetchUsers(params = {}) {
    const { data } = await api.get('/api/users', { params });
    users.value = data.data;
    total.value = data.total;
  }

  async function createUser(payload) {
    const { data } = await api.post('/api/users', payload);
    users.value.unshift(data.data);
    total.value++;
    return data.data;
  }

  return { users, total, fetchUsers, createUser };
});
