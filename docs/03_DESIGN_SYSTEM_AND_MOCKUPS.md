# 03. ĐẶC TẢ HỆ THỐNG THIẾT KẾ & MOCKUPS (DESIGN SYSTEM)

## 1. BẢNG MÀU CHUẨN ĐIỆN ẢNH (CINEMA THEME)
- **Primary Accent:** Electric Neon Cyan (`#00e5ff`)
- **Glow Highlight:** Neon Glow (`rgba(0, 229, 255, 0.95)`)
- **Secondary Accent:** Cinema Red (`#e50914`)
- **Background Main:** Cinema Black (`#030508`)
- **Card Background:** Dark Slate (`#121722`)

---

## 2. QUY TẮC HIỆU ỨNG D-PAD FOCUS TRÊN ANDROID TV
1. **Tỷ lệ Phóng to (Scale Factor):** `1.08x` mượt mà trong 200ms (`cubic-bezier(0.4, 0, 0.2, 1)`).
2. **Viền và Vệt Phát Sáng (Glowing Border):**
   - Viền: `3.5px solid #00e5ff`
   - Vệt phát sáng: `box-shadow: 0 0 40px rgba(0, 229, 255, 0.95)`
3. **Thuật toán Chuyển Focus Nút Bấm:**
   - Ban đầu mở ứng dụng, Focus nằm ở thẻ nội dung chính (`Content Area`).
   - Nhấn phím `ArrowDown` ở cuối màn hình nội dung: Giữ nguyên Focus trong khu vực nội dung, không được tự động nhảy sang Sidebar.
   - Nhấn phím `ArrowLeft` ở cột ngoài cùng bên trái của nội dung: Focus nhảy sang Sidebar Navigation.
