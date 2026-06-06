<script setup>
import { computed, ref, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';
import { useUserStore } from '@/stores/user';
import { useAnalyticsStore } from '@/stores/analytics';
import { useQuestionStore } from '@/stores/question';
import { useCategoryStore } from '@/stores/category';
import { useDepartmentStore } from '@/stores/department';
import { useTestStore } from '@/stores/tests';

const router = useRouter();
const auth = useAuthStore();
const userStore = useUserStore();
const analyticsStore = useAnalyticsStore();
const questionStore = useQuestionStore();
const categoryStore = useCategoryStore();
const departmentStore = useDepartmentStore();
const testStore = useTestStore();

const DEPT_COLORS = ['#2E7D7A', '#5FB7C1', '#95D5D0', '#B2E0DD', '#E8F4F8', '#3DBDB0', '#1A5F5C'];
const ACCENT_CYCLE = ['teal', 'blue', 'coral'];
const OPTION_LABELS = ['A', 'B', 'C', 'D', 'E', 'F'];
const ROLE_LABELS = { admin: 'Yönetici', hr: 'İK Direktörü', employee: 'Personel' };

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
const statusFilter = ref('Tümü');
const togglingIds = ref([]);

// ─── Wizard step 1 ─────────────────────────────────────────────────────────
const wizardStep = ref(1);
const testTitle = ref('');
const testCategoryId = ref('');
const testType = ref('multiple_choice');
const testDifficulty = ref(3);
const step1Error = ref('');

// ─── Inline category creation ──────────────────────────────────────────────
const showAddCategoryInline = ref(false);
const newCategoryName = ref('');
const newCategoryDesc = ref('');
const addCategoryLoading = ref(false);
const addCategoryError = ref('');

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

// ─── Test sub-view ─────────────────────────────────────────────────────────
const testSubView = ref('wizard');

// ─── Test expand / assignments ─────────────────────────────────────────────
const expandedTestId = ref(null);
const testAssignmentsMap = ref({});
const assignmentsLoadingId = ref(null);

const ASSIGNMENT_STATUS_LABELS = {
  pending: 'Bekliyor',
  in_progress: 'Devam Ediyor',
  completed: 'Tamamlandı',
  expired: 'Süresi Doldu',
};
const ASSIGNMENT_STATUS_CLASSES = {
  pending: 'asgn-pending',
  in_progress: 'asgn-inprogress',
  completed: 'asgn-completed',
  expired: 'asgn-expired',
};

// ─── Existing question picker ──────────────────────────────────────────────
const showExistingPicker = ref(false);
const pickerStep = ref('tests');
const pickerSelectedTest = ref(null);
const pickerTestQuestions = ref([]);
const pickerLoading = ref(false);
const pickerAddedQuestions = ref([]);

// ─── Saved test assign modal ───────────────────────────────────────────────
const showSavedTestAssignModal = ref(false);
const savedTestAssignTarget = ref(null);
const savedTestAssignEmployeeIds = ref([]);
const savedTestAlreadyAssignedIds = ref([]);
const savedTestAssignLoading = ref(false);
const savedTestAssignError = ref('');
const savedTestAssignSuccess = ref('');

// ─── Assign test modal ─────────────────────────────────────────────────────
const showAssignTestModal = ref(false);
const assignTarget = ref(null);
const assignLoading = ref(false);
const assignError = ref('');
const assignSuccess = ref('');

// ─── Employee report modal ─────────────────────────────────────────────────
const showEmployeeReportModal = ref(false);
const employeeReportTarget = ref(null);
const employeeReportData = ref(null);
const employeeReportLoading = ref(false);

// ─── Employee add modal ────────────────────────────────────────────────────
const showAddEmployeeModal = ref(false);
const addEmployeeLoading = ref(false);
const addEmployeeError = ref('');
const newEmployee = ref(defaultEmployee());

function defaultEmployee() {
  return { fullName: '', email: '', password: '', role: 'employee', departmentId: '' };
}

// ─── Department management ─────────────────────────────────────────────────
const showDepartmentModal = ref(false);
const departmentModalMode = ref('create');
const departmentForm = ref({ id: null, name: '', managerId: '' });
const departmentLoading = ref(false);
const departmentError = ref('');
const departmentDeletingId = ref(null);

// ─── Edit employee modal ──────────────────────────────────────────────────
const showEditEmployeeModal = ref(false);
const editEmployeeTarget = ref(null);
const editEmployeeForm = ref({ fullName: '', role: 'employee', departmentId: '', isActive: true });
const editEmployeeLoading = ref(false);
const editEmployeeError = ref('');

// ─── Computed ──────────────────────────────────────────────────────────────

const employees = computed(() =>
  userStore.users.map((u, i) => ({
    id: u._id,
    name: u.fullName,
    email: u.email,
    dept: u.departmentId?.name ?? '—',
    role: u.role,
    roleLabel: ROLE_LABELS[u.role] ?? u.role,
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
  if (statusFilter.value === 'Aktif') result = result.filter((e) => e.isActive);
  else if (statusFilter.value === 'Pasif') result = result.filter((e) => !e.isActive);
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

const showReportDetailModal = ref(false);
const reportDetail = ref(null);
const reportDetailLoading = ref(false);
const reportDetailError = ref('');

// ─── Detailed analytics state ──────────────────────────────────────────────
const detailViewMode = ref('test');
const detailSelectedTestId = ref('');
const detailSelectedQuestionId = ref('');
const detailSelectedDepartmentId = ref('');
const detailSelectedEmployeeId = ref('');
const detailTestData = ref(null);
const detailQuestionData = ref(null);
const detailDepartmentData = ref(null);
const detailEmployeeData = ref(null);
const detailLoading = ref(false);
const detailError = ref('');

const selectedCategoryName = computed(() => {
  if (!testCategoryId.value) return '—';
  return categoryStore.categories.find((c) => c._id === testCategoryId.value)?.name ?? '—';
});

const activeEmployees = computed(() => filteredEmployees.value.filter((e) => e.isActive));
const inactiveEmployees = computed(() => filteredEmployees.value.filter((e) => !e.isActive));

const recentTests = computed(() => testStore.tests.slice(0, 2));

const selectedQuestionsDetails = computed(() =>
  selectedQuestionIds.value
    .map(
      (id) =>
        questionStore.questions.find((q) => q._id === id) ??
        pickerAddedQuestions.value.find((q) => q._id === id)
    )
    .filter(Boolean)
);

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
  pickerAddedQuestions.value = [];
  showAddQuestionForm.value = false;
  newQuestion.value = defaultQuestion();
  publishSuccess.value = false;
  wizardStep.value = 1;
}

const publishLoading = ref(false);

async function publishTest() {
  if (!selectedQuestionIds.value.length) {
    step3Error.value = 'En az bir soru seçmelisiniz.';
    return;
  }
  if (!selectedEmployeeIds.value.length) {
    step3Error.value = 'En az bir personel seçin.';
    return;
  }
  step3Error.value = '';
  publishLoading.value = true;
  try {
    const test = await testStore.createTest({
      title: testTitle.value,
      ...(testCategoryId.value && { categoryId: testCategoryId.value }),
      type: testType.value,
      difficulty: testDifficulty.value,
      questionIds: selectedQuestionIds.value,
    });
    await testStore.assignTest(test._id, selectedEmployeeIds.value);
    publishedTestName.value = testTitle.value;
    publishSuccess.value = true;
    setTimeout(() => resetWizard(), 2500);
  } catch (err) {
    step3Error.value = err.response?.data?.message ?? 'Test oluşturulamadı, tekrar deneyin.';
  } finally {
    publishLoading.value = false;
  }
}

async function openAssignTestModal(emp) {
  assignTarget.value = emp;
  assignError.value = '';
  assignSuccess.value = '';
  showAssignTestModal.value = true;
  if (!testStore.tests.length) {
    await testStore.fetchTests({ isActive: true }).catch(() => {});
  }
}

async function assignExistingTest(test) {
  assignError.value = '';
  assignSuccess.value = '';
  assignLoading.value = true;
  try {
    const result = await testStore.assignTest(test._id, [assignTarget.value.id]);
    if (result.assigned === 0) {
      assignError.value = `"${test.title}" testi bu personele zaten atanmış.`;
    } else {
      assignSuccess.value = `"${test.title}" testi ${assignTarget.value.name} personeline atandı.`;
    }
  } catch (err) {
    assignError.value = err.response?.data?.message ?? 'Atama başarısız, tekrar deneyin.';
  } finally {
    assignLoading.value = false;
  }
}

function startFreshTestForEmployee() {
  resetWizard();
  selectedEmployeeIds.value = [assignTarget.value.id];
  showAssignTestModal.value = false;
  activeTab.value = 'Test Oluşturma';
  if (questionStore.questions.length === 0) {
    questionLoading.value = true;
    Promise.all([questionStore.fetchQuestions(), categoryStore.fetchCategories()])
      .finally(() => { questionLoading.value = false; });
  }
}

async function openReportDetail(report) {
  reportDetail.value = null;
  reportDetailError.value = '';
  reportDetailLoading.value = true;
  showReportDetailModal.value = true;
  try {
    reportDetail.value = await analyticsStore.fetchReport(report._id);
  } catch (err) {
    reportDetailError.value = err.response?.data?.message ?? 'Rapor yüklenemedi.';
  } finally {
    reportDetailLoading.value = false;
  }
}

function scoreClass(score) {
  if (score == null) return '';
  if (score >= 70) return 'score-good';
  if (score >= 40) return 'score-medium';
  return 'score-bad';
}

async function loadTestDetail() {
  if (!detailSelectedTestId.value) {
    detailTestData.value = null;
    return;
  }
  detailLoading.value = true;
  detailError.value = '';
  try {
    detailTestData.value = await analyticsStore.fetchTestAnalytics(detailSelectedTestId.value);
  } catch (err) {
    detailError.value = err.response?.data?.message ?? 'Test analizi yüklenemedi.';
    detailTestData.value = null;
  } finally {
    detailLoading.value = false;
  }
}

async function loadQuestionDetail() {
  if (!detailSelectedQuestionId.value) {
    detailQuestionData.value = null;
    return;
  }
  detailLoading.value = true;
  detailError.value = '';
  try {
    detailQuestionData.value = await analyticsStore.fetchQuestionDetail(detailSelectedQuestionId.value);
  } catch (err) {
    detailError.value = err.response?.data?.message ?? 'Soru analizi yüklenemedi.';
    detailQuestionData.value = null;
  } finally {
    detailLoading.value = false;
  }
}

async function loadDepartmentDetail() {
  if (!detailSelectedDepartmentId.value) {
    detailDepartmentData.value = null;
    return;
  }
  detailLoading.value = true;
  detailError.value = '';
  try {
    detailDepartmentData.value = await analyticsStore.fetchDepartmentDetail(detailSelectedDepartmentId.value);
  } catch (err) {
    detailError.value = err.response?.data?.message ?? 'Departman analizi yüklenemedi.';
    detailDepartmentData.value = null;
  } finally {
    detailLoading.value = false;
  }
}

async function loadEmployeeDetail() {
  if (!detailSelectedEmployeeId.value) {
    detailEmployeeData.value = null;
    return;
  }
  detailLoading.value = true;
  detailError.value = '';
  try {
    detailEmployeeData.value = await analyticsStore.fetchEmployeeAnalytics(detailSelectedEmployeeId.value);
  } catch (err) {
    detailError.value = err.response?.data?.message ?? 'Personel analizi yüklenemedi.';
    detailEmployeeData.value = null;
  } finally {
    detailLoading.value = false;
  }
}

function setDetailMode(mode) {
  detailViewMode.value = mode;
  detailError.value = '';
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

async function submitAddCategory() {
  addCategoryError.value = '';
  if (!newCategoryName.value.trim()) {
    addCategoryError.value = 'Kategori adı boş bırakılamaz.';
    return;
  }
  addCategoryLoading.value = true;
  try {
    const cat = await categoryStore.createCategory({
      name: newCategoryName.value.trim(),
      ...(newCategoryDesc.value.trim() && { description: newCategoryDesc.value.trim() }),
    });
    testCategoryId.value = cat._id;
    newCategoryName.value = '';
    newCategoryDesc.value = '';
    showAddCategoryInline.value = false;
  } catch (err) {
    addCategoryError.value = err.response?.data?.message ?? 'Kategori oluşturulamadı.';
  } finally {
    addCategoryLoading.value = false;
  }
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

async function toggleUserActive(emp) {
  if (togglingIds.value.includes(emp.id)) return;
  togglingIds.value.push(emp.id);
  try {
    await userStore.updateUser(emp.id, { isActive: !emp.isActive });
  } catch {
    /* hata sessizce geçilir, UI değişmez */
  } finally {
    togglingIds.value = togglingIds.value.filter((id) => id !== emp.id);
  }
}

async function openEmployeeReport(emp) {
  employeeReportTarget.value = emp;
  employeeReportData.value = null;
  employeeReportLoading.value = true;
  showEmployeeReportModal.value = true;
  try {
    employeeReportData.value = await analyticsStore.fetchEmployeeAnalytics(emp.id);
  } catch {
    employeeReportData.value = null;
  } finally {
    employeeReportLoading.value = false;
  }
}

function openCreateDepartmentModal() {
  departmentModalMode.value = 'create';
  departmentForm.value = { id: null, name: '', managerId: '' };
  departmentError.value = '';
  showDepartmentModal.value = true;
}

function openEditDepartmentModal(dept) {
  departmentModalMode.value = 'edit';
  departmentForm.value = {
    id: dept._id,
    name: dept.name,
    managerId: dept.managerId?._id ?? dept.managerId ?? '',
  };
  departmentError.value = '';
  showDepartmentModal.value = true;
}

async function submitDepartmentForm() {
  departmentError.value = '';
  if (!departmentForm.value.name.trim()) {
    departmentError.value = 'Departman adı zorunludur.';
    return;
  }
  departmentLoading.value = true;
  try {
    const payload = { name: departmentForm.value.name.trim() };
    if (departmentForm.value.managerId) payload.managerId = departmentForm.value.managerId;

    if (departmentModalMode.value === 'create') {
      await departmentStore.createDepartment(payload);
    } else {
      await departmentStore.updateDepartment(departmentForm.value.id, payload);
    }
    await userStore.fetchUsers({ limit: 50 });
    showDepartmentModal.value = false;
  } catch (err) {
    departmentError.value = err.response?.data?.message ?? 'Departman kaydedilemedi.';
  } finally {
    departmentLoading.value = false;
  }
}

async function deleteDepartment(dept) {
  if (!confirm(`"${dept.name}" departmanını silmek istediğinize emin misiniz?`)) return;
  departmentDeletingId.value = dept._id;
  try {
    await departmentStore.deleteDepartment(dept._id);
    await userStore.fetchUsers({ limit: 50 });
  } catch (err) {
    alert(err.response?.data?.message ?? 'Departman silinemedi.');
  } finally {
    departmentDeletingId.value = null;
  }
}

function openEditEmployeeModal(emp) {
  const userObj = userStore.users.find((u) => u._id === emp.id);
  if (!userObj) return;
  editEmployeeTarget.value = emp;
  editEmployeeForm.value = {
    fullName: userObj.fullName,
    role: userObj.role,
    departmentId: userObj.departmentId?._id ?? userObj.departmentId ?? '',
    isActive: userObj.isActive,
  };
  editEmployeeError.value = '';
  showEditEmployeeModal.value = true;
}

async function submitEditEmployee() {
  editEmployeeError.value = '';
  if (!editEmployeeForm.value.fullName.trim()) {
    editEmployeeError.value = 'Ad soyad zorunludur.';
    return;
  }
  editEmployeeLoading.value = true;
  try {
    const payload = {
      fullName: editEmployeeForm.value.fullName.trim(),
      role: editEmployeeForm.value.role,
      isActive: editEmployeeForm.value.isActive,
    };
    if (editEmployeeForm.value.departmentId) {
      payload.departmentId = editEmployeeForm.value.departmentId;
    }
    await userStore.updateUser(editEmployeeTarget.value.id, payload);
    await userStore.fetchUsers({ limit: 50 });
    showEditEmployeeModal.value = false;
  } catch (err) {
    editEmployeeError.value = err.response?.data?.message ?? 'Personel güncellenemedi.';
  } finally {
    editEmployeeLoading.value = false;
  }
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

// ─── Saved tests ───────────────────────────────────────────────────────────

async function toggleTestExpand(test) {
  if (expandedTestId.value === test._id) {
    expandedTestId.value = null;
    return;
  }
  expandedTestId.value = test._id;
  if (testAssignmentsMap.value[test._id]) return;
  assignmentsLoadingId.value = test._id;
  try {
    const assignments = await testStore.fetchTestAssignments(test._id);
    testAssignmentsMap.value = { ...testAssignmentsMap.value, [test._id]: assignments };
  } catch {
    testAssignmentsMap.value = { ...testAssignmentsMap.value, [test._id]: [] };
  } finally {
    assignmentsLoadingId.value = null;
  }
}

async function openSavedTestAssign(test) {
  savedTestAssignTarget.value = test;
  savedTestAssignError.value = '';
  savedTestAssignSuccess.value = '';

  let assignments = testAssignmentsMap.value[test._id];
  if (!assignments) {
    try {
      assignments = await testStore.fetchTestAssignments(test._id);
      testAssignmentsMap.value = { ...testAssignmentsMap.value, [test._id]: assignments };
    } catch {
      assignments = [];
    }
  }

  const alreadyIds = assignments.map(a => a.assignedTo._id);
  savedTestAlreadyAssignedIds.value = alreadyIds;
  savedTestAssignEmployeeIds.value = [...alreadyIds];
  showSavedTestAssignModal.value = true;
}

async function submitSavedTestAssign() {
  const newIds = savedTestAssignEmployeeIds.value.filter(
    id => !savedTestAlreadyAssignedIds.value.includes(id)
  );
  if (!newIds.length) {
    savedTestAssignError.value = savedTestAssignEmployeeIds.value.length
      ? 'Seçili personellere bu test zaten atanmış.'
      : 'En az bir personel seçin.';
    return;
  }
  savedTestAssignLoading.value = true;
  savedTestAssignError.value = '';
  try {
    const result = await testStore.assignTest(savedTestAssignTarget.value._id, newIds);
    const updatedAlready = [...savedTestAlreadyAssignedIds.value, ...newIds];
    savedTestAlreadyAssignedIds.value = updatedAlready;
    savedTestAssignEmployeeIds.value = [...updatedAlready];
    const newMap = { ...testAssignmentsMap.value };
    delete newMap[savedTestAssignTarget.value._id];
    testAssignmentsMap.value = newMap;
    if (result.skipped > 0) {
      savedTestAssignSuccess.value = `Test ${result.assigned} personele atandı. ${result.skipped} personel zaten atanmıştı.`;
    } else {
      savedTestAssignSuccess.value = `Test ${result.assigned} personele başarıyla atandı.`;
    }
  } catch (err) {
    savedTestAssignError.value = err.response?.data?.message ?? 'Atama başarısız.';
  } finally {
    savedTestAssignLoading.value = false;
  }
}

// ─── Existing question picker ──────────────────────────────────────────────

function openExistingPicker() {
  showExistingPicker.value = true;
  pickerStep.value = 'tests';
  pickerSelectedTest.value = null;
  pickerTestQuestions.value = [];
}

async function selectPickerTest(test) {
  pickerLoading.value = true;
  pickerSelectedTest.value = test;
  pickerStep.value = 'questions';
  try {
    const full = await testStore.fetchTest(test._id);
    pickerTestQuestions.value = full.questionIds ?? [];
  } catch {
    pickerTestQuestions.value = [];
  } finally {
    pickerLoading.value = false;
  }
}

function addPickerQuestion(q) {
  if (selectedQuestionIds.value.includes(q._id)) return;
  selectedQuestionIds.value.push(q._id);
  if (!pickerAddedQuestions.value.find((pq) => pq._id === q._id)) {
    pickerAddedQuestions.value.push(q);
  }
}

function isPickerQuestionAdded(id) {
  return selectedQuestionIds.value.includes(id);
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
      await Promise.all([
        analyticsStore.listReports(),
        analyticsStore.fetchQuestionAnalytics(),
        testStore.tests.length ? Promise.resolve() : testStore.fetchTests({ limit: 100 }),
      ]);
    } catch { /* non-critical */ }
  }
});

// ─── Lifecycle ─────────────────────────────────────────────────────────────

onMounted(async () => {
  try {
    await Promise.all([
      auth.user ? Promise.resolve() : auth.fetchMe(),
      userStore.fetchUsers({ limit: 50 }),
      analyticsStore.fetchOverview(),
      analyticsStore.fetchDepartments(),
      departmentStore.fetchDepartments(),
      testStore.fetchTests(),
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
              <h2>Son Oluşturulan Testler</h2>
              <a href="#" @click.prevent="activeTab = 'Test Oluşturma'">Tümünü Gör</a>
            </div>
            <div v-if="!recentTests.length" class="empty-state small">
              <p>Henüz oluşturulmuş test yok.</p>
            </div>
            <div v-else class="draft-grid">
              <article v-for="test in recentTests" :key="test._id" class="draft-card">
                <div>
                  <h3>{{ test.title }}</h3>
                  <p>{{ test.categoryId?.name ?? 'Genel' }} · {{ test.questionIds?.length ?? 0 }} Soru</p>
                </div>
                <button
                  class="secondary-btn"
                  type="button"
                  style="padding:6px 14px;font-size:0.8rem;flex-shrink:0;"
                  @click="openSavedTestAssign(test)"
                >Ata</button>
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
                <button type="button" @click="openAssignTestModal(emp)">Test ata</button>
                <button type="button" @click="openEmployeeReport(emp)">Raporu gör</button>
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

        <!-- Sub-tabs -->
        <div class="test-subview-tabs">
          <button
            class="subview-tab"
            :class="{ active: testSubView === 'wizard' }"
            type="button"
            @click="testSubView = 'wizard'"
          >Yeni Test Oluştur</button>
          <button
            class="subview-tab"
            :class="{ active: testSubView === 'saved' }"
            type="button"
            @click="testSubView = 'saved'"
          >Kayıtlı Testler</button>
        </div>

        <!-- Kayıtlı Testler view -->
        <template v-if="testSubView === 'saved'">
          <section class="section-block card-surface" style="padding:28px;border-radius:26px;">
            <div class="section-title-row" style="margin-bottom:20px;">
              <div><h2>Kayıtlı Testler</h2><span></span></div>
            </div>
            <template v-if="testStore.loading">
              <div style="text-align:center;padding:24px;">
                <div class="spinner" style="width:32px;height:32px;margin:0 auto;"></div>
              </div>
            </template>
            <div v-else-if="!testStore.tests.length" class="empty-state">
              <p>Henüz oluşturulmuş test yok.</p>
            </div>
            <div v-else class="saved-tests-list">
              <div
                v-for="test in testStore.tests"
                :key="test._id"
                class="saved-test-card"
                :class="{ 'saved-test-expanded': expandedTestId === test._id }"
              >
                <!-- Row header (clickable) -->
                <div class="saved-test-row" @click="toggleTestExpand(test)">
                  <div class="saved-test-info">
                    <div class="saved-test-title-row">
                      <strong>{{ test.title }}</strong>
                      <span
                        class="emp-status-badge"
                        :class="test.isActive ? 'status-active' : 'status-inactive'"
                      >{{ test.isActive ? 'Aktif' : 'Pasif' }}</span>
                    </div>
                    <p>
                      {{ test.categoryId?.name ?? 'Genel' }}
                      · {{ TYPE_LABELS[test.type] ?? test.type }}
                      · {{ test.questionIds?.length ?? 0 }} soru
                      · Zorluk {{ test.difficulty }}/5
                      <template v-if="test.createdBy?.fullName"> · {{ test.createdBy.fullName }}</template>
                    </p>
                  </div>
                  <div class="saved-test-row-actions" @click.stop>
                    <button
                      class="primary-btn"
                      type="button"
                      style="padding:8px 16px;font-size:0.82rem;"
                      :disabled="!test.isActive"
                      @click="openSavedTestAssign(test)"
                    >Ata →</button>
                    <span class="expand-chevron" :class="{ rotated: expandedTestId === test._id }">▾</span>
                  </div>
                </div>

                <!-- Assignments panel -->
                <div v-if="expandedTestId === test._id" class="test-assignments-panel">
                  <div v-if="assignmentsLoadingId === test._id" class="assignments-loading">
                    <div class="spinner" style="width:24px;height:24px;border-width:3px;"></div>
                  </div>
                  <template v-else-if="testAssignmentsMap[test._id]">
                    <p v-if="!testAssignmentsMap[test._id].length" class="assignments-empty">
                      Bu teste henüz personel atanmamış.
                    </p>
                    <div v-else class="assignments-list">
                      <div
                        v-for="a in testAssignmentsMap[test._id]"
                        :key="a._id"
                        class="assignment-row"
                      >
                        <div class="assignee-avatar-sm">
                          {{ a.assignedTo?.fullName?.split(' ').slice(0,2).map(w=>w[0]).join('').toUpperCase() ?? '?' }}
                        </div>
                        <div class="assignment-info">
                          <strong>{{ a.assignedTo?.fullName ?? '—' }}</strong>
                          <p>{{ a.assignedTo?.email ?? '' }}</p>
                        </div>
                        <span
                          class="asgn-status-badge"
                          :class="ASSIGNMENT_STATUS_CLASSES[a.status]"
                        >{{ ASSIGNMENT_STATUS_LABELS[a.status] ?? a.status }}</span>
                      </div>
                    </div>
                  </template>
                </div>
              </div>
            </div>
          </section>
        </template>

        <!-- Wizard view -->
        <template v-else-if="testSubView === 'wizard'">

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
                <div class="category-field-header">
                  <label class="field-label">Kategori</label>
                  <button
                    class="add-category-toggle"
                    type="button"
                    @click="showAddCategoryInline = !showAddCategoryInline; addCategoryError = ''"
                  >
                    {{ showAddCategoryInline ? '✕ İptal' : '+ Yeni Kategori' }}
                  </button>
                </div>

                <select
                  v-if="!showAddCategoryInline"
                  v-model="testCategoryId"
                  class="field-select"
                >
                  <option value="">Kategori seçin…</option>
                  <option v-for="cat in categoryStore.categories" :key="cat._id" :value="cat._id">
                    {{ cat.name }}
                  </option>
                </select>

                <div v-else class="add-category-inline">
                  <input
                    v-model="newCategoryName"
                    class="field-input"
                    type="text"
                    placeholder="Kategori adı (örn. Vue.js, Satış Becerileri…)"
                    maxlength="100"
                    @keyup.enter="submitAddCategory"
                  />
                  <input
                    v-model="newCategoryDesc"
                    class="field-input"
                    type="text"
                    placeholder="Açıklama (opsiyonel)"
                    maxlength="500"
                  />
                  <p v-if="addCategoryError" class="form-error">{{ addCategoryError }}</p>
                  <div class="add-category-actions">
                    <button
                      class="secondary-btn"
                      type="button"
                      @click="showAddCategoryInline = false; newCategoryName = ''; newCategoryDesc = ''; addCategoryError = ''"
                    >İptal</button>
                    <button
                      class="primary-btn"
                      type="button"
                      :disabled="addCategoryLoading"
                      @click="submitAddCategory"
                    >
                      {{ addCategoryLoading ? 'Kaydediliyor…' : 'Kategori Kaydet' }}
                    </button>
                  </div>
                </div>
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
                  v-if="!testCategoryId"
                  class="no-category-notice card-surface"
                >
                  <span class="no-category-icon">⚠️</span>
                  <div>
                    <strong>Kategori seçilmedi</strong>
                    <p>Soru ekleyebilmek için önce bir kategori seçmeniz gerekiyor.</p>
                  </div>
                  <button class="secondary-btn" type="button" @click="prevStep">
                    Adım 1'e Dön
                  </button>
                </div>

                <div class="question-flow">
                  <!-- Action buttons -->
                  <div v-if="!showAddQuestionForm && testCategoryId" class="step2-actions">
                    <button class="secondary-btn" type="button" @click="showAddQuestionForm = true">
                      + Yeni Soru Oluştur
                    </button>
                    <button class="secondary-btn" type="button" @click="openExistingPicker">
                      Mevcut Sınavdan Seç
                    </button>
                  </div>

                  <!-- Selected questions list -->
                  <div v-if="selectedQuestionsDetails.length" class="selected-questions-section">
                    <p class="selected-q-label">Seçilen Sorular ({{ selectedQuestionsDetails.length }})</p>
                    <div v-for="(q, i) in selectedQuestionsDetails" :key="q._id" class="question-row">
                      <div class="q-left">
                        <div class="question-num-badge q-badge-selected">{{ i + 1 }}</div>
                        <div class="q-connector"></div>
                      </div>
                      <div class="question-card card-surface q-card-selected">
                        <div class="question-card-header">
                          <h3>{{ q.categoryId?.name ?? 'Soru' }} {{ i + 1 }}</h3>
                          <button
                            class="question-select-toggle selected"
                            type="button"
                            @click="toggleQuestion(q._id)"
                          >✓ Kaldır</button>
                        </div>
                        <p class="question-body">{{ q.text }}</p>
                        <div v-if="q.options?.length" class="question-options">
                          <div v-for="(opt, j) in q.options" :key="j" class="option-row">
                            <span class="option-label-badge" :class="{ 'opt-correct': opt.isCorrect }">{{ OPTION_LABELS[j] }}</span>
                            <span class="option-text-bar">{{ opt.text }}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div
                    v-else-if="!showAddQuestionForm && testCategoryId"
                    class="empty-state card-surface"
                    style="border-radius:20px;padding:40px;"
                  >
                    <p>Henüz soru eklenmedi. Yukarıdan yeni soru oluşturun veya mevcut sınavdan seçin.</p>
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
              <button class="primary-btn" type="button" :disabled="publishLoading" @click="publishTest">
                {{ publishLoading ? 'Yayınlanıyor…' : 'Testi Yayınla 🚀' }}
              </button>
            </div>
          </section>
        </template>
        </template><!-- /testSubView === 'wizard' -->
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

          <div class="dept-manage-card card-surface">
            <div class="dept-manage-header">
              <h2>Departmanlar</h2>
              <button class="primary-btn dept-add-btn" type="button" @click="openCreateDepartmentModal">
                + Yeni Departman
              </button>
            </div>
            <div v-if="!departmentStore.departments.length" class="empty-state small">
              <p>Henüz departman eklenmemiş.</p>
            </div>
            <div v-else class="dept-list">
              <div v-for="dept in departmentStore.departments" :key="dept._id" class="dept-row">
                <div class="dept-row-info">
                  <strong>{{ dept.name }}</strong>
                  <p>{{ dept.managerId?.fullName ? `Yönetici: ${dept.managerId.fullName}` : 'Yönetici atanmamış' }}</p>
                </div>
                <div class="dept-row-actions">
                  <button class="dept-action-btn" type="button" @click="openEditDepartmentModal(dept)">Düzenle</button>
                  <button
                    class="dept-action-btn dept-action-danger"
                    type="button"
                    :disabled="departmentDeletingId === dept._id"
                    @click="deleteDepartment(dept)"
                  >{{ departmentDeletingId === dept._id ? '…' : 'Sil' }}</button>
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
            <button class="primary-btn add-personnel-btn" type="button" @click="openAddEmployeeModal">
              Yeni Personel Ekle +
            </button>
          </div>
        </div>

        <!-- Aktif Personeller -->
        <section class="section-block">
          <div class="section-title-row">
            <div><h2>Aktif Personeller</h2><span></span></div>
            <span class="section-count">{{ activeEmployees.length }}</span>
          </div>
          <div v-if="!activeEmployees.length" class="empty-state">
            <p>Aktif personel bulunamadı.</p>
          </div>
          <div v-else class="employee-grid">
            <article
              v-for="emp in activeEmployees"
              :key="emp.id"
              class="employee-card"
              :class="emp.accent"
            >
              <div class="employee-head">
                <div class="employee-avatar">{{ emp.initial }}</div>
                <div class="employee-head-info">
                  <div class="employee-name-row">
                    <h3>{{ emp.name }}</h3>
                    <span class="emp-role-badge">{{ emp.roleLabel }}</span>
                  </div>
                  <p class="emp-dept">{{ emp.dept }}</p>
                  <p class="emp-email">{{ emp.email }}</p>
                </div>
              </div>
              <div class="employee-actions">
                <button type="button" @click="openAssignTestModal(emp)">Test ata</button>
                <button type="button" @click="openEmployeeReport(emp)">Raporu gör</button>
                <button type="button" @click="openEditEmployeeModal(emp)">Düzenle</button>
                <button
                  type="button"
                  class="emp-toggle-btn emp-deactivate"
                  :disabled="togglingIds.includes(emp.id)"
                  @click="toggleUserActive(emp)"
                >{{ togglingIds.includes(emp.id) ? '…' : 'Deaktif Et' }}</button>
              </div>
            </article>
          </div>
        </section>

        <!-- Pasif Personeller -->
        <section v-if="inactiveEmployees.length" class="section-block">
          <div class="section-title-row">
            <div><h2>Pasif / Deaktif Personeller</h2><span></span></div>
            <span class="section-count section-count-inactive">{{ inactiveEmployees.length }}</span>
          </div>
          <div class="employee-grid">
            <article
              v-for="emp in inactiveEmployees"
              :key="emp.id"
              class="employee-card emp-inactive"
              :class="emp.accent"
            >
              <div class="employee-head">
                <div class="employee-avatar">{{ emp.initial }}</div>
                <div class="employee-head-info">
                  <div class="employee-name-row">
                    <h3>{{ emp.name }}</h3>
                    <span class="emp-role-badge">{{ emp.roleLabel }}</span>
                  </div>
                  <p class="emp-dept">{{ emp.dept }}</p>
                  <p class="emp-email">{{ emp.email }}</p>
                </div>
              </div>
              <div class="employee-actions">
                <button type="button" @click="openEditEmployeeModal(emp)">Düzenle</button>
                <button
                  type="button"
                  class="emp-toggle-btn emp-activate"
                  :disabled="togglingIds.includes(emp.id)"
                  @click="toggleUserActive(emp)"
                >{{ togglingIds.includes(emp.id) ? '…' : 'Aktif Et' }}</button>
              </div>
            </article>
          </div>
        </section>
      </template>

      <!-- ══════════════════════ ANALİZLER ══════════════════════ -->
      <template v-else-if="activeTab === 'Analizler'">

        <!-- Detailed Analytics -->
        <section class="section-block detail-analytics-card card-surface">
          <div class="section-title-row" style="margin-bottom:18px;">
            <div><h2>Detaylı Analizler</h2><span></span></div>
          </div>

          <div class="test-subview-tabs">
            <button
              class="subview-tab"
              :class="{ active: detailViewMode === 'test' }"
              type="button"
              @click="setDetailMode('test')"
            >Test Bazlı</button>
            <button
              class="subview-tab"
              :class="{ active: detailViewMode === 'question' }"
              type="button"
              @click="setDetailMode('question')"
            >Soru Bazlı</button>
            <button
              class="subview-tab"
              :class="{ active: detailViewMode === 'department' }"
              type="button"
              @click="setDetailMode('department')"
            >Departman Bazlı</button>
            <button
              class="subview-tab"
              :class="{ active: detailViewMode === 'employee' }"
              type="button"
              @click="setDetailMode('employee')"
            >Personel Bazlı</button>
          </div>

          <!-- Test detail -->
          <template v-if="detailViewMode === 'test'">
            <div class="detail-selector-row">
              <div class="field-group">
                <label class="field-label">Test Seçin</label>
                <select v-model="detailSelectedTestId" class="field-select" @change="loadTestDetail">
                  <option value="">Test seçin…</option>
                  <option v-for="t in testStore.tests" :key="t._id" :value="t._id">{{ t.title }}</option>
                </select>
              </div>
            </div>

            <div v-if="detailLoading" style="text-align:center;padding:24px;">
              <div class="spinner" style="width:32px;height:32px;margin:0 auto;"></div>
            </div>
            <p v-else-if="detailError" class="form-error">{{ detailError }}</p>
            <template v-else-if="detailTestData">
              <div class="detail-stats-grid">
                <div class="detail-stat-tile">
                  <span>Atanan</span>
                  <strong>{{ detailTestData.summary?.assignedCount ?? 0 }}</strong>
                </div>
                <div class="detail-stat-tile">
                  <span>Tamamlayan</span>
                  <strong>{{ detailTestData.summary?.completedCount ?? 0 }}</strong>
                </div>
                <div class="detail-stat-tile">
                  <span>Ort. Başarı</span>
                  <strong>%{{ (detailTestData.summary?.avgScore ?? 0).toFixed(1) }}</strong>
                </div>
                <div class="detail-stat-tile">
                  <span>En Yüksek</span>
                  <strong>%{{ detailTestData.summary?.maxScore ?? 0 }}</strong>
                </div>
                <div class="detail-stat-tile">
                  <span>En Düşük</span>
                  <strong>%{{ detailTestData.summary?.minScore ?? 0 }}</strong>
                </div>
              </div>

              <p class="detail-subhead">Personel Performansı</p>
              <div class="detail-table-wrap">
                <table class="detail-table">
                  <thead>
                    <tr>
                      <th>Personel</th>
                      <th>Departman</th>
                      <th>Durum</th>
                      <th>Doğru</th>
                      <th>Skor</th>
                      <th>Tamamlama</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="row in detailTestData.userPerformance" :key="row.userId">
                      <td><strong>{{ row.fullName }}</strong></td>
                      <td>{{ row.departmentName ?? '—' }}</td>
                      <td>
                        <span class="asgn-status-badge" :class="ASSIGNMENT_STATUS_CLASSES[row.status]">
                          {{ ASSIGNMENT_STATUS_LABELS[row.status] ?? row.status }}
                        </span>
                      </td>
                      <td>{{ row.correctCount ?? '—' }}/{{ row.totalQuestions ?? '—' }}</td>
                      <td>
                        <span :class="scoreClass(row.scorePercent)">
                          {{ row.scorePercent != null ? `%${row.scorePercent}` : '—' }}
                        </span>
                      </td>
                      <td>{{ row.completedAt ? new Date(row.completedAt).toLocaleDateString('tr-TR') : '—' }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <p class="detail-subhead">Soru Bazlı Hata Oranları</p>
              <div class="detail-table-wrap">
                <table class="detail-table">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>Soru</th>
                      <th>Deneme</th>
                      <th>Yanlış</th>
                      <th>Hata Oranı</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(q, i) in detailTestData.questionStats" :key="q.questionId">
                      <td>{{ i + 1 }}</td>
                      <td><strong>{{ q.text }}</strong></td>
                      <td>{{ q.totalAttempts }}</td>
                      <td>{{ q.wrongCount }}</td>
                      <td>
                        <span :class="scoreClass(100 - (q.errorRate ?? 0))">
                          %{{ (q.errorRate ?? 0).toFixed(1) }}
                        </span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <p class="detail-subhead">Departman Bazlı Performans</p>
              <div class="detail-table-wrap">
                <table class="detail-table">
                  <thead>
                    <tr>
                      <th>Departman</th>
                      <th>Tamamlayan</th>
                      <th>Ort. Skor</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="d in detailTestData.departmentBreakdown" :key="d.departmentName">
                      <td><strong>{{ d.departmentName }}</strong></td>
                      <td>{{ d.completedCount }}</td>
                      <td>
                        <span :class="scoreClass(d.avgScore)">%{{ (d.avgScore ?? 0).toFixed(1) }}</span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </template>
            <div v-else class="empty-state small"><p>Detayları görmek için bir test seçin.</p></div>
          </template>

          <!-- Question detail -->
          <template v-else-if="detailViewMode === 'question'">
            <div class="detail-selector-row">
              <div class="field-group">
                <label class="field-label">Soru Seçin (En Çok Yanlış Yapılanlar)</label>
                <select v-model="detailSelectedQuestionId" class="field-select" @change="loadQuestionDetail">
                  <option value="">Soru seçin…</option>
                  <option
                    v-for="q in analyticsStore.questionStats"
                    :key="q._id"
                    :value="q._id"
                  >{{ q.questionText?.slice(0, 80) }}{{ q.questionText?.length > 80 ? '…' : '' }}</option>
                </select>
              </div>
            </div>

            <div v-if="detailLoading" style="text-align:center;padding:24px;">
              <div class="spinner" style="width:32px;height:32px;margin:0 auto;"></div>
            </div>
            <p v-else-if="detailError" class="form-error">{{ detailError }}</p>
            <template v-else-if="detailQuestionData">
              <div class="detail-stats-grid">
                <div class="detail-stat-tile">
                  <span>Toplam Deneme</span>
                  <strong>{{ detailQuestionData.summary?.totalAttempts ?? 0 }}</strong>
                </div>
                <div class="detail-stat-tile">
                  <span>Yanlış</span>
                  <strong>{{ detailQuestionData.summary?.wrongCount ?? 0 }}</strong>
                </div>
                <div class="detail-stat-tile">
                  <span>Hata Oranı</span>
                  <strong>%{{ (detailQuestionData.summary?.errorRate ?? 0).toFixed(1) }}</strong>
                </div>
                <div class="detail-stat-tile">
                  <span>Ort. Süre</span>
                  <strong>{{ (detailQuestionData.summary?.avgResponseTime ?? 0).toFixed(1) }}sn</strong>
                </div>
              </div>

              <p class="detail-subhead">Soru Metni</p>
              <p style="background:rgba(46,125,122,0.06);padding:12px 14px;border-radius:10px;font-size:0.9rem;">
                {{ detailQuestionData.question?.text }}
              </p>

              <p class="detail-subhead">Yanlış Cevap Veren Personeller</p>
              <div class="detail-table-wrap">
                <table class="detail-table">
                  <thead>
                    <tr>
                      <th>Personel</th>
                      <th>Departman</th>
                      <th>Seçilen Şık</th>
                      <th>Süre</th>
                      <th>Tarih</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(row, i) in detailQuestionData.wrongAnswers" :key="i">
                      <td><strong>{{ row.fullName }}</strong></td>
                      <td>{{ row.departmentName ?? '—' }}</td>
                      <td>{{ OPTION_LABELS[row.selectedOptionOrder] ?? row.selectedOptionOrder }}</td>
                      <td>{{ row.responseTimeSec != null ? `${row.responseTimeSec}sn` : '—' }}</td>
                      <td>{{ new Date(row.answeredAt).toLocaleDateString('tr-TR') }}</td>
                    </tr>
                    <tr v-if="!detailQuestionData.wrongAnswers?.length">
                      <td colspan="5" style="text-align:center;color:var(--muted);">Bu soruda yanlış cevap kaydı yok.</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </template>
            <div v-else class="empty-state small"><p>Detayları görmek için bir soru seçin.</p></div>
          </template>

          <!-- Department detail -->
          <template v-else-if="detailViewMode === 'department'">
            <div class="detail-selector-row">
              <div class="field-group">
                <label class="field-label">Departman Seçin</label>
                <select v-model="detailSelectedDepartmentId" class="field-select" @change="loadDepartmentDetail">
                  <option value="">Departman seçin…</option>
                  <option
                    v-for="d in departmentStore.departments"
                    :key="d._id"
                    :value="d._id"
                  >{{ d.name }}</option>
                </select>
              </div>
            </div>

            <div v-if="detailLoading" style="text-align:center;padding:24px;">
              <div class="spinner" style="width:32px;height:32px;margin:0 auto;"></div>
            </div>
            <p v-else-if="detailError" class="form-error">{{ detailError }}</p>
            <template v-else-if="detailDepartmentData">
              <div class="detail-stats-grid">
                <div class="detail-stat-tile">
                  <span>Personel</span>
                  <strong>{{ detailDepartmentData.summary?.employeeCount ?? 0 }}</strong>
                </div>
                <div class="detail-stat-tile">
                  <span>Tamamlanan Test</span>
                  <strong>{{ detailDepartmentData.summary?.totalSessions ?? 0 }}</strong>
                </div>
                <div class="detail-stat-tile">
                  <span>Ort. Skor</span>
                  <strong>%{{ (detailDepartmentData.summary?.avgScore ?? 0).toFixed(1) }}</strong>
                </div>
              </div>

              <p class="detail-subhead">Test Bazlı Performans</p>
              <div class="detail-table-wrap">
                <table class="detail-table">
                  <thead>
                    <tr>
                      <th>Test</th>
                      <th>Tamamlayan</th>
                      <th>Ort. Skor</th>
                      <th>En Yüksek</th>
                      <th>En Düşük</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="t in detailDepartmentData.testBreakdown" :key="t.testId">
                      <td><strong>{{ t.title }}</strong></td>
                      <td>{{ t.completedCount }}</td>
                      <td><span :class="scoreClass(t.avgScore)">%{{ (t.avgScore ?? 0).toFixed(1) }}</span></td>
                      <td>%{{ t.maxScore ?? 0 }}</td>
                      <td>%{{ t.minScore ?? 0 }}</td>
                    </tr>
                    <tr v-if="!detailDepartmentData.testBreakdown?.length">
                      <td colspan="5" style="text-align:center;color:var(--muted);">Henüz tamamlanmış test yok.</td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <p class="detail-subhead">Personel Performansı</p>
              <div class="detail-table-wrap">
                <table class="detail-table">
                  <thead>
                    <tr>
                      <th>Personel</th>
                      <th>Tamamlanan Test</th>
                      <th>Ort. Skor</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="u in detailDepartmentData.userBreakdown" :key="u.userId">
                      <td><strong>{{ u.fullName }}</strong></td>
                      <td>{{ u.completedCount }}</td>
                      <td><span :class="scoreClass(u.avgScore)">%{{ (u.avgScore ?? 0).toFixed(1) }}</span></td>
                    </tr>
                    <tr v-if="!detailDepartmentData.userBreakdown?.length">
                      <td colspan="3" style="text-align:center;color:var(--muted);">Henüz tamamlanmış oturum yok.</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </template>
            <div v-else class="empty-state small"><p>Detayları görmek için bir departman seçin.</p></div>
          </template>

          <!-- Employee detail -->
          <template v-else-if="detailViewMode === 'employee'">
            <div class="detail-selector-row">
              <div class="field-group">
                <label class="field-label">Personel Seçin</label>
                <select v-model="detailSelectedEmployeeId" class="field-select" @change="loadEmployeeDetail">
                  <option value="">Personel seçin…</option>
                  <option v-for="emp in employees" :key="emp.id" :value="emp.id">
                    {{ emp.name }} — {{ emp.dept }}
                  </option>
                </select>
              </div>
            </div>

            <div v-if="detailLoading" style="text-align:center;padding:24px;">
              <div class="spinner" style="width:32px;height:32px;margin:0 auto;"></div>
            </div>
            <p v-else-if="detailError" class="form-error">{{ detailError }}</p>
            <template v-else-if="detailEmployeeData">
              <div class="assign-target-chip" style="margin-bottom:16px;">
                <div>
                  <strong>{{ detailEmployeeData.user?.fullName }}</strong>
                  <p>{{ detailEmployeeData.user?.email }}</p>
                </div>
              </div>

              <div class="detail-stats-grid">
                <div class="detail-stat-tile">
                  <span>Tamamlanan Test</span>
                  <strong>{{ detailEmployeeData.sessionHistory?.length ?? 0 }}</strong>
                </div>
                <div class="detail-stat-tile">
                  <span>Ort. Skor</span>
                  <strong>
                    %{{
                      detailEmployeeData.sessionHistory?.length
                        ? (detailEmployeeData.sessionHistory.reduce((s, x) => s + (x.scorePercent ?? 0), 0) /
                           detailEmployeeData.sessionHistory.length).toFixed(1)
                        : '—'
                    }}
                  </strong>
                </div>
                <div class="detail-stat-tile">
                  <span>Takipteki Soru</span>
                  <strong>{{ detailEmployeeData.knowledgeStats?.totalTracked ?? 0 }}</strong>
                </div>
                <div class="detail-stat-tile">
                  <span>Tekrar Bekleyen</span>
                  <strong>{{ detailEmployeeData.knowledgeStats?.dueCount ?? 0 }}</strong>
                </div>
              </div>

              <p class="detail-subhead">Test Geçmişi</p>
              <div class="detail-table-wrap">
                <table class="detail-table">
                  <thead>
                    <tr>
                      <th>Hafta</th>
                      <th>Tür</th>
                      <th>Doğru</th>
                      <th>Skor</th>
                      <th>Tarih</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(s, i) in detailEmployeeData.sessionHistory" :key="i">
                      <td><strong>W{{ s.weekNumber }}/{{ s.year }}</strong></td>
                      <td>{{ s.sessionType === 'review' ? 'Tekrar' : 'Haftalık' }}</td>
                      <td>{{ s.correctCount }}/{{ s.totalQuestions }}</td>
                      <td><span :class="scoreClass(s.scorePercent)">%{{ s.scorePercent }}</span></td>
                      <td>{{ s.completedAt ? new Date(s.completedAt).toLocaleDateString('tr-TR') : '—' }}</td>
                    </tr>
                    <tr v-if="!detailEmployeeData.sessionHistory?.length">
                      <td colspan="5" style="text-align:center;color:var(--muted);">Henüz tamamlanmış test oturumu yok.</td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <p class="detail-subhead">Kategori Bazlı Hata Oranı</p>
              <div class="detail-table-wrap">
                <table class="detail-table">
                  <thead>
                    <tr>
                      <th>Kategori</th>
                      <th>Toplam</th>
                      <th>Yanlış</th>
                      <th>Hata Oranı</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(c, i) in detailEmployeeData.wrongByCategory" :key="i">
                      <td><strong>{{ c.categoryName }}</strong></td>
                      <td>{{ c.total }}</td>
                      <td>{{ c.wrong }}</td>
                      <td>
                        <span :class="scoreClass(100 - (c.errorRate ?? 0))">%{{ (c.errorRate ?? 0).toFixed(1) }}</span>
                      </td>
                    </tr>
                    <tr v-if="!detailEmployeeData.wrongByCategory?.length">
                      <td colspan="4" style="text-align:center;color:var(--muted);">Veri yok.</td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <p class="detail-subhead">Haftalık Trend</p>
              <div class="detail-table-wrap">
                <table class="detail-table">
                  <thead>
                    <tr>
                      <th>Dönem</th>
                      <th>Skor</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(t, i) in detailEmployeeData.weeklyTrend" :key="i">
                      <td><strong>{{ t.label }}</strong></td>
                      <td><span :class="scoreClass(t.score)">%{{ t.score }}</span></td>
                    </tr>
                    <tr v-if="!detailEmployeeData.weeklyTrend?.length">
                      <td colspan="2" style="text-align:center;color:var(--muted);">Veri yok.</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </template>
            <div v-else class="empty-state small"><p>Detayları görmek için bir personel seçin.</p></div>
          </template>
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
              class="report-list-row clickable"
              @click="openReportDetail(report)"
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

    <!-- ══════════════════════ ASSIGN TEST MODAL ══════════════════════ -->
    <div v-if="showAssignTestModal" class="modal-overlay" @click.self="showAssignTestModal = false">
      <div class="modal-card card-surface">
        <div class="modal-header">
          <h2>Test Atama</h2>
          <button class="modal-close" type="button" @click="showAssignTestModal = false">✕</button>
        </div>

        <!-- Employee chip -->
        <div v-if="assignTarget" class="assign-target-chip">
          <div class="employee-avatar small">{{ assignTarget.initial }}</div>
          <div>
            <strong>{{ assignTarget.name }}</strong>
            <p>{{ assignTarget.dept }}</p>
          </div>
        </div>

        <!-- Success / error feedback -->
        <p v-if="assignSuccess" class="assign-feedback assign-feedback-success">✓ {{ assignSuccess }}</p>
        <p v-if="assignError" class="assign-feedback assign-feedback-error">{{ assignError }}</p>

        <!-- Create fresh button -->
        <button class="assign-new-btn primary-btn" type="button" @click="startFreshTestForEmployee">
          + Yeni Test Oluştur (Sıfırdan)
        </button>

        <!-- Existing tests from API -->
        <template v-if="testStore.loading">
          <div style="text-align:center;padding:16px 0;">
            <div class="spinner" style="width:28px;height:28px;margin:0 auto;"></div>
          </div>
        </template>
        <template v-else-if="testStore.tests.length">
          <div class="assign-divider">
            <span>veya mevcut testlerden seç</span>
          </div>
          <div class="assign-tests-list">
            <div
              v-for="test in testStore.tests"
              :key="test._id"
              class="assign-test-row"
            >
              <div class="assign-test-info">
                <strong>{{ test.title }}</strong>
                <p>
                  {{ test.categoryId?.name || 'Tüm Kategoriler' }}
                  · {{ test.questionIds?.length ?? 0 }} soru
                  · Zorluk {{ test.difficulty ?? '—' }}/5
                </p>
              </div>
              <button
                class="primary-btn assign-test-btn"
                type="button"
                :disabled="assignLoading"
                @click="assignExistingTest(test)"
              >
                Ata →
              </button>
            </div>
          </div>
        </template>
        <p v-else class="assign-empty">
          Henüz oluşturulmuş test yok. Wizard'dan bir test oluşturup yayınladığınızda burada görünür.
        </p>
      </div>
    </div>

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

    <!-- ══════════════════════ EDIT EMPLOYEE MODAL ══════════════════════ -->
    <div v-if="showEditEmployeeModal" class="modal-overlay" @click.self="showEditEmployeeModal = false">
      <div class="modal-card card-surface">
        <div class="modal-header">
          <h2>Personeli Düzenle</h2>
          <button class="modal-close" type="button" @click="showEditEmployeeModal = false">✕</button>
        </div>
        <form @submit.prevent="submitEditEmployee">
          <div class="step-fields">
            <div class="field-group">
              <label class="field-label">Ad Soyad *</label>
              <input
                v-model="editEmployeeForm.fullName"
                class="field-input"
                type="text"
                maxlength="100"
                required
              />
            </div>
            <div class="field-row-2">
              <div class="field-group">
                <label class="field-label">Departman</label>
                <select v-model="editEmployeeForm.departmentId" class="field-select">
                  <option value="">Departman yok</option>
                  <option
                    v-for="dept in departmentStore.departments"
                    :key="dept._id"
                    :value="dept._id"
                  >{{ dept.name }}</option>
                </select>
              </div>
              <div class="field-group">
                <label class="field-label">Rol</label>
                <select v-model="editEmployeeForm.role" class="field-select">
                  <option value="employee">Personel</option>
                  <option value="manager">Yönetici (Departman)</option>
                  <option value="hr">İK Direktörü</option>
                  <option value="admin">Yönetici</option>
                </select>
              </div>
            </div>
            <div class="field-group">
              <label class="field-label" style="display:flex;align-items:center;gap:10px;">
                <input type="checkbox" v-model="editEmployeeForm.isActive" />
                Aktif
              </label>
            </div>
          </div>
          <p v-if="editEmployeeError" class="form-error" style="margin-top:12px;">{{ editEmployeeError }}</p>
          <div class="modal-actions">
            <button class="secondary-btn" type="button" @click="showEditEmployeeModal = false">İptal</button>
            <button class="primary-btn" type="submit" :disabled="editEmployeeLoading">
              {{ editEmployeeLoading ? 'Kaydediliyor…' : 'Kaydet' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- ══════════════════════ SAVED TEST ASSIGN MODAL ══════════════════════ -->
    <div v-if="showSavedTestAssignModal" class="modal-overlay" @click.self="showSavedTestAssignModal = false">
      <div class="modal-card card-surface">
        <div class="modal-header">
          <h2>Test Atama</h2>
          <button class="modal-close" type="button" @click="showSavedTestAssignModal = false">✕</button>
        </div>

        <div v-if="savedTestAssignTarget" class="assign-target-chip">
          <div>
            <strong>{{ savedTestAssignTarget.title }}</strong>
            <p>{{ savedTestAssignTarget.categoryId?.name ?? 'Genel' }} · {{ savedTestAssignTarget.questionIds?.length ?? 0 }} soru · Zorluk {{ savedTestAssignTarget.difficulty }}/5</p>
          </div>
        </div>

        <p v-if="savedTestAssignSuccess" class="assign-feedback assign-feedback-success">✓ {{ savedTestAssignSuccess }}</p>
        <p v-if="savedTestAssignError" class="assign-feedback assign-feedback-error">{{ savedTestAssignError }}</p>

        <p class="field-label" style="margin-bottom:10px;">Atanacak personelleri seçin:</p>
        <div class="employee-select-grid" style="max-height:340px;overflow-y:auto;">
          <label
            v-for="emp in employees.filter(e => e.isActive)"
            :key="emp.id"
            class="employee-select-item"
            :class="{
              'item-checked': savedTestAssignEmployeeIds.includes(emp.id),
              'item-already-assigned': savedTestAlreadyAssignedIds.includes(emp.id)
            }"
          >
            <input
              type="checkbox"
              :value="emp.id"
              v-model="savedTestAssignEmployeeIds"
              :disabled="savedTestAlreadyAssignedIds.includes(emp.id)"
            />
            <div class="employee-select-info">
              <div class="employee-avatar small">{{ emp.initial }}</div>
              <div>
                <strong>{{ emp.name }}</strong>
                <p>{{ emp.dept }}</p>
              </div>
            </div>
            <span v-if="savedTestAlreadyAssignedIds.includes(emp.id)" class="already-assigned-badge">Atanmış</span>
          </label>
        </div>

        <div class="modal-actions">
          <button class="secondary-btn" type="button" @click="showSavedTestAssignModal = false">İptal</button>
          <button class="primary-btn" type="button" :disabled="savedTestAssignLoading" @click="submitSavedTestAssign">
            {{ savedTestAssignLoading ? 'Atanıyor…' : 'Ata' }}
          </button>
        </div>
      </div>
    </div>

    <!-- ══════════════════════ EXISTING QUESTION PICKER ══════════════════════ -->
    <div v-if="showExistingPicker" class="modal-overlay" @click.self="showExistingPicker = false">
      <div class="modal-card card-surface" style="width:min(640px,100%);">
        <div class="modal-header">
          <div style="display:flex;align-items:center;gap:10px;">
            <button
              v-if="pickerStep === 'questions'"
              class="modal-close"
              type="button"
              style="background:rgba(46,125,122,0.1);color:var(--teal);"
              @click="pickerStep = 'tests'; pickerSelectedTest = null;"
            >←</button>
            <h2>{{ pickerStep === 'tests' ? 'Sınav Seç' : pickerSelectedTest?.title }}</h2>
          </div>
          <button class="modal-close" type="button" @click="showExistingPicker = false">✕</button>
        </div>

        <template v-if="pickerStep === 'tests'">
          <p class="section-text" style="margin-bottom:16px;">Soru almak istediğiniz sınavı seçin.</p>
          <div v-if="!testStore.tests.length" class="empty-state"><p>Henüz kayıtlı sınav yok.</p></div>
          <div v-else class="assign-tests-list">
            <div v-for="test in testStore.tests" :key="test._id" class="assign-test-row">
              <div class="assign-test-info">
                <strong>{{ test.title }}</strong>
                <p>{{ test.categoryId?.name ?? 'Genel' }} · {{ test.questionIds?.length ?? 0 }} soru</p>
              </div>
              <button class="primary-btn assign-test-btn" type="button" @click="selectPickerTest(test)">
                Seç →
              </button>
            </div>
          </div>
        </template>

        <template v-else-if="pickerStep === 'questions'">
          <p class="section-text" style="margin-bottom:16px;">Eklemek istediğiniz soruları seçin.</p>
          <div v-if="pickerLoading" style="text-align:center;padding:24px;">
            <div class="spinner" style="width:32px;height:32px;margin:0 auto;"></div>
          </div>
          <div v-else-if="!pickerTestQuestions.length" class="empty-state">
            <p>Bu sınavda soru bulunamadı.</p>
          </div>
          <div v-else class="picker-questions-list">
            <div v-for="(q, i) in pickerTestQuestions" :key="q._id" class="picker-question-row">
              <div class="picker-question-info">
                <strong>{{ i + 1 }}. {{ q.text }}</strong>
                <p>{{ TYPE_LABELS[q.type] ?? q.type }} · Zorluk {{ q.difficulty }}/5</p>
              </div>
              <button
                class="question-select-toggle"
                :class="{ selected: isPickerQuestionAdded(q._id) }"
                type="button"
                :disabled="isPickerQuestionAdded(q._id)"
                @click="addPickerQuestion(q)"
              >{{ isPickerQuestionAdded(q._id) ? '✓ Eklendi' : '+ Ekle' }}</button>
            </div>
          </div>
        </template>

        <div class="modal-actions">
          <button class="secondary-btn" type="button" @click="showExistingPicker = false">Kapat</button>
        </div>
      </div>
    </div>

    <!-- ══════════════════════ EMPLOYEE REPORT MODAL ══════════════════════ -->
    <div v-if="showEmployeeReportModal" class="modal-overlay" @click.self="showEmployeeReportModal = false">
      <div class="modal-card card-surface" style="width:min(680px,100%);max-height:80vh;overflow-y:auto;">
        <div class="modal-header">
          <h2>{{ employeeReportTarget?.name ?? 'Rapor' }}</h2>
          <button class="modal-close" type="button" @click="showEmployeeReportModal = false">✕</button>
        </div>

        <div v-if="employeeReportLoading" style="text-align:center;padding:32px 0;">
          <div class="spinner" style="width:32px;height:32px;margin:0 auto;"></div>
        </div>

        <template v-else-if="employeeReportData">
          <div class="assign-target-chip" style="margin-bottom:20px;">
            <div class="employee-avatar small">{{ employeeReportTarget?.initial }}</div>
            <div>
              <strong>{{ employeeReportData.user?.fullName }}</strong>
              <p>{{ employeeReportData.user?.email }}</p>
            </div>
          </div>

          <div v-if="!employeeReportData.sessionHistory?.length" class="empty-state small">
            <p>Henüz tamamlanmış test oturumu yok.</p>
          </div>

          <template v-else>
            <h3 style="margin-bottom:12px;font-size:14px;opacity:.7;text-transform:uppercase;letter-spacing:.06em;">Test Geçmişi</h3>
            <div class="reports-list">
              <div
                v-for="(s, i) in employeeReportData.sessionHistory"
                :key="i"
                class="report-list-row"
              >
                <span class="report-type-chip">Hafta {{ s.weekNumber }}/{{ s.year }}</span>
                <div class="report-list-meta">
                  <strong>%{{ s.scorePercent }} — {{ s.correctCount }}/{{ s.totalQuestions }} doğru</strong>
                  <p>{{ s.completedAt ? new Date(s.completedAt).toLocaleDateString('tr-TR') : '—' }}</p>
                </div>
                <span
                  class="risk-badge"
                  :class="s.scorePercent >= 70 ? 'risk-low' : s.scorePercent >= 40 ? 'risk-medium' : 'risk-high'"
                >
                  {{ s.scorePercent >= 70 ? 'İyi' : s.scorePercent >= 40 ? 'Orta' : 'Düşük' }}
                </span>
              </div>
            </div>

            <template v-if="employeeReportData.wrongByCategory?.length">
              <h3 style="margin:20px 0 12px;font-size:14px;opacity:.7;text-transform:uppercase;letter-spacing:.06em;">Kategori Bazlı Hata Oranı</h3>
              <div class="reports-list">
                <div
                  v-for="(c, i) in employeeReportData.wrongByCategory"
                  :key="i"
                  class="report-list-row"
                >
                  <span class="report-type-chip">{{ c.categoryName }}</span>
                  <div class="report-list-meta">
                    <strong>%{{ c.errorRate?.toFixed(1) }} hata oranı</strong>
                    <p>{{ c.wrong }}/{{ c.total }} yanlış</p>
                  </div>
                </div>
              </div>
            </template>
          </template>
        </template>

        <div v-else class="empty-state small">
          <p>Rapor yüklenemedi.</p>
        </div>

        <div class="modal-actions">
          <button class="secondary-btn" type="button" @click="showEmployeeReportModal = false">Kapat</button>
        </div>
      </div>
    </div>

    <!-- ══════════════════════ REPORT DETAIL MODAL ══════════════════════ -->
    <div v-if="showReportDetailModal" class="modal-overlay" @click.self="showReportDetailModal = false">
      <div class="modal-card card-surface" style="width:min(720px,100%);max-height:85vh;overflow-y:auto;">
        <div class="modal-header">
          <h2>Rapor Detayı</h2>
          <button class="modal-close" type="button" @click="showReportDetailModal = false">✕</button>
        </div>

        <div v-if="reportDetailLoading" style="text-align:center;padding:32px 0;">
          <div class="spinner" style="width:32px;height:32px;margin:0 auto;"></div>
        </div>

        <p v-else-if="reportDetailError" class="form-error">{{ reportDetailError }}</p>

        <template v-else-if="reportDetail">
          <div class="assign-target-chip" style="margin-bottom:18px;">
            <div>
              <strong>{{ REPORT_TYPE_LABELS[reportDetail.reportType] ?? reportDetail.reportType }}</strong>
              <p>
                {{ new Date(reportDetail.periodStart).toLocaleDateString('tr-TR') }} —
                {{ new Date(reportDetail.periodEnd).toLocaleDateString('tr-TR') }}
                · Oluşturan: {{ reportDetail.generatedBy?.fullName ?? '—' }}
              </p>
            </div>
            <span class="risk-badge" :class="`risk-${reportDetail.riskLevel}`" style="margin-left:auto;">
              {{ RISK_LABELS[reportDetail.riskLevel] ?? reportDetail.riskLevel }}
            </span>
          </div>

          <div class="detail-stats-grid">
            <div class="detail-stat-tile">
              <span>Ort. Başarı</span>
              <strong>%{{ (reportDetail.avgScore ?? 0).toFixed(1) }}</strong>
            </div>
            <div class="detail-stat-tile">
              <span>Bozulma Oranı</span>
              <strong>%{{ ((reportDetail.decayRate ?? 0) * 100).toFixed(1) }}</strong>
            </div>
            <div class="detail-stat-tile">
              <span>Toplam Oturum</span>
              <strong>{{ reportDetail.reportData?.sessionStats?.totalSessions ?? 0 }}</strong>
            </div>
            <div class="detail-stat-tile">
              <span>Aktif Personel</span>
              <strong>{{ reportDetail.reportData?.sessionStats?.activeEmployeeCount ?? 0 }}</strong>
            </div>
          </div>

          <template v-if="reportDetail.reportData?.departmentBreakdown?.length">
            <p class="detail-subhead">Departman Performansı</p>
            <div class="detail-table-wrap">
              <table class="detail-table">
                <thead>
                  <tr>
                    <th>Departman</th>
                    <th>Oturum</th>
                    <th>Ort. Skor</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="d in reportDetail.reportData.departmentBreakdown" :key="d.departmentName">
                    <td><strong>{{ d.departmentName }}</strong></td>
                    <td>{{ d.sessionCount }}</td>
                    <td><span :class="scoreClass(d.avgScore)">%{{ (d.avgScore ?? 0).toFixed(1) }}</span></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </template>

          <template v-if="reportDetail.reportData?.knowledgeStats">
            <p class="detail-subhead">Bilgi Takip İstatistikleri</p>
            <div class="detail-table-wrap">
              <table class="detail-table">
                <tbody>
                  <tr>
                    <td>Örneklem</td>
                    <td><strong>{{ reportDetail.reportData.knowledgeStats.sampleSize ?? 0 }}</strong></td>
                  </tr>
                  <tr>
                    <td>Ort. Hafıza Gücü</td>
                    <td><strong>{{ (reportDetail.reportData.knowledgeStats.avgEffectiveStrength ?? 0).toFixed(3) }}</strong></td>
                  </tr>
                  <tr>
                    <td>Bozulma Oranı</td>
                    <td><strong>%{{ ((reportDetail.reportData.knowledgeStats.decayRate ?? 0) * 100).toFixed(1) }}</strong></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </template>
        </template>

        <div class="modal-actions">
          <button class="secondary-btn" type="button" @click="showReportDetailModal = false">Kapat</button>
        </div>
      </div>
    </div>

    <!-- ══════════════════════ DEPARTMENT MODAL ══════════════════════ -->
    <div v-if="showDepartmentModal" class="modal-overlay" @click.self="showDepartmentModal = false">
      <div class="modal-card card-surface">
        <div class="modal-header">
          <h2>{{ departmentModalMode === 'create' ? 'Yeni Departman' : 'Departmanı Düzenle' }}</h2>
          <button class="modal-close" type="button" @click="showDepartmentModal = false">✕</button>
        </div>
        <form @submit.prevent="submitDepartmentForm">
          <div class="step-fields">
            <div class="field-group">
              <label class="field-label">Departman Adı *</label>
              <input
                v-model="departmentForm.name"
                class="field-input"
                type="text"
                placeholder="örn. Yazılım Geliştirme"
                maxlength="100"
                required
              />
            </div>
            <div class="field-group">
              <label class="field-label">Yönetici (opsiyonel)</label>
              <select v-model="departmentForm.managerId" class="field-select">
                <option value="">Yönetici seçilmedi</option>
                <option
                  v-for="u in userStore.users.filter((u) => u.isActive)"
                  :key="u._id"
                  :value="u._id"
                >{{ u.fullName }} — {{ u.email }}</option>
              </select>
            </div>
          </div>
          <p v-if="departmentError" class="form-error" style="margin-top:12px;">{{ departmentError }}</p>
          <div class="modal-actions">
            <button class="secondary-btn" type="button" @click="showDepartmentModal = false">İptal</button>
            <button class="primary-btn" type="submit" :disabled="departmentLoading">
              {{ departmentLoading ? 'Kaydediliyor…' : (departmentModalMode === 'create' ? 'Departman Ekle' : 'Kaydet') }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <footer class="footer">Copyright İK Analiz {{ new Date().getFullYear() }}</footer>
  </div>
</template>
