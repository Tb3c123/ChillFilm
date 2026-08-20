# TÀI LIỆU GHI NHỚ QUY TẮC & KIẾN TRÚC THUẦN (CLEAN ARCHITECTURE) - WATCH FILM

> **LƯU Ý BẮT BUỘC:** Tài liệu này ghi nhớ toàn bộ quy tắc thực hiện dự án `watch_film`. Tuyệt đối **KHÔNG** tự ý gộp, lược bớt hay thay đổi bất kỳ file/thư mục nào đã được quy định.

---

## 1. NGUYÊN TẮC THIẾT KẾ CỐT LÕI
1. **Clean Architecture 3 Lớp Chi Tiết:**
   - **Data Layer:** Remote DataSources, Local DataSources, DTOs, Mappers, Repositories Implementation.
   - **Domain Layer:** Entities, Repository Interfaces, UseCases.
   - **Presentation Layer:** BLoC / State Management, Screens, TV Widgets, Mobile Widgets.
2. **Design Patterns Bắt Buộc:**
   - **Singleton Pattern:** API Client (`ApiClient.ts`, `api_client.dart`), Storage Service (`StorageService.ts`, `local_storage.dart`), Logger (`LoggerService.ts`, `logger.dart`).
   - **Repository Pattern:** Phân tách rõ giao diện (interface) và triển khai thực tế.
   - **Factory Pattern:** Tự động nhận diện và khởi tạo Video Player phù hợp (HLS `.m3u8` hoặc `IframeEmbed`).
   - **BLoC Pattern (Flutter):** Quản lý trạng thái tách biệt khỏi UI cho Android TV và Mobile.
3. **Hiệu Ứng Giao Diện & Spatial D-Pad (Android TV):**
   - Vệt sáng Focus Cyan chuẩn Electric Neon (`#00e5ff`) với hiệu ứng `shadow: 0 0 40px rgba(0,229,255,0.95)` và viền 3.5px.
   - Tỷ lệ Scale khi D-Pad focus: `1.08x`.
   - Thuật toán chuyển Focus: Chỉ nhảy từ Nội dung sang Sidebar khi bấm `ArrowLeft` ở cột ngoài cùng bên trái.
   - Màn hình Chi tiết phim hiển thị ĐẦY ĐỦ 7 trường metadata (Số tập, Thời lượng, Đạo diễn, Diễn viên, Thể loại, Năm phát hành, Quốc gia).
   - Bấm mở phim tự động phát Fullscreen tràn 100% màn hình TV.
   - Bấm số tập trỏ đúng 100% số tập được chọn.

---

## 2. QUY TRÌNH THỰC HIỆN 5 GÓI (MODULES)
- **Gói 1:** Core Layer, Models, DTOs & Singleton Services (Cả Web & TV-Mobile).
- **Gói 2:** Data Layer & Domain Layer (UseCases & Repositories).
- **Gói 3:** Presentation Web App (Routes, Components, Player).
- **Gói 4:** Presentation TV/Mobile App (Screens, BLoC, D-Pad Remote Controller, Leanback Manifest).
- **Gói 5:** Bộ tài liệu docs/ chi tiết từ setup, fix lỗi đến build APK.
