import axios, { AxiosInstance, AxiosError, AxiosResponse } from 'axios';
import { API_BASE_URL } from './ApiEndpoints';

class ApiClient {
  private static instance: ApiClient;
  private client: AxiosInstance;

  private constructor() {
    this.client = axios.create({
      baseURL: API_BASE_URL,
      timeout: 10000, // Timeout 10 giây
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    });

    // Setup Interceptors: Retry 3 lần với Exponential Backoff khi gặp lỗi mạng/HTTP 5xx
    this.client.interceptors.response.use(
      (response: AxiosResponse) => response,
      async (error: AxiosError) => {
        const config = error.config as any;
        if (!config) return Promise.reject(error);

        if (!config._retryCount) {
          config._retryCount = 0;
        }

        // Tự động Retry tối đa 3 lần
        if (config._retryCount < 3 && (error.code === 'ECONNABORTED' || !error.response || error.response.status >= 500)) {
          config._retryCount += 1;
          const backoffDelay = Math.pow(2, config._retryCount) * 1000; // Exponential Backoff: 2s, 4s, 8s
          console.warn(`[ApiClient] API Request error (${error.message}). Retrying attempt ${config._retryCount}/3 after ${backoffDelay}ms...`);
          await new Promise((resolve) => setTimeout(resolve, backoffDelay));
          return this.client(config);
        }

        return Promise.reject(this.normalizeError(error));
      }
    );
  }

  public static getInstance(): ApiClient {
    if (!ApiClient.instance) {
      ApiClient.instance = new ApiClient();
    }
    return ApiClient.instance;
  }

  public getAxios(): AxiosInstance {
    return this.client;
  }

  private normalizeError(error: AxiosError): Error {
    if (error.code === 'ECONNABORTED') {
      return new Error('Kết nối API quá giờ (Timeout 10s). Vui lòng thử lại.');
    }
    if (!error.response) {
      return new Error('Không thể kết nối tới máy chủ phim.nguonc.com. Kiểm tra lại kết nối mạng.');
    }
    if (error.response.status === 404) {
      return new Error('Không tìm thấy dữ liệu phim yêu cầu.');
    }
    return new Error(`Lỗi máy chủ (${error.response.status}). Vui lòng thử lại sau.`);
  }
}

export const apiClient = ApiClient.getInstance().getAxios();
export default ApiClient;
