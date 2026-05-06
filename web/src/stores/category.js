import { defineStore } from 'pinia';
import { ref } from 'vue';
import api from '@/lib/api';

export const useCategoryStore = defineStore('category', () => {
  const categories = ref([]);

  async function fetchCategories() {
    const { data } = await api.get('/api/categories');
    categories.value = data.data;
  }

  return { categories, fetchCategories };
});
