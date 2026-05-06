import { defineStore } from 'pinia';
import { ref } from 'vue';
import api from '@/lib/api';

export const useAnalyticsStore = defineStore('analytics', () => {
  const overview = ref(null);
  const departments = ref([]);

  async function fetchOverview() {
    const { data } = await api.get('/api/analytics/overview');
    overview.value = data.data;
  }

  async function fetchDepartments() {
    const { data } = await api.get('/api/analytics/departments');
    departments.value = data.data;
  }

  return { overview, departments, fetchOverview, fetchDepartments };
});
