<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';

const router = useRouter();
const auth = useAuthStore();

const email = ref('');
const password = ref('');
const error = ref('');
const loading = ref(false);

async function submit() {
  error.value = '';
  loading.value = true;
  try {
    await auth.login(email.value, password.value);
    router.push('/');
  } catch (err) {
    error.value = err.response?.data?.message ?? 'Giriş başarısız, bilgilerinizi kontrol edin.';
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
        <p class="eyebrow">İK Analiz</p>
        <p class="login-tagline">Kurumsal sınavlar ve gelişim analitiği</p>
      </div>

      <div class="field-group">
        <label class="field-label" for="email">E-posta</label>
        <input
          id="email"
          v-model="email"
          class="field-input"
          type="email"
          autocomplete="email"
          placeholder="ornek@sirket.com"
          required
        />
      </div>

      <div class="field-group">
        <label class="field-label" for="password">Şifre</label>
        <input
          id="password"
          v-model="password"
          class="field-input"
          type="password"
          autocomplete="current-password"
          placeholder="••••••••"
          required
        />
      </div>

      <p v-if="error" class="login-error">{{ error }}</p>

      <button class="primary-btn login-submit" type="submit" :disabled="loading">
        {{ loading ? 'Giriş yapılıyor…' : 'Giriş Yap' }}
      </button>
    </form>
  </div>
</template>
