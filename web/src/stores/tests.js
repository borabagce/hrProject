import { defineStore } from 'pinia';
import { ref } from 'vue';
import api from '@/lib/api';

export const useTestStore = defineStore('tests', () => {
  const tests = ref([]);
  const total = ref(0);
  const loading = ref(false);

  async function fetchTests(params = {}) {
    loading.value = true;
    try {
      const { data } = await api.get('/api/tests', { params });
      tests.value = data.data;
      total.value = data.meta?.total ?? data.data.length;
    } finally {
      loading.value = false;
    }
  }

  async function createTest(payload) {
    const { data } = await api.post('/api/tests', payload);
    tests.value.unshift(data.data);
    total.value++;
    return data.data;
  }

  async function assignTest(testId, userIds, dueDate = null) {
    const body = { userIds };
    if (dueDate) body.dueDate = dueDate;
    const { data } = await api.post(`/api/tests/${testId}/assign`, body);
    return data.data;
  }

  async function fetchTest(id) {
    const { data } = await api.get(`/api/tests/${id}`);
    return data.data;
  }

  async function updateTest(id, payload) {
    const { data } = await api.put(`/api/tests/${id}`, payload);
    const idx = tests.value.findIndex((t) => t._id === id);
    if (idx >= 0) tests.value[idx] = data.data;
    return data.data;
  }

  return { tests, total, loading, fetchTests, fetchTest, createTest, assignTest, updateTest };
});
