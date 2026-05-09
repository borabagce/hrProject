import { defineStore } from 'pinia';
import { ref } from 'vue';
import api from '@/lib/api';

export const useDepartmentStore = defineStore('department', () => {
  const departments = ref([]);

  async function fetchDepartments() {
    const { data } = await api.get('/api/departments');
    departments.value = data.data;
  }

  async function createDepartment(payload) {
    const { data } = await api.post('/api/departments', payload);
    departments.value.push(data.data);
    return data.data;
  }

  async function updateDepartment(id, payload) {
    const { data } = await api.put(`/api/departments/${id}`, payload);
    const idx = departments.value.findIndex((d) => d._id === id);
    if (idx >= 0) departments.value[idx] = data.data;
    return data.data;
  }

  async function deleteDepartment(id) {
    await api.delete(`/api/departments/${id}`);
    departments.value = departments.value.filter((d) => d._id !== id);
  }

  return { departments, fetchDepartments, createDepartment, updateDepartment, deleteDepartment };
});
