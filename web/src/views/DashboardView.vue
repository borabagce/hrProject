<script setup>
import { computed, ref, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';
import { useUserStore } from '@/stores/user';
import { useAnalyticsStore } from '@/stores/analytics';
import { useQuestionStore } from '@/stores/question';
import { useCategoryStore } from '@/stores/category';

const router = useRouter();
const auth = useAuthStore();
const userStore = useUserStore();
const analyticsStore = useAnalyticsStore();
const questionStore = useQuestionStore();
const categoryStore = useCategoryStore();

const DEPT_COLORS = ['#2E7D7A', '#5FB7C1', '#95D5D0', '#B2E0DD', '#E8F4F8', '#3DBDB0', '#1A5F5C'];
const ACCENT_CYCLE = ['teal', 'blue', 'coral'];
const OPTION_LABELS = ['A', 'B', 'C', 'D', 'E'];

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

const activeTab = ref('Anasayfa');
const loading = ref(true);
const error = ref('');
const questionLoading = ref(false);

// Personeller
const search = ref('');
const deptFilter = ref('Tümü');

// Test Oluşturma
const wizardStep = ref(1);
const testTitle = ref('');
const testCategoryId = ref('');
const selectedEmployeeIds = ref([]);

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

function donutStroke(item) {
  const circ = 314;
  const total = totalDepartment.value || 1;
  return {
    strokeDasharray: `${circ} ${circ}`,
    strokeDashoffset: circ - (circ * item.value) / total,
  };
}

function miniDonutStroke(item) {
  const circ = 2 * Math.PI * 32;
  const total = totalDepartment.value || 1;
  return {
    strokeDasharray: `${circ} ${circ}`,
    strokeDashoffset: circ - (circ * item.value) / total,
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

function nextStep() {
  if (wizardStep.value < 3) wizardStep.value++;
}

function prevStep() {
  if (wizardStep.value > 1) wizardStep.value--;
}

async function logout() {
  auth.logout();
  router.push('/login');
}

watch(activeTab, async (tab) => {
  if (tab === 'Test Oluşturma' && !questionStore.questions.length) {
    questionLoading.value = true;
    try {
      await Promise.all([questionStore.fetchQuestions(), categoryStore.fetchCategories()]);
    } finally {
      questionLoading.value = false;
    }
  }
});

onMounted(async () => {
  try {
    await Promise.all([
      auth.user ? Promise.resolve() : auth.fetchMe(),
      userStore.fetchUsers({ limit: 20 }),
      analyticsStore.fetchOverview(),
      analyticsStore.fetchDepartments(),
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

      <!-- ═══════════════ ANASAYFA ═══════════════ -->
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
                    v-for="item in departmentData"
                    :key="item.name"
                    cx="60" cy="60" r="50"
                    class="donut-segment"
                    :stroke="item.color"
                    :style="donutStroke(item)"
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

      <!-- ═══════════════ TEST OLUŞTURMA ═══════════════ -->
      <template v-else-if="activeTab === 'Test Oluşturma'">
        <div class="wizard-stepper card-surface">
          <template v-for="(step, i) in wizardSteps" :key="step.id">
            <span
              class="stepper-label"
              :class="{
                active: wizardStep === step.id,
                done: wizardStep > step.id,
              }"
            >{{ step.label }}</span>
            <span v-if="i < wizardSteps.length - 1" class="stepper-sep">›</span>
          </template>
        </div>

        <!-- Step 1: Tür & Ayarlar -->
        <section v-if="wizardStep === 1" class="step-form card-surface">
          <h2>Test Türü ve Ayarları</h2>
          <div class="step-fields">
            <div class="field-group">
              <label class="field-label">Test Başlığı</label>
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
          </div>
          <div class="step-actions">
            <button class="primary-btn" type="button" @click="nextStep">Sonraki Adım</button>
          </div>
        </section>

        <!-- Step 2: Sorular -->
        <section v-else-if="wizardStep === 2">
          <div v-if="questionLoading" class="page-loading"><div class="spinner"></div></div>
          <div v-else class="test-create-layout">
            <div class="test-create-questions">
              <div v-if="!questionStore.questions.length" class="empty-state card-surface" style="border-radius:20px;padding:40px;">
                <p>Henüz soru bulunmuyor. İlk soruyu ekleyin.</p>
              </div>
              <div v-else class="question-flow">
                <div v-for="(q, i) in questionStore.questions" :key="q._id" class="question-row">
                  <div class="q-left">
                    <div class="question-num-badge">{{ i + 1 }}</div>
                    <div v-if="i < questionStore.questions.length" class="q-connector"></div>
                  </div>
                  <div class="question-card card-surface">
                    <h3>{{ q.categoryId?.name ?? 'Soru' }} {{ i + 1 }}</h3>
                    <p class="question-body">{{ q.text }}</p>
                    <div class="question-options">
                      <div v-for="(opt, j) in q.options" :key="j" class="option-row">
                        <span class="option-label-badge">{{ OPTION_LABELS[j] }}</span>
                        <span class="option-text-bar">{{ opt.text }}</span>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="question-row">
                  <div class="q-left">
                    <div class="question-num-badge add-badge">?</div>
                  </div>
                  <div class="add-question-card card-surface">
                    <span class="add-icon-lg">+</span>
                  </div>
                </div>
              </div>
            </div>

            <div class="test-create-sidebar card-surface"></div>
          </div>

          <div class="step-actions">
            <button class="secondary-btn" type="button" @click="prevStep">Önceki Adım</button>
            <button class="primary-btn" type="button" @click="nextStep">Sonraki Adım</button>
          </div>
        </section>

        <!-- Step 3: Atama & Yayınlama -->
        <section v-else-if="wizardStep === 3" class="step-form card-surface">
          <h2>Personel Atama ve Yayınlama</h2>
          <p class="section-text">Testi atamak istediğiniz personelleri seçin.</p>
          <div class="employee-select-grid">
            <label
              v-for="emp in employees"
              :key="emp.id"
              class="employee-select-item"
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
          <div class="step-actions">
            <button class="secondary-btn" type="button" @click="prevStep">Önceki Adım</button>
            <button class="primary-btn" type="button">Testi Yayınla</button>
          </div>
        </section>
      </template>

      <!-- ═══════════════ PERSONELLER ═══════════════ -->
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
                    v-for="item in departmentData"
                    :key="item.name"
                    cx="40" cy="40" r="32"
                    class="donut-segment"
                    stroke-width="10"
                    :stroke="item.color"
                    :style="miniDonutStroke(item)"
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
            <button class="primary-btn add-personnel-btn" type="button">
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

      <!-- ═══════════════ ANALİZLER ═══════════════ -->
      <template v-else-if="activeTab === 'Analizler'">
        <section class="section-block">
          <div class="section-title-row">
            <div><h2>Analizler</h2><span></span></div>
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
                    v-for="item in departmentData"
                    :key="item.name"
                    cx="60" cy="60" r="50"
                    class="donut-segment"
                    :stroke="item.color"
                    :style="donutStroke(item)"
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
            <button class="primary-btn" type="button">Detaylı Raporlar</button>
          </div>
        </section>
      </template>

    </main>

    <footer class="footer">Copyright İK Analiz {{ new Date().getFullYear() }}</footer>
  </div>
</template>
