import { defineStore } from 'pinia';
import { ref } from 'vue';
import api from '@/lib/api';

export const useDepartmentStore = defineStore('department', () => {
  const departments = ref([]);

  async function fetchDepartments() {
    const { data } = await api.get('/api/departments');
    departments.value = data.data;
  }

  return { departments, fetchDepartments };
});
