import { defineStore } from 'pinia';
import { ref } from 'vue';
import api from '@/lib/api';

export const useUserStore = defineStore('user', () => {
  const users = ref([]);
  const total = ref(0);

  async function fetchUsers(params = {}) {
    const { data } = await api.get('/api/users', { params });
    users.value = data.data;
    total.value = data.meta?.total ?? 0;
  }

  async function createUser(payload) {
    const { data } = await api.post('/api/users', payload);
    users.value.unshift(data.data);
    total.value++;
    return data.data;
  }

  async function updateUser(id, payload) {
    const { data } = await api.put(`/api/users/${id}`, payload);
    const idx = users.value.findIndex((u) => u._id === id);
    if (idx >= 0) users.value[idx] = data.data;
    return data.data;
  }

  return { users, total, fetchUsers, createUser, updateUser };
});
