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

  async function createQuestion(payload) {
    const { data } = await api.post('/api/questions', payload);
    questions.value.unshift(data.data);
    total.value++;
    return data.data;
  }

  return { questions, total, fetchQuestions, createQuestion };
});
