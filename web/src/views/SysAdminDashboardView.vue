<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useSysAdminStore } from '@/stores/sysadmin';

const router = useRouter();
const sys = useSysAdminStore();

const search = ref('');
const error = ref('');
const showCreate = ref(false);

const PLAN_LABELS = { basic: 'Temel', professional: 'Profesyonel', enterprise: 'Kurumsal' };
const ROLE_LABELS = { admin: 'Yönetici', hr: 'İK Direktörü', employee: 'Personel' };

const usersByRole = computed(() => {
  const map = { admin: 0, hr: 0, employee: 0 };
  for (const r of sys.stats?.usersByRole ?? []) {
    if (r._id in map) map[r._id] = r.count;
  }
  return map;
});

const form = ref(defaultForm());

function defaultForm() {
  return {
    name: '',
    industry: '',
    subscriptionPlan: 'basic',
    maxEmployees: 50,
    adminFullName: '',
    adminEmail: '',
    adminPassword: '',
    adminRole: 'admin',
  };
}

const submitting = ref(false);
const formError = ref('');

async function loadAll() {
  error.value = '';
  try {
    await Promise.all([sys.fetchStats(), sys.fetchCompanies({ search: search.value })]);
  } catch (err) {
    error.value = err.response?.data?.message ?? 'Veriler yüklenemedi.';
  }
}

async function applySearch() {
  await sys.fetchCompanies({ search: search.value });
}

async function changePage(page) {
  if (page < 1 || page > sys.companiesMeta.totalPages) return;
  await sys.fetchCompanies({ page, search: search.value });
}

async function submitCreate() {
  formError.value = '';
  submitting.value = true;
  try {
    await sys.createCompany(form.value);
    showCreate.value = false;
    form.value = defaultForm();
    await loadAll();
  } catch (err) {
    formError.value =
      err.response?.data?.errors?.[0]?.message ??
      err.response?.data?.message ??
      'Şirket oluşturulamadı.';
  } finally {
    submitting.value = false;
  }
}

async function toggleActive(company) {
  try {
    await sys.toggleCompanyActive(company._id, !company.isActive);
    await sys.fetchCompanies({ page: sys.companiesMeta.page, search: search.value });
  } catch (err) {
    error.value = err.response?.data?.message ?? 'İşlem başarısız.';
  }
}

function logout() {
  sys.logout();
  router.push('/system/login');
}

function formatDate(iso) {
  return new Date(iso).toLocaleDateString('tr-TR', { day: '2-digit', month: 'short', year: 'numeric' });
}

onMounted(loadAll);
</script>

<template>
  <div class="sys-shell">
    <header class="sys-topbar">
      <div>
        <p class="eyebrow">Sistem Yönetimi</p>
        <h1>Şirket Yönetimi</h1>
      </div>
      <div class="sys-user">
        <span>{{ sys.admin?.fullName }}</span>
        <button class="ghost-btn" @click="logout">Çıkış</button>
      </div>
    </header>

    <section class="sys-stats">
      <div class="stat-card card-surface">
        <p class="stat-label">Toplam Şirket</p>
        <p class="stat-value">{{ sys.stats?.companies?.total ?? 0 }}</p>
        <p class="stat-sub">{{ sys.stats?.companies?.active ?? 0 }} aktif</p>
      </div>
      <div class="stat-card card-surface">
        <p class="stat-label">Yöneticiler</p>
        <p class="stat-value">{{ usersByRole.admin }}</p>
      </div>
      <div class="stat-card card-surface">
        <p class="stat-label">İK Direktörleri</p>
        <p class="stat-value">{{ usersByRole.hr }}</p>
      </div>
      <div class="stat-card card-surface">
        <p class="stat-label">Personeller</p>
        <p class="stat-value">{{ usersByRole.employee }}</p>
      </div>
    </section>

    <section class="sys-toolbar card-surface">
      <input
        v-model="search"
        class="field-input"
        placeholder="Şirket ara…"
        @keyup.enter="applySearch"
      />
      <button class="ghost-btn" @click="applySearch">Ara</button>
      <button class="primary-btn" @click="showCreate = true">+ Yeni Şirket</button>
    </section>

    <p v-if="error" class="sys-error">{{ error }}</p>

    <section class="sys-table card-surface">
      <table>
        <thead>
          <tr>
            <th>Şirket</th>
            <th>Sektör</th>
            <th>Plan</th>
            <th>Çalışan</th>
            <th>Üst Sınır</th>
            <th>Durum</th>
            <th>Oluşturulma</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="sys.companiesLoading">
            <td colspan="8" class="sys-empty">Yükleniyor…</td>
          </tr>
          <tr v-else-if="!sys.companies.length">
            <td colspan="8" class="sys-empty">Henüz şirket yok.</td>
          </tr>
          <tr v-for="c in sys.companies" :key="c._id">
            <td>{{ c.name }}</td>
            <td>{{ c.industry || '—' }}</td>
            <td>{{ PLAN_LABELS[c.subscriptionPlan] ?? c.subscriptionPlan }}</td>
            <td>
              <span>{{ c.employeeCount }}</span>
              <span class="sys-sub"> ({{ c.activeEmployeeCount }} aktif)</span>
            </td>
            <td>{{ c.maxEmployees }}</td>
            <td>
              <span :class="['sys-pill', c.isActive ? 'is-active' : 'is-inactive']">
                {{ c.isActive ? 'Aktif' : 'Pasif' }}
              </span>
            </td>
            <td>{{ formatDate(c.createdAt) }}</td>
            <td>
              <button class="ghost-btn small" @click="toggleActive(c)">
                {{ c.isActive ? 'Pasifleştir' : 'Aktifleştir' }}
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <div v-if="sys.companiesMeta.totalPages > 1" class="sys-pager">
        <button
          class="ghost-btn small"
          :disabled="sys.companiesMeta.page <= 1"
          @click="changePage(sys.companiesMeta.page - 1)"
        >
          Önceki
        </button>
        <span>{{ sys.companiesMeta.page }} / {{ sys.companiesMeta.totalPages }}</span>
        <button
          class="ghost-btn small"
          :disabled="sys.companiesMeta.page >= sys.companiesMeta.totalPages"
          @click="changePage(sys.companiesMeta.page + 1)"
        >
          Sonraki
        </button>
      </div>
    </section>

    <div v-if="showCreate" class="sys-modal" @click.self="showCreate = false">
      <form class="sys-modal-card card-surface" @submit.prevent="submitCreate">
        <header>
          <h2>Yeni Şirket</h2>
          <button type="button" class="ghost-btn small" @click="showCreate = false">×</button>
        </header>

        <fieldset>
          <legend>Şirket Bilgileri</legend>
          <div class="field-group">
            <label class="field-label">Şirket Adı</label>
            <input v-model="form.name" class="field-input" maxlength="150" required />
          </div>
          <div class="field-group">
            <label class="field-label">Sektör</label>
            <input v-model="form.industry" class="field-input" maxlength="100" />
          </div>
          <div class="field-row">
            <div class="field-group">
              <label class="field-label">Abonelik</label>
              <select v-model="form.subscriptionPlan" class="field-input">
                <option value="basic">Temel</option>
                <option value="professional">Profesyonel</option>
                <option value="enterprise">Kurumsal</option>
              </select>
            </div>
            <div class="field-group">
              <label class="field-label">Çalışan Üst Sınırı</label>
              <input v-model.number="form.maxEmployees" class="field-input" type="number" min="1" />
            </div>
          </div>
        </fieldset>

        <fieldset>
          <legend>İlk Yönetici</legend>
          <div class="field-group">
            <label class="field-label">Ad Soyad</label>
            <input v-model="form.adminFullName" class="field-input" maxlength="100" required />
          </div>
          <div class="field-group">
            <label class="field-label">E-posta</label>
            <input v-model="form.adminEmail" class="field-input" type="email" required />
          </div>
          <div class="field-group">
            <label class="field-label">Şifre</label>
            <input
              v-model="form.adminPassword"
              class="field-input"
              type="password"
              minlength="8"
              maxlength="72"
              required
            />
          </div>
          <div class="field-group">
            <label class="field-label">Rol</label>
            <select v-model="form.adminRole" class="field-input">
              <option value="admin">{{ ROLE_LABELS.admin }}</option>
              <option value="hr">{{ ROLE_LABELS.hr }}</option>
            </select>
          </div>
        </fieldset>

        <p v-if="formError" class="sys-error">{{ formError }}</p>

        <div class="sys-modal-actions">
          <button type="button" class="ghost-btn" @click="showCreate = false">İptal</button>
          <button class="primary-btn" :disabled="submitting">
            {{ submitting ? 'Oluşturuluyor…' : 'Şirketi Oluştur' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.sys-shell {
  max-width: 1200px;
  margin: 0 auto;
  padding: 32px 24px 64px;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.sys-topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.sys-topbar h1 {
  margin: 4px 0 0;
  font-size: 28px;
  font-weight: 800;
  letter-spacing: -0.02em;
}

.sys-user {
  display: flex;
  align-items: center;
  gap: 12px;
  font-weight: 600;
  color: var(--ink);
}

.sys-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
}

.stat-card {
  padding: 20px 22px;
  border-radius: 18px;
}

.stat-label {
  margin: 0;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--muted);
}

.stat-value {
  margin: 8px 0 4px;
  font-family: 'Space Grotesk', sans-serif;
  font-size: 32px;
  font-weight: 700;
  color: var(--ink);
}

.stat-sub {
  margin: 0;
  font-size: 13px;
  color: var(--muted);
}

.sys-toolbar {
  display: flex;
  gap: 12px;
  padding: 14px 16px;
  border-radius: 16px;
}

.sys-toolbar .field-input {
  flex: 1;
}

.sys-table {
  border-radius: 18px;
  overflow: hidden;
}

.sys-table table {
  width: 100%;
  border-collapse: collapse;
}

.sys-table th,
.sys-table td {
  text-align: left;
  padding: 14px 16px;
  border-bottom: 1px solid var(--line);
  font-size: 14px;
}

.sys-table th {
  background: rgba(46, 125, 122, 0.06);
  font-weight: 700;
  color: var(--ink);
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.06em;
}

.sys-table tr:last-child td {
  border-bottom: none;
}

.sys-empty {
  text-align: center;
  color: var(--muted);
  padding: 28px 16px;
}

.sys-sub {
  color: var(--muted);
  font-size: 12px;
}

.sys-pill {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 700;
}

.sys-pill.is-active {
  background: rgba(76, 175, 80, 0.15);
  color: var(--green);
}

.sys-pill.is-inactive {
  background: rgba(233, 30, 140, 0.12);
  color: var(--pink);
}

.sys-pager {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 12px 16px;
  background: rgba(255, 255, 255, 0.5);
}

.sys-error {
  color: var(--pink);
  font-weight: 600;
  margin: 0;
}

.sys-modal {
  position: fixed;
  inset: 0;
  background: rgba(24, 50, 58, 0.45);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  z-index: 100;
}

.sys-modal-card {
  width: min(560px, 100%);
  max-height: 90vh;
  overflow-y: auto;
  border-radius: 20px;
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.sys-modal-card header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.sys-modal-card h2 {
  margin: 0;
  font-size: 22px;
  font-weight: 800;
}

.sys-modal-card fieldset {
  border: 1px solid var(--line);
  border-radius: 14px;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.sys-modal-card legend {
  padding: 0 8px;
  font-weight: 700;
  color: var(--teal);
  font-size: 13px;
  text-transform: uppercase;
  letter-spacing: 0.06em;
}

.field-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.sys-modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.ghost-btn.small {
  padding: 6px 12px;
  font-size: 13px;
}
</style>
