import { defineStore } from 'pinia';
import { ref } from 'vue';
import api from '@/lib/api';

export const useQuestionStore = defineStore('question', () => {
  const questions = ref([]);
  const total = ref(0);

  async function fetchQuestions(params = {}) {
    const { data } = await api.get('/api/questions', { params: { limit: 20, ...params } });
    questions.value = data.data;
    total.value = data.meta?.total ?? data.data.length;
  }

  async function createQuestion(payload) {
    const { data } = await api.post('/api/questions', payload);
    questions.value.push(data.data);
    total.value++;
    return data.data;
  }

  async function updateQuestion(id, payload) {
    const { data } = await api.put(`/api/questions/${id}`, payload);
    const idx = questions.value.findIndex((q) => q._id === id);
    if (idx >= 0) questions.value[idx] = data.data;
    return data.data;
  }

  async function deleteQuestion(id) {
    await api.delete(`/api/questions/${id}`);
    questions.value = questions.value.filter((q) => q._id !== id);
    if (total.value > 0) total.value--;
  }

  return { questions, total, fetchQuestions, createQuestion, updateQuestion, deleteQuestion };
});
