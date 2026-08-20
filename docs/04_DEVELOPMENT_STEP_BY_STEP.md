# 04. HƯỚNG DẪN LẬP TRÌNH VIÊN THỰC THI DỰ ÁN DẦN TỪNG BƯỚC

## 1. YÊU CẦU MÔI TRƯỜNG KỸ THUẬT
- Node.js version >= 18.x
- Flutter SDK version >= 3.19.x
- Java JDK version 17
- Android Studio / VS Code

---

## 2. KHỞI CHẠY BẢN WEB APP (`apps/web`)
```bash
# 1. Di chuyển vào thư mục apps/web
cd apps/web

# 2. Cài đặt các thư viện phụ thuộc
npm install

# 3. Khởi chạy Development Server
npm run dev
```
Trình duyệt sẽ mở tại đường dẫn: `http://localhost:3000`.

---

## 3. KHỞI CHẠY BẢN FLUTTER ANDROID TV & MOBILE (`apps/tv-mobile`)
```bash
# 1. Di chuyển vào thư mục apps/tv-mobile
cd apps/tv-mobile

# 2. Tải các gói phụ thuộc Flutter
flutter pub get

# 3. Khởi chạy trên thiết bị giả lập Android TV / Device
flutter run -d android
```
