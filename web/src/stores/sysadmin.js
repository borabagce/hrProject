import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import sysApi, { SYS_ACCESS_KEY, SYS_REFRESH_KEY } from '@/lib/sysApi';

export const useSysAdminStore = defineStore('sysadmin', () => {
  const admin = ref(null);
  const accessToken = ref(localStorage.getItem(SYS_ACCESS_KEY));
  const refreshToken = ref(localStorage.getItem(SYS_REFRESH_KEY));

  const companies = ref([]);
  const companiesMeta = ref({ total: 0, page: 1, limit: 20, totalPages: 0 });
  const companiesLoading = ref(false);
  const stats = ref(null);

  const isAuthenticated = computed(() => !!accessToken.value);

  async function login(email, password) {
    const { data } = await sysApi.post('/api/sysadmin/auth/login', { email, password });
    const { admin: a, accessToken: at, refreshToken: rt } = data.data;
    admin.value = a;
    accessToken.value = at;
    refreshToken.value = rt;
    localStorage.setItem(SYS_ACCESS_KEY, at);
    localStorage.setItem(SYS_REFRESH_KEY, rt);
  }

  async function fetchMe() {
    const { data } = await sysApi.get('/api/sysadmin/auth/me');
    admin.value = data.data;
  }

  function logout() {
    admin.value = null;
    accessToken.value = null;
    refreshToken.value = null;
    companies.value = [];
    stats.value = null;
    localStorage.removeItem(SYS_ACCESS_KEY);
    localStorage.removeItem(SYS_REFRESH_KEY);
  }

  async function fetchCompanies({ page = 1, limit = 20, search = '' } = {}) {
    companiesLoading.value = true;
    try {
      const { data } = await sysApi.get('/api/sysadmin/companies', {
        params: { page, limit, ...(search ? { search } : {}) },
      });
      companies.value = data.data;
      companiesMeta.value = data.meta;
    } finally {
      companiesLoading.value = false;
    }
  }

  async function fetchStats() {
    const { data } = await sysApi.get('/api/sysadmin/stats');
    stats.value = data.data;
  }

  async function createCompany(payload) {
    const { data } = await sysApi.post('/api/sysadmin/companies', payload);
    return data.data;
  }

  async function toggleCompanyActive(id, isActive) {
    const { data } = await sysApi.patch(`/api/sysadmin/companies/${id}`, { isActive });
    return data.data;
  }

  return {
    admin,
    accessToken,
    refreshToken,
    isAuthenticated,
    companies,
    companiesMeta,
    companiesLoading,
    stats,
    login,
    fetchMe,
    logout,
    fetchCompanies,
    fetchStats,
    createCompany,
    toggleCompanyActive,
  };
});
