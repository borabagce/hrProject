import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '@/stores/auth';
import { useSysAdminStore } from '@/stores/sysadmin';

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
  {
    path: '/system/login',
    name: 'SysAdminLogin',
    component: () => import('@/views/SysAdminLoginView.vue'),
    meta: { sysGuest: true },
  },
  {
    path: '/system',
    name: 'SysAdminDashboard',
    component: () => import('@/views/SysAdminDashboardView.vue'),
    meta: { requiresSysAuth: true },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach(async (to) => {
  if (to.meta.requiresSysAuth || to.meta.sysGuest) {
    const sys = useSysAdminStore();
    if (to.meta.requiresSysAuth && !sys.isAuthenticated) return { name: 'SysAdminLogin' };
    if (to.meta.sysGuest && sys.isAuthenticated) return { name: 'SysAdminDashboard' };
    if (to.meta.requiresSysAuth && sys.isAuthenticated && !sys.admin) {
      try {
        await sys.fetchMe();
      } catch {
        sys.logout();
        return { name: 'SysAdminLogin' };
      }
    }
    return;
  }

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
