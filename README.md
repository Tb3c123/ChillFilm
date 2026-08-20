# 🎬 WATCH FILM ECOSYSTEM - HỆ SINH THÁI ỨNG DỤNG XEM PHIM ĐA NỀN TẢNG

![Movie Ecosystem Design Preview](https://images.unsplash.com/photo-1536440136628-849c177e76a1?auto=format&fit=crop&w=1200&q=80)

> Hệ sinh thái ứng dụng xem phim chất lượng cao kết nối trực tiếp với API **phim.nguonc.com**, bao gồm **Next.js 14 Web App** và **Flutter Android TV Box / Mobile App**, xây dựng 100% theo kiến trúc chuẩn **Clean Architecture** & **Design Patterns (Singleton, Repository, Factory, BLoC)**.

---

## 🌟 ĐẶC ĐIỂM NỔI BẬT

1. **Giao Diện Chuẩn Điện Ảnh & Màu Neon Cyan `#00e5ff`:**
   - Tông màu tối Cinema Dark (`#030508`) phối màu nhấn Electric Neon Cyan rực rỡ.
   - Vệt phát sáng Focus D-Pad Remote trên Android TV (`shadow: 0 0 40px rgba(0, 229, 255, 0.95)`) và hiệu ứng phóng to 1.08x.

2. **Hiển Thị Đầy Đủ 7 Trường Metadata Chi Tiết Phim:**
   - 📌 **Số Tập** (Ví dụ: `24/24 Tập`, `1 Tập (Phim Lẻ)`)
   - ⏱️ **Thời Lượng** (Ví dụ: `45 phút / tập`, `149 phút`)
   - 🎬 **Đạo Diễn** (Ví dụ: `Trần Khải Cơ`, `Anthony & Joe Russo`)
   - 🌟 **Diễn Viên** (Ví dụ: `Vương Hạc Đệ, Ngu Thư Hân`, `Robert Downey Jr.`)
   - 🎭 **Thể Loại** (Ví dụ: `Cổ Trang, Huyền Huyễn`, `Hành Động, Viễn Tưởng`)
   - 📅 **Năm Phát Hành** (Ví dụ: `2026`)
   - 🌍 **Quốc Gia** (Ví dụ: `Trung Quốc`, `Mỹ`, `Nhật Bản`, `Việt Nam`, `Hàn Quốc`)

3. **Trình Phát Video Thông Minh (HLS + Fallback Iframe):**
   - Tự động phát luồng HLS `.m3u8` chất lượng cao, tự động chuyển sang trang nhúng Iframe nếu file `.m3u8` gặp sự cố.
   - Tự động lưu tiến trình xem dở `currentTime` và mở Fullscreen tràn 100% màn hình TV.
   - Bấm số tập trỏ đúng 100% số tập được chọn.

---

## 🏗️ CẤU TRÚC DỰ ÁN (MONOREPO)

```text
watch_film/
├── .github/workflows/          # Github Actions Pipelines CI/CD
│   ├── web-ci-cd.yml
│   └── tv-mobile-build-apk.yml
├── apps/
│   ├── web/                    # Next.js 14 Web Application
│   └── tv-mobile/              # Flutter Android TV & Mobile Application
└── docs/                       # Bộ tài liệu kỹ thuật & vận hành dự án
    ├── 00_MASTER_ARCHITECTURE_RULES.md
    ├── 01_PRD_AND_BUSINESS_REQUIREMENTS.md
    ├── 02_API_INTEGRATION_SPEC.md
    ├── 03_DESIGN_SYSTEM_AND_MOCKUPS.md
    ├── 04_DEVELOPMENT_STEP_BY_STEP.md
    ├── 05_DEBUG_AND_TROUBLESHOOTING.md
    └── 06_BUILD_AND_DEPLOY_GUIDE.md
```

---

## 🚀 KHỞI CHẠY NHANH

### Web App:
```bash
cd apps/web
npm install
npm run dev
```

### Flutter Android TV / Mobile:
```bash
cd apps/tv-mobile
flutter pub get
flutter run -d android
```

---

## 📜 GIẤY PHÉP (LICENSE)
Phát triển theo giấy phép MIT License. Toàn bộ tài nguyên phim thuộc về máy chủ công cộng `phim.nguonc.com`.
