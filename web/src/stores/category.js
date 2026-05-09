import { defineStore } from 'pinia';
import { ref } from 'vue';
import api from '@/lib/api';

export const useCategoryStore = defineStore('category', () => {
  const categories = ref([]);

  async function fetchCategories() {
    const { data } = await api.get('/api/categories');
    categories.value = data.data;
  }

  async function createCategory(payload) {
    const { data } = await api.post('/api/categories', payload);
    categories.value.push(data.data);
    return data.data;
  }

  async function updateCategory(id, payload) {
    const { data } = await api.put(`/api/categories/${id}`, payload);
    const idx = categories.value.findIndex((c) => c._id === id);
    if (idx >= 0) categories.value[idx] = data.data;
    return data.data;
  }

  async function deleteCategory(id) {
    await api.delete(`/api/categories/${id}`);
    categories.value = categories.value.filter((c) => c._id !== id);
  }

  return { categories, fetchCategories, createCategory, updateCategory, deleteCategory };
});
