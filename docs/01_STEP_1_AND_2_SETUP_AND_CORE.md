# HƯỚNG DẪN BƯỚC 1 & BƯỚC 2: SETUP KIẾN TRÚC, SINGLETON API CLIENT & DATA MODELS

Tài liệu hướng dẫn chi tiết khởi tạo kiến trúc dự án, cấu hình môi trường, thiết lập Singleton Network/Storage Service và định nghĩa Data Models cho cả Web (TypeScript / Next.js) và Mobile/TV (Dart / Flutter).

---

## BƯỚC 1: KHỞI TẠO KIẾN TRÚC DỰ ÁN & MÔI TRƯỜNG

### 1.1. Cấu Trúc Monorepo Feature-First (Clean Architecture)
Dự án được tổ chức tách biệt 3 Layer theo chuẩn Clean Architecture:
- **Data Layer:** Gọi HTTP API, Parse DTOs, Quản lý Cache Local.
- **Domain Layer:** Entities chuẩn hóa, Repository Interface, UseCases thuần logic.
- **Presentation Layer:** UI Components, State Management (Zustand cho Web / BLoC cho Flutter), D-Pad TV Controller.

```text
movie-ecosystem/
├── apps/
│   ├── web/               # Next.js 14 App Router (TypeScript, Tailwind, Zustand)
│   └── tv-mobile/         # Flutter App (Mobile Touch UI & Android TV Leanback D-Pad)
└── docs/                  # Tài liệu hướng dẫn & Design Mockups
```

### 1.2. Khai Báo Dependencies

#### A. Web (`apps/web/package.json`)
```json
{
  "name": "movie-web-app",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "^14.2.5",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "@tanstack/react-query": "^5.51.1",
    "zustand": "^4.5.4",
    "axios": "^1.7.2",
    "hls.js": "^1.5.11",
    "video.js": "^8.16.1",
    "lucide-react": "^0.417.0",
    "clsx": "^2.1.1",
    "tailwind-merge": "^2.4.0"
  },
  "devDependencies": {
    "typescript": "^5.5.4",
    "@types/node": "^20.14.12",
    "@types/react": "^18.3.3",
    "autoprefixer": "^10.4.19",
    "postcss": "^8.4.40",
    "tailwindcss": "^3.4.7"
  }
}
```

#### B. Mobile & TV (`apps/tv-mobile/pubspec.yaml`)
```yaml
name: movie_tv_mobile
description: Cross-platform Movie App for Android Mobile & Android TV Box.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  dio: ^5.4.3+1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  video_player: ^2.8.6
  chewie: ^1.8.1
  equatable: ^2.0.5
  cached_network_image: ^3.3.1
  flutter_spinkit: ^5.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

---

## BƯỚC 2: CẤU HÌNH CORE SINGLETON SERVICES, ERROR HANDLING & DATA MODELS

### 2.1. Định Nghĩa Data Models & DTOs

#### A. Web (TypeScript Data Models) - `apps/web/src/types/movie.entity.ts`
```typescript
// Ánh xạ API nguonc response -> Movie Model chuẩn hóa
export interface MovieItemDTO {
  id: string;
  name: string;
  slug: string;
  original_name: string;
  thumb_url: string;
  poster_url: string;
  created: string;
  modified: string;
  description?: string;
  total_episodes?: number;
  current_episode?: string;
  quality?: string;
  language?: string;
  director?: string;
  casts?: string;
  category?: Array<{ id: string; name: string; slug: string }>;
  country?: Array<{ id: string; name: string; slug: string }>;
}

export interface EpisodeDTO {
  name: string;
  slug: string;
  embed: string;
  m3u8: string;
}

export interface ServerDataDTO {
  server_name: string;
  items: EpisodeDTO[];
}

export interface MovieDetailResponseDTO {
  status: boolean;
  message: string;
  movie: MovieItemDTO & {
    episodes: ServerDataDTO[];
  };
}

export interface PaginatedMovieResponseDTO {
  status: boolean;
  paginate: {
    current_page: number;
    total_page: number;
    total_items: number;
    items_per_page: number;
  };
  items: MovieItemDTO[];
}
```

#### B. Flutter (Dart Models) - `apps/tv-mobile/lib/data/models/movie_model.dart`
```dart
import 'package:equatable/equatable.dart';

class MovieModel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String originalName;
  final String thumbUrl;
  final String posterUrl;
  final String? currentEpisode;
  final String? quality;

  const MovieModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.originalName,
    required this.thumbUrl,
    required this.posterUrl,
    this.currentEpisode,
    this.quality,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      originalName: json['original_name'] ?? '',
      thumbUrl: json['thumb_url'] ?? '',
      posterUrl: json['poster_url'] ?? '',
      currentEpisode: json['current_episode'] ?? json['episode_current'],
      quality: json['quality'] ?? 'HD',
    );
  }

  @override
  List<Object?> get props => [id, slug, name, thumbUrl];
}
```

---

### 2.2. Singleton ApiClient (Retry, Timeout & Response Interceptor)

#### A. Web (Axios Singleton) - `apps/web/src/core/api/ApiClient.ts`
```typescript
import axios, { AxiosInstance, AxiosError } from 'axios';

class ApiClient {
  private static instance: ApiClient;
  private client: AxiosInstance;

  private constructor() {
    this.client = axios.create({
      baseURL: 'https://phim.nguonc.com/api',
      timeout: 10000, // Timeout 10 giây
      headers: {
        'Content-Type': 'application/json',
      },
    });

    // Interceptor xử lý lỗi & Auto Retry (3 lần)
    this.client.interceptors.response.use(
      (response) => response,
      async (error: AxiosError) => {
        const config = error.config as any;
        if (!config || !config.retryCount) config.retryCount = 0;

        if (config.retryCount < 3 && (error.code === 'ECONNABORTED' || !error.response || error.response.status >= 500)) {
          config.retryCount += 1;
          const delay = Math.pow(2, config.retryCount) * 1000; // Exponential backoff
          await new Promise((resolve) => setTimeout(resolve, delay));
          return this.client(config);
        }

        return Promise.reject(this.parseError(error));
      }
    );
  }

  public static getInstance(): ApiClient {
    if (!ApiClient.instance) {
      ApiClient.instance = new ApiClient();
    }
    return ApiClient.instance;
  }

  public getClient(): AxiosInstance {
    return this.client;
  }

  private parseError(error: AxiosError): Error {
    if (error.code === 'ECONNABORTED') return new Error('Mạng quá chậm, kết nối bị quá giờ (Timeout).');
    if (!error.response) return new Error('Không thể kết nối tới máy chủ API nguonc.');
    if (error.response.status === 404) return new Error('Không tìm thấy thông tin phim.');
    return new Error(`Lỗi máy chủ (${error.response.status}). Vui lòng thử lại sau.`);
  }
}

export const apiClient = ApiClient.getInstance().getClient();
```

#### B. Flutter (Dio Singleton) - `apps/tv-mobile/lib/core/network/api_client.dart`
```dart
import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://phim.nguonc.com/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) async {
          // Xử lý Lỗi Network và Retry logic ở đây
          return handler.next(error);
        },
      ),
    );
  }
}
```

---

### 2.3. Singleton Storage Service (Lịch sử xem & Bookmark)

#### Web (`apps/web/src/core/services/StorageService.ts`)
```typescript
export class StorageService {
  private static instance: StorageService;

  private constructor() {}

  public static getInstance(): StorageService {
    if (!StorageService.instance) {
      StorageService.instance = new StorageService();
    }
    return StorageService.instance;
  }

  public getItem<T>(key: string, defaultValue: T): T {
    if (typeof window === 'undefined') return defaultValue;
    try {
      const item = localStorage.getItem(key);
      return item ? JSON.parse(item) : defaultValue;
    } catch {
      return defaultValue;
    }
  }

  public setItem<T>(key: string, value: T): void {
    if (typeof window === 'undefined') return;
    try {
      localStorage.setItem(key, JSON.stringify(value));
    } catch (e) {
      console.error('Lỗi khi ghi LocalStorage:', e);
    }
  }
}

export const storageService = StorageService.getInstance();
```

---
*Tiếp theo: Xem bản Design Preview Mockup tương tác hoàn chỉnh cho Web và Android TV.*
