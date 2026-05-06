import { defineStore } from 'pinia';
import { ref } from 'vue';
import api from '@/lib/api';

export const useQuestionStore = defineStore('question', () => {
  const questions = ref([]);
  const total = ref(0);

  async function fetchQuestions(params = {}) {
    const { data } = await api.get('/api/questions', { params: { limit: 20, ...params } });
    questions.value = data.data;
    total.value = data.total;
  }

  return { questions, total, fetchQuestions };
});
