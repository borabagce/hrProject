import { defineStore } from 'pinia';
import { ref } from 'vue';
import api from '@/lib/api';

export const useAnalyticsStore = defineStore('analytics', () => {
  const overview = ref(null);
  const departments = ref([]);
  const questionStats = ref([]);
  const reports = ref([]);

  async function fetchOverview() {
    const { data } = await api.get('/api/analytics/overview');
    overview.value = data.data;
  }

  async function fetchDepartments() {
    const { data } = await api.get('/api/analytics/departments');
    departments.value = data.data;
  }

  async function fetchQuestionAnalytics() {
    const { data } = await api.get('/api/analytics/questions');
    questionStats.value = data.data;
  }

  async function fetchEmployeeAnalytics(userId) {
    const { data } = await api.get(`/api/analytics/employees/${userId}`);
    return data.data;
  }

  async function generateReport(payload) {
    const { data } = await api.post('/api/analytics/reports', payload);
    reports.value.unshift(data.data);
    return data.data;
  }

  async function listReports(params = {}) {
    const { data } = await api.get('/api/analytics/reports', { params });
    reports.value = data.data;
  }

  async function fetchReport(id) {
    const { data } = await api.get(`/api/analytics/reports/${id}`);
    return data.data;
  }

  async function fetchTestAnalytics(testId) {
    const { data } = await api.get(`/api/analytics/tests/${testId}`);
    return data.data;
  }

  async function fetchQuestionDetail(questionId) {
    const { data } = await api.get(`/api/analytics/questions/${questionId}`);
    return data.data;
  }

  async function fetchDepartmentDetail(departmentId) {
    const { data } = await api.get(`/api/analytics/departments/${departmentId}`);
    return data.data;
  }

  return {
    overview, departments, questionStats, reports,
    fetchOverview, fetchDepartments, fetchQuestionAnalytics,
    fetchEmployeeAnalytics, generateReport, listReports,
    fetchReport, fetchTestAnalytics, fetchQuestionDetail, fetchDepartmentDetail,
  };
});
