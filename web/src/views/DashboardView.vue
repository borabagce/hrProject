<script setup>
import { computed, ref, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';
import { useUserStore } from '@/stores/user';
import { useAnalyticsStore } from '@/stores/analytics';
import { useQuestionStore } from '@/stores/question';
import { useCategoryStore } from '@/stores/category';
import { useDepartmentStore } from '@/stores/department';

const router = useRouter();
const auth = useAuthStore();
const userStore = useUserStore();
const analyticsStore = useAnalyticsStore();
const questionStore = useQuestionStore();
const categoryStore = useCategoryStore();
const departmentStore = useDepartmentStore();

const DEPT_COLORS = ['#2E7D7A', '#5FB7C1', '#95D5D0', '#B2E0DD', '#E8F4F8', '#3DBDB0', '#1A5F5C'];
const ACCENT_CYCLE = ['teal', 'blue', 'coral'];
const OPTION_LABELS = ['A', 'B', 'C', 'D', 'E', 'F'];

const tabs = [
  { id: 'Anasayfa', icon: '🏠' },
  { id: 'Test Oluşturma', icon: '✏️' },
  { id: 'Personeller', icon: '👤' },
  { id: 'Analizler', icon: '📊' },
];

const wizardSteps = [
  { id: 1, label: 'Tür & Ayarlar' },
  { id: 2, label: 'Sorular' },
  { id: 3, label: 'Atama & Yayınlama' },
];

const createStepsPreview = [
  { title: '1. Test Türü Seç', icon: '◫' },
  { title: '2. Sorular Ekle', icon: '▣' },
  { title: '3. Personel Ata', icon: '◉' },
  { title: 'Taslakla', icon: '···' },
];

// ─── UI state ──────────────────────────────────────────────────────────────
const activeTab = ref('Anasayfa');
const loading = ref(true);
const error = ref('');
const questionLoading = ref(false);

// ─── Personeller ───────────────────────────────────────────────────────────
const search = ref('');
const deptFilter = ref('Tümü');

// ─── Wizard step 1 ─────────────────────────────────────────────────────────
const wizardStep = ref(1);
const testTitle = ref('');
const testCategoryId = ref('');
const testType = ref('multiple_choice');
const testDifficulty = ref(3);
const step1Error = ref('');

// ─── Wizard step 2 ─────────────────────────────────────────────────────────
const selectedQuestionIds = ref([]);
const showAddQuestionForm = ref(false);
const addQuestionLoading = ref(false);
const addQuestionError = ref('');
const newQuestion = ref(defaultQuestion());

function defaultQuestion() {
  return {
    text: '',
    type: 'multiple_choice',
    difficulty: 3,
    options: [
      { text: '', isCorrect: true, order: 0 },
      { text: '', isCorrect: false, order: 1 },
      { text: '', isCorrect: false, order: 2 },
      { text: '', isCorrect: false, order: 3 },
    ],
  };
}

// ─── Wizard step 3 ─────────────────────────────────────────────────────────
const selectedEmployeeIds = ref([]);
const step3Error = ref('');
const publishSuccess = ref(false);
const publishedTestName = ref('');

// ─── Employee add modal ────────────────────────────────────────────────────
const showAddEmployeeModal = ref(false);
const addEmployeeLoading = ref(false);
const addEmployeeError = ref('');
const newEmployee = ref(defaultEmployee());

function defaultEmployee() {
  return { fullName: '', email: '', password: '', role: 'employee', departmentId: '' };
}

// ─── Computed ──────────────────────────────────────────────────────────────

const employees = computed(() =>
  userStore.users.map((u, i) => ({
    id: u._id,
    name: u.fullName,
    dept: u.departmentId?.name ?? '—',
    role: u.role,
    accent: ACCENT_CYCLE[i % ACCENT_CYCLE.length],
    initial: u.fullName
      .split(' ')
      .slice(0, 2)
      .map((w) => w[0])
      .join('')
      .toUpperCase(),
    isActive: u.isActive,
  }))
);

const activeEmployeeCount = computed(() => employees.value.filter((e) => e.isActive).length);

const filteredEmployees = computed(() => {
  let result = employees.value;
  if (search.value.trim()) {
    const q = search.value.toLowerCase();
    result = result.filter((e) =>
      [e.name, e.dept].some((v) => v.toLowerCase().includes(q))
    );
  }
  if (deptFilter.value !== 'Tümü') {
    result = result.filter((e) => e.dept === deptFilter.value);
  }
  return result;
});

const departmentData = computed(() => {
  const depts = analyticsStore.departments;
  if (!depts.length) return [];
  const total = depts.reduce((s, d) => s + (d.employeeCount || 0), 0) || 1;
  return depts.map((d, i) => ({
    name: d.departmentName,
    value: Math.round(((d.employeeCount || 0) / total) * 100),
    color: DEPT_COLORS[i % DEPT_COLORS.length],
  }));
});

const totalDepartment = computed(() => departmentData.value.reduce((s, d) => s + d.value, 0));

const deptChips = computed(() => [
  'Tümü',
  ...analyticsStore.departments.map((d) => d.departmentName),
]);

const reportCards = computed(() => {
  const depts = analyticsStore.departments.slice(0, 7);
  const pad = (arr) => [...arr, ...Array(Math.max(0, 7 - arr.length)).fill(0)];
  const scores = pad(depts.map((d) => d.avgScore ?? 0));
  const sessions = pad(depts.map((d) => d.totalSessions ?? 0));
  const maxSessions = Math.max(...sessions, 1);
  const normalizedSessions = sessions.map((v) => Math.round((v / maxSessions) * 80));
  return [
    { title: 'Performans Analizi', subtitle: 'Departman ortalamaları', bars: scores, line: scores },
    { title: 'Takım Analizi', subtitle: 'Oturum dağılımı', bars: normalizedSessions, line: normalizedSessions },
  ];
});

const overviewStats = computed(() => analyticsStore.overview?.sessionStats ?? {});
const topWrongQuestions = computed(() => analyticsStore.overview?.topWrongQuestions ?? []);

const REPORT_TYPE_LABELS = {
  weekly_summary: 'Haftalık Özet',
  monthly_summary: 'Aylık Özet',
  risk_assessment: 'Risk Değerlendirmesi',
};
const RISK_LABELS = { low: 'Düşük', medium: 'Orta', high: 'Yüksek' };

// ─── Analytics / Reports state ─────────────────────────────────────────────
const reportGenerating = ref(false);
const reportError = ref('');
const reportForm = ref({ reportType: 'weekly_summary', periodStart: '', periodEnd: '' });

const selectedCategoryName = computed(() => {
  if (!testCategoryId.value) return '—';
  return categoryStore.categories.find((c) => c._id === testCategoryId.value)?.name ?? '—';
});

const filteredQuestions = computed(() => {
  if (!testCategoryId.value) return questionStore.questions;
  return questionStore.questions.filter(
    (q) => (q.categoryId?._id ?? q.categoryId) === testCategoryId.value
  );
});

const TYPE_LABELS = { multiple_choice: 'Çoktan Seçmeli', true_false: 'Doğru / Yanlış' };

// ─── Chart helpers ─────────────────────────────────────────────────────────

function donutStroke(item, index) {
  const circ = 314;
  const total = departmentData.value.reduce((s, d) => s + d.value, 0) || 1;
  const dashLen = (circ * item.value) / total;
  const prevTotal = departmentData.value.slice(0, index).reduce((s, d) => s + d.value, 0);
  const startAngle = (prevTotal / total) * 360 - 90;
  return {
    style: { strokeDasharray: `${dashLen} ${circ - dashLen}` },
    transform: `rotate(${startAngle}, 60, 60)`,
  };
}

function miniDonutStroke(item, index) {
  const circ = 2 * Math.PI * 32;
  const total = departmentData.value.reduce((s, d) => s + d.value, 0) || 1;
  const dashLen = (circ * item.value) / total;
  const prevTotal = departmentData.value.slice(0, index).reduce((s, d) => s + d.value, 0);
  const startAngle = (prevTotal / total) * 360 - 90;
  return {
    style: { strokeDasharray: `${dashLen} ${circ - dashLen}` },
    transform: `rotate(${startAngle}, 40, 40)`,
  };
}

function barHeight(value) {
  return `${Math.max(4, value)}%`;
}

function linePoints(values) {
  const width = 260;
  const height = 130;
  const max = Math.max(...values, 1);
  const stepX = width / (values.length - 1);
  return values.map((v, i) => `${i * stepX},${height - (v / max) * 105 - 10}`).join(' ');
}

// ─── Wizard navigation ─────────────────────────────────────────────────────

function nextStep() {
  if (wizardStep.value === 1) {
    if (!testTitle.value.trim()) { step1Error.value = 'Test başlığı zorunludur.'; return; }
    step1Error.value = '';
  }
  if (wizardStep.value < 3) wizardStep.value++;
}

function prevStep() {
  if (wizardStep.value > 1) wizardStep.value--;
}

function resetWizard() {
  testTitle.value = '';
  testCategoryId.value = '';
  testType.value = 'multiple_choice';
  testDifficulty.value = 3;
  step1Error.value = '';
  step3Error.value = '';
  selectedEmployeeIds.value = [];
  selectedQuestionIds.value = [];
  showAddQuestionForm.value = false;
  newQuestion.value = defaultQuestion();
  publishSuccess.value = false;
  wizardStep.value = 1;
}

function publishTest() {
  if (!selectedQuestionIds.value.length) {
    step3Error.value = 'En az bir soru seçmelisiniz.';
    return;
  }
  if (!selectedEmployeeIds.value.length) {
    step3Error.value = 'En az bir personel seçin.';
    return;
  }
  step3Error.value = '';
  publishedTestName.value = testTitle.value;
  publishSuccess.value = true;
}

async function submitGenerateReport() {
  reportError.value = '';
  if (!reportForm.value.periodStart || !reportForm.value.periodEnd) {
    reportError.value = 'Dönem başlangıç ve bitiş tarihleri zorunludur.';
    return;
  }
  if (new Date(reportForm.value.periodStart) >= new Date(reportForm.value.periodEnd)) {
    reportError.value = 'Başlangıç tarihi bitiş tarihinden önce olmalıdır.';
    return;
  }
  reportGenerating.value = true;
  try {
    await analyticsStore.generateReport(reportForm.value);
    reportForm.value.periodStart = '';
    reportForm.value.periodEnd = '';
  } catch (err) {
    reportError.value = err.response?.data?.message ?? 'Rapor oluşturulamadı.';
  } finally {
    reportGenerating.value = false;
  }
}

// ─── Question form helpers ──────────────────────────────────────────────────

function setCorrectOption(index) {
  newQuestion.value.options.forEach((o, i) => (o.isCorrect = i === index));
}

function addQuestionOption() {
  if (newQuestion.value.options.length >= 6) return;
  const len = newQuestion.value.options.length;
  newQuestion.value.options.push({ text: '', isCorrect: false, order: len });
}

function removeQuestionOption(index) {
  newQuestion.value.options.splice(index, 1);
  newQuestion.value.options.forEach((o, i) => (o.order = i));
  if (!newQuestion.value.options.some((o) => o.isCorrect)) {
    newQuestion.value.options[0].isCorrect = true;
  }
}

function onQuestionTypeChange() {
  if (newQuestion.value.type === 'true_false') {
    newQuestion.value.options = [
      { text: 'Doğru', isCorrect: true, order: 0 },
      { text: 'Yanlış', isCorrect: false, order: 1 },
    ];
  } else {
    newQuestion.value.options = [
      { text: '', isCorrect: true, order: 0 },
      { text: '', isCorrect: false, order: 1 },
      { text: '', isCorrect: false, order: 2 },
      { text: '', isCorrect: false, order: 3 },
    ];
  }
}

function toggleQuestion(id) {
  const idx = selectedQuestionIds.value.indexOf(id);
  if (idx >= 0) selectedQuestionIds.value.splice(idx, 1);
  else selectedQuestionIds.value.push(id);
}

function isQuestionSelected(id) {
  return selectedQuestionIds.value.includes(id);
}

async function submitAddQuestion() {
  addQuestionError.value = '';
  if (!testCategoryId.value) {
    addQuestionError.value = "Lütfen önce Adım 1'den bir kategori seçin.";
    return;
  }
  if (!newQuestion.value.text.trim()) {
    addQuestionError.value = 'Soru metni boş bırakılamaz.';
    return;
  }
  if (newQuestion.value.options.some((o) => !o.text.trim())) {
    addQuestionError.value = 'Tüm seçenekleri doldurun.';
    return;
  }
  addQuestionLoading.value = true;
  try {
    const q = await questionStore.createQuestion({
      categoryId: testCategoryId.value,
      text: newQuestion.value.text,
      type: newQuestion.value.type,
      difficulty: newQuestion.value.difficulty,
      options: newQuestion.value.options,
    });
    selectedQuestionIds.value.push(q._id);
    showAddQuestionForm.value = false;
    newQuestion.value = defaultQuestion();
  } catch (err) {
    addQuestionError.value = err.response?.data?.message ?? 'Soru kaydedilemedi.';
  } finally {
    addQuestionLoading.value = false;
  }
}

// ─── Employee modal helpers ─────────────────────────────────────────────────

function openAddEmployeeModal() {
  newEmployee.value = defaultEmployee();
  addEmployeeError.value = '';
  showAddEmployeeModal.value = true;
}

async function submitAddEmployee() {
  addEmployeeError.value = '';
  addEmployeeLoading.value = true;
  try {
    await userStore.createUser({
      fullName: newEmployee.value.fullName,
      email: newEmployee.value.email,
      password: newEmployee.value.password,
      role: newEmployee.value.role,
      ...(newEmployee.value.departmentId && { departmentId: newEmployee.value.departmentId }),
    });
    showAddEmployeeModal.value = false;
  } catch (err) {
    addEmployeeError.value = err.response?.data?.message ?? 'Personel eklenirken hata oluştu.';
  } finally {
    addEmployeeLoading.value = false;
  }
}

// ─── Auth ──────────────────────────────────────────────────────────────────

async function logout() {
  auth.logout();
  router.push('/login');
}

// ─── Watchers ──────────────────────────────────────────────────────────────

watch(activeTab, async (tab) => {
  if (tab === 'Test Oluşturma' && !questionStore.questions.length) {
    questionLoading.value = true;
    try {
      await Promise.all([questionStore.fetchQuestions(), categoryStore.fetchCategories()]);
    } finally {
      questionLoading.value = false;
    }
  } else if (tab === 'Analizler') {
    try {
      await Promise.all([analyticsStore.listReports(), analyticsStore.fetchQuestionAnalytics()]);
    } catch { /* non-critical */ }
  }
});

// ─── Lifecycle ─────────────────────────────────────────────────────────────

onMounted(async () => {
  try {
    await Promise.all([
      auth.user ? Promise.resolve() : auth.fetchMe(),
      userStore.fetchUsers({ limit: 20 }),
      analyticsStore.fetchOverview(),
      analyticsStore.fetchDepartments(),
      departmentStore.fetchDepartments(),
    ]);
  } catch {
    error.value = 'Veriler yüklenirken bir hata oluştu.';
  } finally {
    loading.value = false;
  }
});
</script>

<template>
  <div class="shell">
    <div class="ambient ambient-left"></div>
    <div class="ambient ambient-right"></div>

    <!-- ── Header ── -->
    <div class="page-top">
      <header class="topbar">
        <p class="eyebrow">İK Analiz</p>
        <div class="topbar-right">
          <span class="user-name">Merhaba, {{ auth.user?.fullName ?? '…' }}</span>
          <div class="avatar-circle">{{ auth.initials }}</div>
          <button class="bell-btn" type="button" aria-label="Bildirimler">🔔</button>
          <button class="bell-btn" type="button" title="Çıkış" @click="logout">⏻</button>
        </div>
      </header>

      <nav class="tabbar" aria-label="Ana gezinme">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          class="tab-pill"
          :class="{ active: activeTab === tab.id }"
          type="button"
          @click="activeTab = tab.id"
        >
          <span class="tab-icon">{{ tab.icon }}</span>
          {{ tab.id }}
        </button>
      </nav>
    </div>

    <div v-if="loading" class="page-loading">
      <div class="spinner"></div>
    </div>

    <p v-else-if="error" class="page-error">{{ error }}</p>

    <main v-else class="dashboard">

      <!-- ══════════════════════ ANASAYFA ══════════════════════ -->
      <template v-if="activeTab === 'Anasayfa'">
        <section class="hero card-surface">
          <div class="hero-art">
            <div class="art-backdrop"></div>
            <div class="lab-card">
              <div class="lab-top"></div>
              <div class="lab-flask flask-a"></div>
              <div class="lab-flask flask-b"></div>
              <div class="lab-screen">
                <span></span><span></span><span></span>
              </div>
            </div>
          </div>

          <div class="hero-copy">
            <p class="section-kicker">Yeni Test Oluşturma Paneli</p>
            <h1>Kurumsal ekipler için düzenli, ölçülebilir ve güven veren değerlendirme akışı.</h1>

            <div v-if="overviewStats.totalSessions" class="hero-stats">
              <div class="stat-chip">
                <strong>{{ overviewStats.totalSessions }}</strong>
                <span>Toplam Oturum</span>
              </div>
              <div class="stat-chip">
                <strong>%{{ overviewStats.avgScore?.toFixed(1) }}</strong>
                <span>Ortalama Başarı</span>
              </div>
              <div class="stat-chip">
                <strong>{{ userStore.total }}</strong>
                <span>Personel</span>
              </div>
            </div>

            <div class="hero-actions">
              <button class="primary-btn" type="button" @click="activeTab = 'Test Oluşturma'">
                Yeni Test Oluştur
              </button>
              <button class="secondary-btn" type="button" @click="activeTab = 'Personeller'">
                Personelleri Gör
              </button>
            </div>
          </div>
        </section>

        <section class="wizard-preview card-surface">
          <div class="wizard-steps-row">
            <template v-for="(step, i) in createStepsPreview" :key="step.title">
              <div class="step-preview-card" :class="{ active: i === 0 }">
                <div class="step-preview-icon">{{ step.icon }}</div>
                <strong>{{ step.title }}</strong>
              </div>
              <span v-if="i < createStepsPreview.length - 1" class="step-preview-arrow">›</span>
            </template>
          </div>

          <div class="draft-bar">
            <div class="section-headline">
              <h2>Son Kaydedilen Taslaklar</h2>
              <a href="#" @click.prevent="activeTab = 'Test Oluşturma'">Sınırsız</a>
            </div>
            <div class="draft-grid">
              <article class="draft-card">
                <div><h3>Q3 Teknik Değerlendirme</h3><p>Vue.js · 12 Soru</p></div>
                <span class="draft-meta">Ön İzleme</span>
              </article>
              <article class="draft-card">
                <div><h3>Satış Yetkinlik Testi</h3><p>Genel · 8 Soru</p></div>
                <span class="draft-meta">Ön İzleme</span>
              </article>
            </div>
          </div>
        </section>

        <section class="section-block">
          <div class="section-title-row">
            <div><h2>Personel Takibi</h2><span></span></div>
          </div>
          <div v-if="!employees.length" class="empty-state">
            <p>Henüz personel eklenmemiş.</p>
          </div>
          <div v-else class="employee-grid">
            <article
              v-for="emp in employees.slice(0, 3)"
              :key="emp.id"
              class="employee-card"
              :class="emp.accent"
            >
              <div class="employee-head">
                <div class="employee-avatar">{{ emp.initial }}</div>
                <div>
                  <h3>{{ emp.name }}</h3>
                  <p>{{ emp.dept }}</p>
                </div>
              </div>
              <div class="employee-actions">
                <button type="button" @click="activeTab = 'Test Oluşturma'">Test ata</button>
                <button type="button" @click="activeTab = 'Analizler'">Raporu gör</button>
                <button type="button" @click="activeTab = 'Personeller'">Takip</button>
              </div>
            </article>
          </div>
        </section>

        <section class="section-block">
          <div class="section-title-row">
            <div><h2>Analizler</h2><span></span></div>
          </div>
          <div class="analytics-grid">
            <article class="chart-card donut-card">
              <div class="section-headline compact">
                <h3>Departman Dağılımı</h3>
              </div>
              <div v-if="!departmentData.length" class="empty-state small"><p>Veri yok</p></div>
              <div v-else class="donut-wrap">
                <svg viewBox="0 0 120 120" class="donut-svg">
                  <circle cx="60" cy="60" r="50" class="donut-track"></circle>
                  <circle
                    v-for="(item, i) in departmentData"
                    :key="item.name"
                    cx="60" cy="60" r="50"
                    class="donut-segment"
                    :stroke="item.color"
                    v-bind="donutStroke(item, i)"
                  ></circle>
                </svg>
                <div class="donut-legend">
                  <div v-for="item in departmentData" :key="item.name" class="legend-row">
                    <span class="legend-dot" :style="{ background: item.color }"></span>
                    <span>{{ item.name }}</span>
                    <strong>%{{ item.value }}</strong>
                  </div>
                </div>
              </div>
            </article>

            <article v-for="card in reportCards" :key="card.title" class="chart-card">
              <div class="section-headline compact">
                <h3>{{ card.title }}</h3>
                <span class="chart-subtitle">{{ card.subtitle }}</span>
              </div>
              <div class="chart-panel">
                <div class="bars">
                  <span v-for="(bar, i) in card.bars" :key="i" class="bar" :style="{ height: barHeight(bar) }"></span>
                </div>
                <svg viewBox="0 0 260 130" class="line-chart" aria-hidden="true">
                  <polyline :points="linePoints(card.line)" class="trend-line"></polyline>
                </svg>
                <div class="chart-dots">
                  <span class="dot active"></span>
                  <span class="dot"></span>
                  <span class="dot muted"></span>
                </div>
              </div>
            </article>
          </div>
          <div class="center-cta">
            <button class="primary-btn" type="button" @click="activeTab = 'Analizler'">
              Detaylı Raporlar
            </button>
          </div>
        </section>
      </template>

      <!-- ══════════════════════ TEST OLUŞTURMA ══════════════════════ -->
      <template v-else-if="activeTab === 'Test Oluşturma'">

        <!-- Success state -->
        <div v-if="publishSuccess" class="success-card card-surface">
          <div class="success-icon">✓</div>
          <h2>Test başarıyla oluşturuldu!</h2>
          <p class="section-text" style="text-align:center;margin:0 auto 4px;">
            <strong>{{ publishedTestName }}</strong> ·
            {{ selectedQuestionIds.length }} soru ·
            {{ selectedEmployeeIds.length }} personel
          </p>
          <div class="step-actions" style="justify-content:center;margin-top:28px;">
            <button class="secondary-btn" type="button" @click="activeTab = 'Anasayfa'">Anasayfa'ya Dön</button>
            <button class="primary-btn" type="button" @click="resetWizard">Yeni Test Oluştur</button>
          </div>
        </div>

        <template v-else>
          <!-- Stepper -->
          <div class="wizard-stepper card-surface">
            <template v-for="(step, i) in wizardSteps" :key="step.id">
              <span
                class="stepper-label"
                :class="{ active: wizardStep === step.id, done: wizardStep > step.id }"
              >{{ step.label }}</span>
              <span v-if="i < wizardSteps.length - 1" class="stepper-sep">›</span>
            </template>
          </div>

          <!-- ── Step 1: Tür & Ayarlar ── -->
          <section v-if="wizardStep === 1" class="step-form card-surface">
            <h2>Test Türü ve Ayarları</h2>
            <div class="step-fields">
              <div class="field-group">
                <label class="field-label">Test Başlığı *</label>
                <input
                  v-model="testTitle"
                  class="field-input"
                  type="text"
                  placeholder="örn. Q3 Teknik Değerlendirme"
                />
              </div>
              <div class="field-group">
                <label class="field-label">Kategori</label>
                <select v-model="testCategoryId" class="field-select">
                  <option value="">Kategori seçin…</option>
                  <option v-for="cat in categoryStore.categories" :key="cat._id" :value="cat._id">
                    {{ cat.name }}
                  </option>
                </select>
              </div>
              <div class="field-row-2">
                <div class="field-group">
                  <label class="field-label">Test Türü</label>
                  <select v-model="testType" class="field-select">
                    <option value="multiple_choice">Çoktan Seçmeli</option>
                    <option value="true_false">Doğru / Yanlış</option>
                  </select>
                </div>
                <div class="field-group">
                  <label class="field-label">Zorluk Seviyesi</label>
                  <select v-model.number="testDifficulty" class="field-select">
                    <option :value="1">1 — Çok Kolay</option>
                    <option :value="2">2 — Kolay</option>
                    <option :value="3">3 — Orta</option>
                    <option :value="4">4 — Zor</option>
                    <option :value="5">5 — Çok Zor</option>
                  </select>
                </div>
              </div>
            </div>
            <p v-if="step1Error" class="form-error">{{ step1Error }}</p>
            <div class="step-actions">
              <button class="primary-btn" type="button" @click="nextStep">Sonraki Adım</button>
            </div>
          </section>

          <!-- ── Step 2: Sorular ── -->
          <section v-else-if="wizardStep === 2">
            <div v-if="questionLoading" class="page-loading"><div class="spinner"></div></div>
            <div v-else class="test-create-layout">

              <!-- Questions column -->
              <div class="test-create-questions">
                <div
                  v-if="!filteredQuestions.length && !showAddQuestionForm"
                  class="empty-state card-surface"
                  style="border-radius:20px;padding:40px;"
                >
                  <p>Bu kategoride henüz soru yok. Aşağıdan ilk soruyu oluşturun.</p>
                </div>

                <div class="question-flow">
                  <!-- Existing questions -->
                  <div v-for="(q, i) in filteredQuestions" :key="q._id" class="question-row">
                    <div class="q-left">
                      <div
                        class="question-num-badge"
                        :class="{ 'q-badge-selected': isQuestionSelected(q._id) }"
                      >{{ i + 1 }}</div>
                      <div class="q-connector"></div>
                    </div>
                    <div
                      class="question-card card-surface"
                      :class="{ 'q-card-selected': isQuestionSelected(q._id) }"
                    >
                      <div class="question-card-header">
                        <h3>{{ q.categoryId?.name ?? 'Soru' }} {{ i + 1 }}</h3>
                        <button
                          class="question-select-toggle"
                          :class="{ selected: isQuestionSelected(q._id) }"
                          type="button"
                          @click="toggleQuestion(q._id)"
                        >
                          {{ isQuestionSelected(q._id) ? '✓ Eklendi' : '+ Ekle' }}
                        </button>
                      </div>
                      <p class="question-body">{{ q.text }}</p>
                      <div class="question-options">
                        <div v-for="(opt, j) in q.options" :key="j" class="option-row">
                          <span class="option-label-badge" :class="{ 'opt-correct': opt.isCorrect }">{{ OPTION_LABELS[j] }}</span>
                          <span class="option-text-bar">{{ opt.text }}</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Inline add-question form -->
                  <div v-if="showAddQuestionForm" class="question-row">
                    <div class="q-left">
                      <div class="question-num-badge add-badge">+</div>
                    </div>
                    <div class="add-question-form card-surface">
                      <p class="form-section-title">Yeni Soru Oluştur</p>
                      <div class="field-group">
                        <label class="field-label">Soru Metni</label>
                        <textarea
                          v-model="newQuestion.text"
                          class="field-textarea"
                          rows="3"
                          placeholder="Soruyu buraya yazın…"
                        ></textarea>
                      </div>
                      <div class="field-row-2">
                        <div class="field-group">
                          <label class="field-label">Soru Türü</label>
                          <select v-model="newQuestion.type" class="field-select" @change="onQuestionTypeChange">
                            <option value="multiple_choice">Çoktan Seçmeli</option>
                            <option value="true_false">Doğru / Yanlış</option>
                          </select>
                        </div>
                        <div class="field-group">
                          <label class="field-label">Zorluk (1–5)</label>
                          <select v-model.number="newQuestion.difficulty" class="field-select">
                            <option v-for="n in 5" :key="n" :value="n">{{ n }}</option>
                          </select>
                        </div>
                      </div>
                      <div class="options-editor">
                        <label class="field-label">
                          Seçenekler
                          <span class="label-hint"> — ● doğru cevabı işaretleyin</span>
                        </label>
                        <div v-for="(opt, i) in newQuestion.options" :key="i" class="option-editor-row">
                          <input
                            type="radio"
                            name="correct-opt"
                            :checked="opt.isCorrect"
                            :disabled="newQuestion.type === 'true_false'"
                            @change="setCorrectOption(i)"
                          />
                          <span class="option-label-badge">{{ OPTION_LABELS[i] }}</span>
                          <input
                            v-model="opt.text"
                            class="field-input option-text-input"
                            type="text"
                            :placeholder="`${OPTION_LABELS[i]} seçeneği…`"
                            :disabled="newQuestion.type === 'true_false'"
                          />
                          <button
                            v-if="newQuestion.type === 'multiple_choice' && newQuestion.options.length > 2"
                            class="remove-opt-btn"
                            type="button"
                            title="Seçeneği sil"
                            @click="removeQuestionOption(i)"
                          >✕</button>
                        </div>
                        <button
                          v-if="newQuestion.type === 'multiple_choice' && newQuestion.options.length < 6"
                          class="add-opt-btn"
                          type="button"
                          @click="addQuestionOption"
                        >+ Seçenek Ekle</button>
                      </div>
                      <p v-if="addQuestionError" class="form-error">{{ addQuestionError }}</p>
                      <div class="step-actions">
                        <button
                          class="secondary-btn"
                          type="button"
                          @click="showAddQuestionForm = false; addQuestionError = ''"
                        >İptal</button>
                        <button
                          class="primary-btn"
                          type="button"
                          :disabled="addQuestionLoading"
                          @click="submitAddQuestion"
                        >
                          {{ addQuestionLoading ? 'Kaydediliyor…' : 'Soruyu Kaydet' }}
                        </button>
                      </div>
                    </div>
                  </div>

                  <!-- Add question trigger card -->
                  <div v-if="!showAddQuestionForm" class="question-row">
                    <div class="q-left">
                      <div class="question-num-badge add-badge">?</div>
                    </div>
                    <div class="add-question-card card-surface" @click="showAddQuestionForm = true">
                      <span class="add-icon-lg">+</span>
                      <span class="add-question-label">Yeni Soru Ekle</span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Sidebar: test summary -->
              <aside class="test-create-sidebar card-surface">
                <p class="sidebar-title">Test Özeti</p>
                <div class="sidebar-summary">
                  <div class="sidebar-stat">
                    <span class="sidebar-stat-label">Başlık</span>
                    <span class="sidebar-stat-value">{{ testTitle || '—' }}</span>
                  </div>
                  <div class="sidebar-stat">
                    <span class="sidebar-stat-label">Kategori</span>
                    <span class="sidebar-stat-value">{{ selectedCategoryName }}</span>
                  </div>
                  <div class="sidebar-stat">
                    <span class="sidebar-stat-label">Tür</span>
                    <span class="sidebar-stat-value">{{ TYPE_LABELS[testType] }}</span>
                  </div>
                  <div class="sidebar-stat">
                    <span class="sidebar-stat-label">Zorluk</span>
                    <span class="sidebar-stat-value">{{ testDifficulty }} / 5</span>
                  </div>
                  <div class="sidebar-stat sidebar-stat-highlight">
                    <span class="sidebar-stat-label">Seçilen Soru</span>
                    <strong class="sidebar-stat-count">{{ selectedQuestionIds.length }}</strong>
                  </div>
                </div>
              </aside>
            </div>

            <div class="step-actions">
              <button class="secondary-btn" type="button" @click="prevStep">Önceki Adım</button>
              <button class="primary-btn" type="button" @click="nextStep">Sonraki Adım</button>
            </div>
          </section>

          <!-- ── Step 3: Atama & Yayınlama ── -->
          <section v-else-if="wizardStep === 3" class="step-form card-surface">
            <h2>Personel Atama ve Yayınlama</h2>
            <p class="section-text">Testi atamak istediğiniz personelleri seçin.</p>
            <div class="employee-select-grid">
              <label
                v-for="emp in employees"
                :key="emp.id"
                class="employee-select-item"
                :class="{ 'item-checked': selectedEmployeeIds.includes(emp.id) }"
              >
                <input type="checkbox" :value="emp.id" v-model="selectedEmployeeIds" />
                <div class="employee-select-info">
                  <div class="employee-avatar small">{{ emp.initial }}</div>
                  <div>
                    <strong>{{ emp.name }}</strong>
                    <p>{{ emp.dept }}</p>
                  </div>
                </div>
              </label>
            </div>
            <p v-if="step3Error" class="form-error" style="margin-top:12px;">{{ step3Error }}</p>
            <div v-if="selectedEmployeeIds.length" class="publish-summary">
              <span>{{ selectedQuestionIds.length }} soru</span>
              <span class="publish-sep">·</span>
              <span>{{ selectedEmployeeIds.length }} personel seçildi</span>
            </div>
            <div class="step-actions">
              <button class="secondary-btn" type="button" @click="prevStep">Önceki Adım</button>
              <button class="primary-btn" type="button" @click="publishTest">Testi Yayınla 🚀</button>
            </div>
          </section>
        </template>
      </template>

      <!-- ══════════════════════ PERSONELLER ══════════════════════ -->
      <template v-else-if="activeTab === 'Personeller'">
        <div class="personnel-overview-grid">
          <div class="stats-summary-card card-surface">
            <h2>Personel Özeti</h2>
            <div class="stat-item">
              <span class="stat-icon">👥</span>
              <span>Toplam Personel</span>
              <strong>{{ userStore.total }}</strong>
            </div>
            <div class="stat-item">
              <span class="stat-icon">✅</span>
              <span>Aktif Personel</span>
              <strong>{{ activeEmployeeCount }}</strong>
            </div>

            <div v-if="departmentData.length" class="mini-dept-section">
              <p class="mini-dept-label">Departman Dağılımı</p>
              <div class="mini-donut-wrap">
                <svg viewBox="0 0 80 80" class="mini-donut-svg">
                  <circle cx="40" cy="40" r="32" class="donut-track" stroke-width="10"></circle>
                  <circle
                    v-for="(item, i) in departmentData"
                    :key="item.name"
                    cx="40" cy="40" r="32"
                    class="donut-segment"
                    stroke-width="10"
                    :stroke="item.color"
                    v-bind="miniDonutStroke(item, i)"
                  ></circle>
                </svg>
                <div class="mini-legend">
                  <div v-for="item in departmentData.slice(0, 4)" :key="item.name" class="mini-legend-row">
                    <span class="legend-dot" :style="{ background: item.color }"></span>
                    <span>{{ item.name }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="filter-panel-card card-surface">
            <h2>Personel Arama ve Filtreleme</h2>
            <div class="search-input-wrap">
              <span>🔍</span>
              <input
                v-model="search"
                type="search"
                placeholder="Personel ara (ad, departman, e-posta)…"
              />
            </div>
            <div class="dept-filter-chips">
              <button
                v-for="chip in deptChips"
                :key="chip"
                class="dept-chip"
                :class="{ active: deptFilter === chip }"
                type="button"
                @click="deptFilter = chip"
              >
                {{ chip }}
              </button>
            </div>
            <div class="filter-dropdowns">
              <div>
                <label class="filter-label">Kayıt Durumu</label>
                <select class="field-select">
                  <option>Aktif</option>
                  <option>Pasif</option>
                  <option>Tümü</option>
                </select>
              </div>
              <div>
                <label class="filter-label">Son Test Durumu</label>
                <select class="field-select">
                  <option>Tamamlandı</option>
                  <option>Devam Ediyor</option>
                  <option>Atanmadı</option>
                </select>
              </div>
            </div>
            <button class="primary-btn add-personnel-btn" type="button" @click="openAddEmployeeModal">
              Yeni Personel Ekle +
            </button>
          </div>
        </div>

        <section class="section-block">
          <div class="section-title-row">
            <div><h2>Tüm Personeller</h2><span></span></div>
          </div>
          <div v-if="!filteredEmployees.length" class="empty-state">
            <p>Gösterilecek personel bulunamadı.</p>
          </div>
          <div v-else class="employee-grid">
            <article
              v-for="emp in filteredEmployees"
              :key="emp.id"
              class="employee-card"
              :class="emp.accent"
            >
              <div class="employee-head">
                <div class="employee-avatar">{{ emp.initial }}</div>
                <div>
                  <h3>{{ emp.name }}</h3>
                  <p>{{ emp.dept }}</p>
                </div>
              </div>
              <div class="employee-actions">
                <button type="button" @click="activeTab = 'Test Oluşturma'">Test ata</button>
                <button type="button" @click="activeTab = 'Analizler'">Raporu gör</button>
              </div>
            </article>
          </div>
        </section>
      </template>

      <!-- ══════════════════════ ANALİZLER ══════════════════════ -->
      <template v-else-if="activeTab === 'Analizler'">

        <!-- Overview Stats -->
        <section v-if="overviewStats.totalSessions" class="analytics-overview-card card-surface">
          <div class="section-title-row" style="margin-bottom:20px;">
            <div><h2>Genel Bakış</h2><span></span></div>
          </div>
          <div class="analytics-stats-row">
            <div class="stat-chip">
              <strong>{{ overviewStats.totalSessions ?? 0 }}</strong>
              <span>Toplam Oturum</span>
            </div>
            <div class="stat-chip">
              <strong>%{{ overviewStats.avgScore?.toFixed(1) ?? '—' }}</strong>
              <span>Ortalama Başarı</span>
            </div>
            <div class="stat-chip">
              <strong>%{{ overviewStats.maxScore?.toFixed(1) ?? '—' }}</strong>
              <span>En Yüksek</span>
            </div>
            <div class="stat-chip">
              <strong>%{{ overviewStats.minScore?.toFixed(1) ?? '—' }}</strong>
              <span>En Düşük</span>
            </div>
          </div>
        </section>

        <!-- Top Wrong Questions -->
        <section v-if="topWrongQuestions.length" class="section-block card-surface" style="padding:24px;border-radius:26px;">
          <div class="section-title-row">
            <div><h2>En Çok Yanlış Yapılan Sorular</h2><span></span></div>
          </div>
          <div class="wrong-questions-list">
            <div
              v-for="(q, i) in topWrongQuestions.slice(0, 5)"
              :key="q._id ?? i"
              class="wrong-question-row"
            >
              <span class="wq-rank">{{ i + 1 }}</span>
              <span class="wq-text">{{ q.questionText }}</span>
              <span class="wq-count">{{ q.wrongCount }} yanlış</span>
            </div>
          </div>
        </section>

        <!-- Department Charts -->
        <section class="section-block">
          <div class="section-title-row">
            <div><h2>Departman Analizleri</h2><span></span></div>
          </div>
          <div class="analytics-grid">
            <article class="chart-card donut-card">
              <div class="section-headline compact">
                <h3>Departman Dağılımı</h3>
              </div>
              <div v-if="!departmentData.length" class="empty-state small"><p>Departman verisi yok</p></div>
              <div v-else class="donut-wrap">
                <svg viewBox="0 0 120 120" class="donut-svg">
                  <circle cx="60" cy="60" r="50" class="donut-track"></circle>
                  <circle
                    v-for="(item, i) in departmentData"
                    :key="item.name"
                    cx="60" cy="60" r="50"
                    class="donut-segment"
                    :stroke="item.color"
                    v-bind="donutStroke(item, i)"
                  ></circle>
                </svg>
                <div class="donut-legend">
                  <div v-for="item in departmentData" :key="item.name" class="legend-row">
                    <span class="legend-dot" :style="{ background: item.color }"></span>
                    <span>{{ item.name }}</span>
                    <strong>%{{ item.value }}</strong>
                  </div>
                </div>
              </div>
            </article>

            <article v-for="card in reportCards" :key="card.title" class="chart-card">
              <div class="section-headline compact">
                <h3>{{ card.title }}</h3>
                <span class="chart-subtitle">{{ card.subtitle }}</span>
              </div>
              <div class="chart-panel">
                <div class="bars">
                  <span v-for="(bar, i) in card.bars" :key="i" class="bar" :style="{ height: barHeight(bar) }"></span>
                </div>
                <svg viewBox="0 0 260 130" class="line-chart" aria-hidden="true">
                  <polyline :points="linePoints(card.line)" class="trend-line"></polyline>
                </svg>
                <div class="chart-dots">
                  <span class="dot active"></span>
                  <span class="dot"></span>
                  <span class="dot muted"></span>
                </div>
              </div>
            </article>
          </div>
        </section>

        <!-- Report Generation -->
        <section class="section-block card-surface" style="padding:28px;border-radius:26px;">
          <div class="section-title-row" style="margin-bottom:24px;">
            <div><h2>Rapor Oluştur</h2><span></span></div>
          </div>
          <div class="report-gen-form">
            <div class="field-group">
              <label class="field-label">Rapor Türü</label>
              <select v-model="reportForm.reportType" class="field-select" style="max-width:360px;">
                <option value="weekly_summary">Haftalık Özet</option>
                <option value="monthly_summary">Aylık Özet</option>
                <option value="risk_assessment">Risk Değerlendirmesi</option>
              </select>
            </div>
            <div class="field-row-2" style="max-width:480px;">
              <div class="field-group">
                <label class="field-label">Dönem Başlangıcı</label>
                <input v-model="reportForm.periodStart" class="field-input" type="date" />
              </div>
              <div class="field-group">
                <label class="field-label">Dönem Bitişi</label>
                <input v-model="reportForm.periodEnd" class="field-input" type="date" />
              </div>
            </div>
            <p v-if="reportError" class="form-error" style="margin-top:4px;">{{ reportError }}</p>
            <div class="step-actions" style="justify-content:flex-start;">
              <button
                class="primary-btn"
                type="button"
                :disabled="reportGenerating"
                @click="submitGenerateReport"
              >
                {{ reportGenerating ? 'Oluşturuluyor…' : 'Rapor Oluştur' }}
              </button>
            </div>
          </div>
        </section>

        <!-- Reports List -->
        <section v-if="analyticsStore.reports.length" class="section-block card-surface" style="padding:28px;border-radius:26px;">
          <div class="section-title-row" style="margin-bottom:20px;">
            <div><h2>Oluşturulan Raporlar</h2><span></span></div>
          </div>
          <div class="reports-list">
            <div
              v-for="report in analyticsStore.reports"
              :key="report._id"
              class="report-list-row"
            >
              <span class="report-type-chip">{{ REPORT_TYPE_LABELS[report.reportType] }}</span>
              <div class="report-list-meta">
                <strong>
                  {{ new Date(report.periodStart).toLocaleDateString('tr-TR') }} —
                  {{ new Date(report.periodEnd).toLocaleDateString('tr-TR') }}
                </strong>
                <p>
                  Ort. Başarı: %{{ report.avgScore?.toFixed(1) ?? '—' }}
                  · Oluşturan: {{ report.generatedBy?.fullName ?? '—' }}
                </p>
              </div>
              <span class="risk-badge" :class="`risk-${report.riskLevel}`">
                {{ RISK_LABELS[report.riskLevel] ?? report.riskLevel }}
              </span>
            </div>
          </div>
        </section>

      </template>

    </main>

    <!-- ══════════════════════ EMPLOYEE ADD MODAL ══════════════════════ -->
    <div v-if="showAddEmployeeModal" class="modal-overlay" @click.self="showAddEmployeeModal = false">
      <div class="modal-card card-surface">
        <div class="modal-header">
          <h2>Yeni Personel Ekle</h2>
          <button class="modal-close" type="button" @click="showAddEmployeeModal = false">✕</button>
        </div>
        <form @submit.prevent="submitAddEmployee">
          <div class="step-fields">
            <div class="field-group">
              <label class="field-label">Ad Soyad *</label>
              <input
                v-model="newEmployee.fullName"
                class="field-input"
                type="text"
                placeholder="Ahmet Yılmaz"
                required
              />
            </div>
            <div class="field-group">
              <label class="field-label">E-posta *</label>
              <input
                v-model="newEmployee.email"
                class="field-input"
                type="email"
                placeholder="ahmet@sirket.com"
                required
              />
            </div>
            <div class="field-group">
              <label class="field-label">Şifre *</label>
              <input
                v-model="newEmployee.password"
                class="field-input"
                type="password"
                placeholder="Minimum 8 karakter"
                minlength="8"
                required
              />
            </div>
            <div class="field-row-2">
              <div class="field-group">
                <label class="field-label">Departman</label>
                <select v-model="newEmployee.departmentId" class="field-select">
                  <option value="">Seçiniz (opsiyonel)</option>
                  <option
                    v-for="dept in departmentStore.departments"
                    :key="dept._id"
                    :value="dept._id"
                  >{{ dept.name }}</option>
                </select>
              </div>
              <div class="field-group">
                <label class="field-label">Rol</label>
                <select v-model="newEmployee.role" class="field-select">
                  <option value="employee">Personel</option>
                  <option value="hr">İK Direktörü</option>
                  <option value="admin">Yönetici</option>
                </select>
              </div>
            </div>
          </div>
          <p v-if="addEmployeeError" class="form-error" style="margin-top:12px;">{{ addEmployeeError }}</p>
          <div class="modal-actions">
            <button class="secondary-btn" type="button" @click="showAddEmployeeModal = false">İptal</button>
            <button class="primary-btn" type="submit" :disabled="addEmployeeLoading">
              {{ addEmployeeLoading ? 'Ekleniyor…' : 'Personel Ekle' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <footer class="footer">Copyright İK Analiz {{ new Date().getFullYear() }}</footer>
  </div>
</template>
