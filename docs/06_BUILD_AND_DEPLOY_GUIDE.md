# 06. HƯỚNG DẪN BUILD VÀ DEPLOY (BUILD & DEPLOYMENT GUIDE)

## 1. XUẤT FILE APK CHO ANDROID MOBILE VÀ ANDROID TV

```bash
cd apps/tv-mobile

# Xuất bản cài đặt cho Điện thoại Android
flutter build apk --release --target-platform android-arm64

# Xuất bản cài đặt cho Android TV Box / Google TV
flutter build apk --release --target-platform android-arm64
```
File APK kết quả nằm tại: `build/app/outputs/flutter-apk/app-release.apk`.

---

## 2. DEPLOY ứng dụng WEB LÊN VERCEL / CLOUDFLARE PAGES

```bash
cd apps/web

# Build bản sản xuất
npm run build

# Chạy bản sản xuất cục bộ
npm run start
```
Biến môi trường cần thiết khi Deploy:
- `NEXT_PUBLIC_API_BASE_URL`: `https://phim.nguonc.com/api`
