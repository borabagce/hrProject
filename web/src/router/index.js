import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '@/stores/auth';

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/LoginView.vue'),
    meta: { guest: true },
  },
  {
    path: '/',
    name: 'Dashboard',
    component: () => import('@/views/DashboardView.vue'),
    meta: { requiresAuth: true },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach(async (to) => {
  const auth = useAuthStore();

  if (to.meta.requiresAuth && !auth.isAuthenticated) return { name: 'Login' };
  if (to.meta.guest && auth.isAuthenticated) return { name: 'Dashboard' };

  if (to.meta.requiresAuth && auth.isAuthenticated) {
    if (!auth.user) {
      try { await auth.fetchMe(); } catch { auth.logout(); return { name: 'Login' }; }
    }
    if (auth.user?.role === 'employee') {
      auth.logout();
      return { name: 'Login' };
    }
  }
});

export default router;
