# MASTER PROMPT & BRD: XÂY DỰNG HỆ SINH THÁI ỨNG DỤNG XEM PHIM ĐA NỀN TẢNG (WEB, ANDROID APP, ANDROID TV)
# TÍCH HỢP NGUONC API - KIẾN TRÚC MODULAR / CLEAN ARCHITECTURE - QUY TRÌNH TỪ DESIGN MOCKUP ĐẾN CODE HOÀN CHỈNH

Vai trò: **Principal Software Architect, Lead UI/UX Designer và Senior Cross-Platform Engineer** (chuyên sâu Next.js/React, Flutter/React Native TV, Leanback Android TV). 

Nhiệm vụ: Hướng dẫn, thiết kế và lập trình hoàn chỉnh một hệ sinh thái ứng dụng xem phim đa nền tảng gồm:
1. **Web App:** Next.js (App Router), TypeScript, Tailwind CSS, Video.js / Hls.js, TanStack Query, Zustand.
2. **Android Mobile App & Android TV App:** Flutter (Dart) hoặc React Native + React Native TV (hỗ trợ 100% Android TV Box, Smart TV điều khiển D-Pad Remote).
3. **Data Source:** Toàn bộ dữ liệu phim lấy từ API hệ thống `https://phim.nguonc.com/api-document`.

Toàn bộ quá trình thực hiện phải tuân thủ nghiêm ngặt quy trình 2 giai đoạn (Design Preview/Mockup -> Code Implementation), áp dụng Design Patterns chuẩn công nghiệp (Singleton, Repository, Factory, BLoC/Zustand State Pattern) để dễ debug, bảo trì, có cơ chế Error Handling & Logging toàn diện, kèm theo tài liệu hướng dẫn từng bước (Step-by-step Documentation Guide).

---

## PHẦN 1: BẢN ĐẶC TẢ YÊU CẦU KINH DOANH & KỸ THUẬT (BRD)

### 1.1. Kiến Trúc & Design Patterns (Dễ mở rộng, Dễ kiểm tra & Sửa lỗi)
* **Clean Architecture & Repository Pattern:** Tách biệt rõ ràng Data Layer (API/Network/Cache) -> Domain Layer (UseCases/Entities/Repository Interfaces) -> Presentation Layer (UI/State Management).
* **Singleton Pattern:** 
  * Áp dụng cho: `ApiClient` / `HttpService` (quản lý Base URL, Interceptor, Token, Timeout), `StorageService` (lưu trữ Cache/Local Data), `AudioVideoController` (quản lý session phát video toàn cục), `LoggerService` (ghi nhận log & bug tracing).
* **Factory / Strategy Pattern:**
  * Xử lý Video Stream Sources: Factory chuyển đổi link m3u8 HLS trực tiếp hoặc Embed HTML Iframe linh hoạt tùy server.
* **State Management & Observer Pattern:**
  * Web: Zustand store (Global Player state, Watch history, Bookmark, Theme, Network status).
  * Flutter/RN: BLoC / Riverpod / Zustand (xử lý state reactive, cô lập logic UI và Business logic).

### 1.2. Đặc Tả Tích Hợp API (phim.nguonc.com)
Hệ thống sử dụng các endpoints:
1. `GET /api/films/phim-moi-cap-nhat?page={page}`: Danh sách phim mới.
2. `GET /api/film/{slug}`: Chi tiết phim, server stream, danh sách tập.
3. `GET /api/films/the-loai/{slug}?page={page}`: Lọc theo thể loại.
4. `GET /api/films/quoc-gia/{slug}?page={page}`: Lọc theo quốc gia.
5. `GET /api/films/danh-sach/{slug}?page={page}`: Lọc định dạng (Phim lẻ, Phim bộ, TV Shows, Hoạt hình).
6. `GET /api/films/search?keyword={keyword}&page={page}`: Tìm kiếm phim (Debounce 500ms).

---

## PHẦN 2: BỐ TRÍ CẤU TRÚC THƯ MỤC DỰ ÁN (PROJECT FOLDER STRUCTURE)

```text
movie-ecosystem/
├── .github/
│   └── workflows/
│       ├── web-ci-cd.yml                     # Pipeline test, build, deploy Web lên Vercel/Cloudflare
│       └── tv-mobile-build-apk.yml           # Pipeline build file APK cho Android Mobile và Android TV Box
│
├── apps/
│   ├── web/                                  # ỨNG DỤNG WEB (Next.js 14+ App Router, TypeScript, Tailwind)
│   │   ├── public/
│   │   │   ├── favicon.ico
│   │   │   ├── logo.svg
│   │   │   └── images/
│   │   │       ├── placeholder-poster.jpg
│   │   │       └── placeholder-backdrop.jpg
│   │   ├── src/
│   │   │   ├── app/                          # Routing Next.js
│   │   │   │   ├── layout.tsx                # Root layout (Header, Footer, QueryProvider, Toast)
│   │   │   │   ├── page.tsx                  # Trang chủ (Hero Banner, Carousels)
│   │   │   │   ├── not-found.tsx             # Trang 404
│   │   │   │   ├── error.tsx                 # Global Error Boundary cho Web UI
│   │   │   │   ├── loading.tsx               # Skeleton loading trang chủ
│   │   │   │   ├── film/
│   │   │   │   │   └── [slug]/
│   │   │   │   │       ├── page.tsx          # Trang chi tiết phim (Info, Server, Danh sách tập)
│   │   │   │   │       └── loading.tsx       # Skeleton loading chi tiết phim
│   │   │   │   ├── watch/
│   │   │   │   │   └── [slug]/
│   │   │   │   │       └── page.tsx          # Trang trình phát video (Player, Next Episode, Server switch)
│   │   │   │   ├── search/
│   │   │   │   │   └── page.tsx              # Trang tìm kiếm và bộ lọc đa tiêu chí
│   │   │   │   ├── danh-sach/
│   │   │   │   │   └── [category]/
│   │   │   │   │       └── page.tsx          # Trang lọc theo Phim bộ, Phim lẻ, Hoạt hình
│   │   │   │   ├── the-loai/
│   │   │   │   │   └── [genre]/
│   │   │   │   │       └── page.tsx          # Trang lọc theo thể loại (Hành động, Cổ trang...)
│   │   │   │   ├── quoc-gia/
│   │   │   │   │   └── [country]/
│   │   │   │   │       └── page.tsx          # Trang lọc theo quốc gia (Việt Nam, Hàn Quốc...)
│   │   │   │   └── library/
│   │   │   │       └── page.tsx              # Trang quản lý Bookmark & Lịch sử xem dở
│   │   │   │
│   │   │   ├── components/                   # Components tái sử dụng
│   │   │   │   ├── common/
│   │   │   │   │   ├── Header.tsx            # Thanh điều hướng top bar
│   │   │   │   │   ├── Footer.tsx            # Chân trang
│   │   │   │   │   ├── NavbarMobile.tsx      # Bottom Navigation cho giao diện Mobile Web
│   │   │   │   │   ├── MovieCard.tsx         # Card hiển thị poster, nhãn chất lượng, tập mới
│   │   │   │   │   ├── MovieSlider.tsx       # Carousel trượt ngang mượt mà
│   │   │   │   │   ├── HeroBanner.tsx        # Banner động nổi bật đầu trang
│   │   │   │   │   ├── SkeletonCard.tsx      # Khung xương chờ tải cho MovieCard
│   │   │   │   │   ├── Pagination.tsx        # Nút chuyển trang (Next/Prev/Page Number)
│   │   │   │   │   └── ErrorFallback.tsx     # Giao diện thông báo lỗi thân thiện
│   │   │   │   ├── player/
│   │   │   │   │   ├── VideoPlayer.tsx       # Trình phát bọc Video.js / Hls.js
│   │   │   │   │   ├── IframeEmbed.tsx       # Trình phát dự phòng dạng Iframe Embed HTML
│   │   │   │   │   ├── PlayerControls.tsx    # HUD điều khiển (Play/Pause, Tua, Âm lượng, Toàn màn hình)
│   │   │   │   │   ├── QualitySelector.tsx   # Menu chọn server và chất lượng
│   │   │   │   │   └── EpisodeList.tsx       # Lưới danh sách chọn tập phim trong player
│   │   │   │   └── search/
│   │   │   │       ├── SearchBar.tsx         # Thanh nhập từ khóa tìm kiếm
│   │   │   │       └── FilterModal.tsx       # Hộp thoại lọc thể loại, quốc gia, năm
│   │   │   │
│   │   │   ├── core/                         # Singleton Services & Network Layer
│   │   │   │   ├── api/
│   │   │   │   │   ├── ApiClient.ts          # Singleton Axios Instance (BaseURL, Timeout, Interceptors)
│   │   │   │   │   └── ApiEndpoints.ts       # Định nghĩa hằng số các Endpoint của phim.nguonc.com
│   │   │   │   ├── services/
│   │   │   │   │   ├── MovieService.ts       # Triển khai gọi API lấy phim, tập, lọc thể loại
│   │   │   │   │   ├── StorageService.ts     # Singleton thao tác LocalStorage / IndexedDB
│   │   │   │   │   └── LoggerService.ts      # Singleton ghi log lỗi (Console & Error Reporting)
│   │   │   │   └── errors/
│   │   │   │       ├── AppError.ts           # Class lỗi tùy chỉnh
│   │   │   │       └── ErrorHandler.ts       # Hàm parse mã lỗi HTTP thành thông báo tiếng Việt
│   │   │   │
│   │   │   ├── hooks/                        # Custom React Hooks
│   │   │   │   ├── useDebounce.ts            # Hook hoãn thời gian tìm kiếm
│   │   │   │   ├── useMovieDetail.ts         # Hook bọc React Query lấy chi tiết phim
│   │   │   │   ├── useMoviePagination.ts     # Hook bọc phân trang danh sách phim
│   │   │   │   ├── useWatchHistory.ts        # Hook quản lý và đồng bộ lịch sử xem
│   │   │   │   └── useKeyboardShortcuts.ts   # Hook bắt phím Space, Mũi tên để điều khiển video
│   │   │   │
│   │   │   ├── stores/                       # Quản lý State toàn cục (Zustand)
│   │   │   │   ├── usePlayerStore.ts         # State: Server đang chọn, tập đang phát, timestamp
│   │   │   │   ├── useBookmarkStore.ts       # State: Danh sách phim yêu thích
│   │   │   │   └── useHistoryStore.ts        # State: Tiến trình xem dở (Continue Watching)
│   │   │   │
│   │   │   ├── types/                        # TypeScript Interfaces & Types
│   │   │   │   ├── movie.dto.ts              # Type ánh xạ trực tiếp từ JSON API nguồn C
│   │   │   │   ├── movie.entity.ts           # Model chuẩn hóa cho toàn bộ app
│   │   │   │   ├── episode.entity.ts         # Model chi tiết tập, server và link m3u8/embed
│   │   │   │   └── api-response.dto.ts       # Cấu trúc phản hồi chung (status, message, paginate)
│   │   │   │
│   │   │   └── utils/
│   │   │       ├── constants.ts              # Cấu hình tĩnh (Tên web, SEO metadata mặc định)
│   │   │       ├── formatters.ts             # Hàm format thời lượng (phút -> giờ), ngày tháng
│   │   │       └── urlHelper.ts              # Hàm tạo slug URL chuẩn
│   │   │
│   │   ├── next.config.js                    # Cấu hình domain ảnh nguồn C, SSR, headers
│   │   ├── tailwind.config.ts                # Cấu hình màu sắc cinema dark theme
│   │   ├── postcss.config.js
│   │   ├── tsconfig.json
│   │   └── package.json
│   │
│   └── tv-mobile/                            # ỨNG DỤNG FLUTTER CHO ANDROID MOBILE & ANDROID TV
│       ├── android/
│       │   ├── app/
│       │   │   ├── src/
│       │   │   │   └── main/
│       │   │   │       ├── AndroidManifest.xml   # Cấu hình Leanback TV, Banner TV, Touchscreen=false
│       │   │   │       └── res/
│       │   │   │           ├── drawable/
│       │   │   │           │   └── tv_banner.png # Banner ứng dụng chuẩn Android TV Leanback
│       │   │   │           └── mipmap/           # Icon ứng dụng Mobile
│       │   │   └── build.gradle
│       │   └── build.gradle
│       │
│       ├── lib/
│       │   ├── main.dart                     # Điểm khởi chạy app, bắt Unhandled Exception toàn cục
│       │   ├── app.dart                      # Cấu hình MaterialApp, Routing, Theme
│       │   │
│       │   ├── core/                         # Singleton Core & TV Controller Utilities
│       │   │   ├── network/
│       │   │   │   ├── api_client.dart       # Singleton Dio Client (BaseUrl, Interceptors, Retry)
│       │   │   │   ├── api_endpoints.dart    # Hằng số URLs API nguồn C
│       │   │   │   └── network_info.dart     # Kiểm tra kết nối Internet
│       │   │   ├── storage/
│       │   │   │   └── local_storage.dart    # Singleton Hive/SharedPrefs quản lý Cache & History
│       │   │   ├── theme/
│       │   │   │   ├── app_colors.dart       # Bộ màu Dark Cinema (#0b0c0f, #e50914, #00e5ff)
│       │   │   │   ├── app_typography.dart   # Kiểu chữ tối ưu đọc từ xa trên màn hình TV
│       │   │   │   └── tv_focus_theme.dart   # Cấu hình hiệu ứng viền sáng (Glow), Scale 1.08x khi Focus
│       │   │   ├── tv/
│       │   │   │   ├── dpad_detector.dart    # Bắt phím điều khiển từ xa D-Pad (Up, Down, Left, Right, Center)
│       │   │   │   └── tv_focus_node.dart    # Quản lý Focus Node tránh lỗi mất trỏ chuột trên TV
│       │   │   ├── errors/
│       │   │   │   ├── app_exceptions.dart   # Custom Exception (ServerException, TimeoutException)
│       │   │   │   └── failures.dart         # Chuyển đổi lỗi sang thông điệp UI
│       │   │   └── utils/
│       │   │       ├── logger.dart           # Singleton ghi log debug
│       │   │       └── device_util.dart      # Kiểm tra thiết bị là Android TV hay Mobile
│       │   │
│       │   ├── data/                         # Data Layer
│       │   │   ├── datasources/
│       │   │   │   ├── movie_remote_datasource.dart # Gọi trực tiếp các endpoint HTTP
│       │   │   │   └── movie_local_datasource.dart  # Đọc/ghi cache lịch sử xem và bookmark
│       │   │   ├── models/
│       │   │   │   ├── movie_model.dart      # Parse JSON từ nguồn C thành Object
│       │   │   │   ├── movie_detail_model.dart
│       │   │   │   └── episode_model.dart
│       │   │   └── repositories/
│       │   │       └── movie_repository_impl.dart   # Triển khai Repository, xử lý kết hợp Cache + Network
│       │   │
│       │   ├── domain/                       # Domain Layer (Logic thuần không phụ thuộc UI)
│       │   │   ├── entities/
│       │   │   │   ├── movie_entity.dart
│       │   │   │   ├── movie_detail_entity.dart
│       │   │   │   └── server_stream_entity.dart
│       │   │   ├── repositories/
│       │   │   │   └── movie_repository.dart # Abstract Interface của Repository
│       │   │   └── usecases/
│       │   │       ├── get_recent_movies.dart       # UseCase lấy danh sách phim mới
│       │   │       ├── get_movie_detail.dart        # UseCase lấy chi tiết tập phim
│       │   │       ├── search_movies.dart           # UseCase tìm kiếm
│       │   │       └── get_movies_by_category.dart  # UseCase lọc danh mục
│       │   │
│       │   └── presentation/                 # Presentation Layer (UI & State)
│       │       ├── state/
│       │       │   ├── home/
│       │       │   │   ├── home_bloc.dart    # Quản lý State danh sách phim trang chủ
│       │       │   │   ├── home_event.dart
│       │       │   │   └── home_state.dart
│       │       │   ├── detail/
│       │       │   │   ├── detail_bloc.dart  # Quản lý State tải chi tiết phim
│       │       │   │   ├── detail_event.dart
│       │       │   │   └── detail_state.dart
│       │       │   ├── player/
│       │       │   │   ├── player_bloc.dart  # Quản lý State phát video, chọn tập, tua nhanh
│       │       │   │   ├── player_event.dart
│       │       │   │   └── player_state.dart
│       │       │   └── search/
│       │       │       ├── search_bloc.dart  # Quản lý State tìm kiếm & bộ lọc
│       │       │       ├── search_event.dart
│       │       │       └── search_state.dart
│       │       │
│       │       ├── screens/
│       │       │   ├── splash_screen.dart    # Màn hình mở đầu tải cấu hình
│       │       │   ├── main_navigation_screen.dart # Điều phối Sidebar (TV) hoặc BottomBar (Mobile)
│       │       │   ├── home/
│       │       │   │   ├── home_screen.dart  # Màn hình chính
│       │       │   │   └── widgets/
│       │       │   │       ├── tv_banner_slider.dart
│       │       │   │       ├── tv_movie_row.dart
│       │       │   │       └── continue_watching_row.dart
│       │       │   ├── detail/
│       │       │   │   ├── movie_detail_screen.dart
│       │       │   │   └── widgets/
│       │       │   │       ├── episode_grid_view.dart
│       │       │   │       └── server_tab_bar.dart
│       │       │   ├── player/
│       │       │   │   ├── tv_video_player_screen.dart # Trình phát chuyên biệt Android TV (Full D-Pad)
│       │       │   │   ├── mobile_video_player_screen.dart # Trình phát vuốt chạm cho Mobile
│       │       │   │   └── widgets/
│       │       │   │       ├── tv_player_overlay.dart  # HUD tua nhanh, hiện timeline khi bấm D-Pad
│       │       │   │       └── webview_fallback_player.dart
│       │       │   ├── search/
│       │       │   │   ├── search_screen.dart
│       │       │   │   └── widgets/
│       │       │   │       └── tv_on_screen_keyboard.dart # Bàn phím ảo bấm D-Pad trên TV
│       │       │   └── library/
│       │       │       └── library_screen.dart # Quản lý phim đã lưu và lịch sử
│       │       │
│       │       └── widgets/
│       │           ├── tv_focusable_button.dart # Widget nút bấm có hiệu ứng viền phát sáng khi focus
│       │           ├── tv_movie_card.dart       # Card phim tự phóng to khi D-Pad trỏ tới
│       │           ├── tv_sidebar.dart          # Menu dọc bên trái chuyên dụng Android TV
│       │           ├── mobile_bottom_nav.dart   # Menu đáy cho điện thoại
│       │           ├── error_view.dart          # Màn hình báo lỗi có nút thử lại
│       │           └── loading_indicator.dart
│       │
│       └── pubspec.yaml                      # Khai báo dio, flutter_bloc, video_player, hive...
│
├── docs/                                     # TÀI LIỆU DỰ ÁN & HƯỚNG DẪN BẢO TRÌ
│   ├── 01_PRD_AND_BUSINESS_REQUIREMENTS.md  # Đặc tả yêu cầu sản phẩm & nghiệp vụ
│   ├── 02_API_INTEGRATION_SPEC.md           # Chi tiết các trường JSON của phim.nguonc.com
│   ├── 03_DESIGN_SYSTEM_AND_MOCKUPS.md      # Quy chuẩn kích thước, màu sắc, Focus State Android TV
│   ├── 04_DEVELOPMENT_STEP_BY_STEP.md       # Hướng dẫn từng bước từ setup đến hoàn thiện
│   ├── 05_DEBUG_AND_TROUBLESHOOTING.md      # 10 lỗi thường gặp (CORS, HLS, Lost Focus TV) và cách sửa
│   └── 06_BUILD_AND_DEPLOY_GUIDE.md         # Hướng dẫn build APK Leanback TV và deploy Web Vercel
│
├── README.md                                 # Hướng dẫn tổng quan clone và chạy dự án
└── .gitignore
```

---

## PHẦN 3: QUY TRÌNH THỰC HIỆN 2 GIAI ĐOẠN

### GIAI ĐOẠN 1: THIẾT KẾ & TẠO MOCKUP XEM TRƯỚC (UI/UX PREVIEW)
**Yêu cầu:** Trước khi viết code chức năng, tạo bản mockup xem trước tương tác (Interactive Preview Mockup) bằng HTML5/Tailwind CSS độc lập hoặc Canvas/Figma Spec để người dùng duyệt giao diện:
1. **Mockup 1: Web & Mobile Responsive** (Dark Theme chuẩn Cinema, Hero Slider, Hàng phim ngang Carousel, Menu linh hoạt).
2. **Mockup 2: Android TV (10-Foot UI)**:
   * Thanh điều hướng cạnh bên (Sidebar Navigation) thu gọn.
   * Hiệu ứng Focus State (Scale 1.08x, viền phát sáng Glow Border vàng/cyan khi bấm phím điều hướng Remote).
   * HUD Player Overlay chuyên dụng cho Android TV (tự ẩn sau 3 giây, tua bằng D-Pad Left/Right, mở tập bằng D-Pad Down).
3. Sau khi người dùng duyệt và đồng ý thiết kế mockup, mới tiến hành Giai đoạn 2.

### GIAI ĐOẠN 2: TRIỂN KHAI CODE CHI TIẾT & LOGIC
1. Xây dựng Data Models, Serialization, Singleton Network Service (có retry, timeout, response interceptor).
2. Xây dựng Local Repository ghi nhớ tiến trình xem (`continue_watching`) và bookmark.
3. Lập trình Player Engine:
   * Web: Video.js / Hls.js hỗ trợ m3u8 và fallback iframe.
   * App & TV: Better Player / Video Player (Flutter) hoặc react-native-video có bắt sự kiện Remote D-Pad.
4. Tối ưu build APK cho Mobile và Android TV (cấu hình `AndroidManifest.xml` hỗ trợ `android.software.leanback` = true/false, `touchscreen` = false).

---

## PHẦN 4: QUY TRÌNH KIỂM TRA & XỬ LÝ LỖI (ERROR HANDLING & DEBUGGING STRATEGY)

1. **Network & API Error Handling:**
   * Timeout (quá 10s), HTTP 404, HTTP 500, Rate Limit: Tự động Retry 3 lần với Exponential Backoff.
   * Phân loại lỗi thành dạng người dùng đọc được (`UserFriendlyException`): *"Không thể kết nối máy chủ", "Phim đang được cập nhật server phát"*.
2. **Stream & Video Playback Error Handling:**
   * HLS Stream Error / Link chết: Tự động chuyển đổi sang Server Backup hoặc chế độ Iframe Embed.
   * Mất kết nối khi đang phát: Tự động Pause, lưu Timestamp hiện tại, hiện modal "Thử lại kết nối".
3. **Global Error Boundary & Logging System:**
   * Tích hợp `LoggerService` ghi log (Debug, Info, Warn, Error) có gắn timestamp và màn hình xảy ra lỗi.
   * `ErrorBoundary` bao bọc UI: Khi UI crash không bị văng app (Black Screen of Death), hiển thị màn hình fallback "Đã có sự cố xảy ra" kèm nút "Tải lại trang".
4. **Unit Test & Debug Checklist:**
   * Bộ test kiểm tra Parse JSON từ API Nguonc.
   * Bộ test kiểm tra điều khiển D-Pad TV không bị mất Focus (Focus Trap / Lost Focus).

---

## PHẦN 5: TÀI LIỆU HƯỚNG DẪN TỪNG BƯỚC (STEP-BY-STEP IMPLEMENTATION & DEBUG GUIDE)

* **Bước 1: Khởi tạo môi trường & Cài đặt thư viện** (Dependencies cho Web & Mobile/TV).
* **Bước 2: Cấu hình Singleton Services, Models & API Client**.
* **Bước 3: Hiển thị Bản Mockup Preview UI** (Code HTML/Tailwind standalone có thể chạy xem ngay).
* **Bước 4: Viết Code Triển khai từng màn hình (Home, Detail, Player, TV Navigation)**.
* **Bước 5: Hướng dẫn Debug & Xử lý 10 lỗi thường gặp** (CORS khi gọi API, Lỗi link HLS không chạy trên web, Mất focus trên Android TV remote, Lỗi build APK leanback).
* **Bước 6: Hướng dẫn Build APK Android TV & Mobile + Deploy Web lên Vercel/Server**.
