import axios from 'axios';

const SYS_ACCESS_KEY = 'sysAccessToken';
const SYS_REFRESH_KEY = 'sysRefreshToken';

const sysApi = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
});

sysApi.interceptors.request.use((config) => {
  const token = localStorage.getItem(SYS_ACCESS_KEY);
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

let isRefreshing = false;
let failedQueue = [];

const processQueue = (error, token = null) => {
  failedQueue.forEach((p) => (error ? p.reject(error) : p.resolve(token)));
  failedQueue = [];
};

sysApi.interceptors.response.use(
  (res) => res,
  async (error) => {
    const original = error.config;

    if (
      error.response?.status !== 401 ||
      original._retry ||
      original.url === '/api/sysadmin/auth/login'
    ) {
      return Promise.reject(error);
    }

    if (isRefreshing) {
      return new Promise((resolve, reject) => {
        failedQueue.push({ resolve, reject });
      }).then((token) => {
        original.headers.Authorization = `Bearer ${token}`;
        return sysApi(original);
      });
    }

    original._retry = true;
    isRefreshing = true;

    try {
      const refreshToken = localStorage.getItem(SYS_REFRESH_KEY);
      if (!refreshToken) throw new Error('no_refresh_token');

      const { data } = await axios.post(
        `${import.meta.env.VITE_API_BASE_URL}/api/sysadmin/auth/refresh`,
        { refreshToken }
      );

      const { accessToken, refreshToken: newRefresh } = data.data;
      localStorage.setItem(SYS_ACCESS_KEY, accessToken);
      localStorage.setItem(SYS_REFRESH_KEY, newRefresh);

      sysApi.defaults.headers.common.Authorization = `Bearer ${accessToken}`;
      original.headers.Authorization = `Bearer ${accessToken}`;
      processQueue(null, accessToken);
      return sysApi(original);
    } catch (err) {
      processQueue(err, null);
      localStorage.removeItem(SYS_ACCESS_KEY);
      localStorage.removeItem(SYS_REFRESH_KEY);
      window.location.href = '/system/login';
      return Promise.reject(err);
    } finally {
      isRefreshing = false;
    }
  }
);

export { SYS_ACCESS_KEY, SYS_REFRESH_KEY };
export default sysApi;
