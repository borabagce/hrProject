<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useSysAdminStore } from '@/stores/sysadmin';

const router = useRouter();
const sys = useSysAdminStore();

const email = ref('');
const password = ref('');
const error = ref('');
const loading = ref(false);

async function submit() {
  error.value = '';
  loading.value = true;
  try {
    await sys.login(email.value, password.value);
    router.push('/system');
  } catch (err) {
    error.value = err.response?.data?.message ?? err.message ?? 'Giriş başarısız.';
  } finally {
    loading.value = false;
  }
}
</script>

<template>
  <div class="login-shell">
    <div class="ambient ambient-left"></div>
    <div class="ambient ambient-right"></div>

    <form class="login-card card-surface" @submit.prevent="submit">
      <div class="login-brand">
        <p class="eyebrow">Sistem Yönetimi</p>
        <p class="login-tagline">Tüm şirketleri tek panelden yönetin</p>
      </div>

      <div class="field-group">
        <label class="field-label" for="sys-email">E-posta</label>
        <input
          id="sys-email"
          v-model="email"
          class="field-input"
          type="email"
          autocomplete="email"
          required
        />
      </div>

      <div class="field-group">
        <label class="field-label" for="sys-password">Şifre</label>
        <input
          id="sys-password"
          v-model="password"
          class="field-input"
          type="password"
          autocomplete="current-password"
          required
        />
      </div>

      <p v-if="error" class="login-error">{{ error }}</p>

      <button class="primary-btn login-submit" type="submit" :disabled="loading">
        {{ loading ? 'Giriş yapılıyor…' : 'Sistem Girişi' }}
      </button>
    </form>
  </div>
</template>
