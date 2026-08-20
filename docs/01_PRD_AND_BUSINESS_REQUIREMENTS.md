# 01. ĐẶC TẢ NGHIỆP VỤ KINH DOANH VÀ SẢN PHẨM (PRD & BRD)

## 1. TỔNG QUAN SẢN PHẨM
Hệ sinh thái `watch_film` cung cấp ứng dụng xem phim trực tuyến đa nền tảng kết nối trực tiếp với API `phim.nguonc.com`:
- **Web Responsive Application (`apps/web`):** Tối ưu trải nghiệm trình duyệt trên máy tính và điện thoại di động.
- **Android TV & Mobile Application (`apps/tv-mobile`):** Tối ưu trải nghiệm điều khiển D-Pad Remote 10-foot trên Android TV Box và cảm ứng trên Smartphone.

---

## 2. YÊU CẦU NĂNG LỰC NGHIỆP VỤ
1. **Tìm kiếm & Khám phá phim:**
   - Phân loại phim mới cập nhật, phim bộ, phim lẻ, hoạt hình, TV Shows.
   - Lọc đa tiêu chí: Định dạng, Thể loại, Quốc gia, Năm phát hành.
   - Tìm kiếm thời gian thực với cơ chế hoãn (debounce 500ms).
2. **Hiển thị Chi tiết phim đầy đủ 7 trường Metadata:**
   - 📌 **Số Tập** (Ví dụ: `24/24 Tập`, `1 Tập (Phim Lẻ)`)
   - ⏱️ **Thời Lượng** (Ví dụ: `45 phút / tập`, `149 phút`)
   - 🎬 **Đạo Diễn** (Ví dụ: `Trần Khải Cơ`, `Anthony & Joe Russo`)
   - 🌟 **Diễn Viên** (Ví dụ: `Vương Hạc Đệ, Ngu Thư Hân`, `Robert Downey Jr.`)
   - 🎭 **Thể Loại** (Ví dụ: `Cổ Trang, Huyền Huyễn`, `Hành Động, Viễn Tưởng`)
   - 📅 **Năm Phát Hành** (Ví dụ: `2026`)
   - 🌍 **Quốc Gia** (Ví dụ: `Trung Quốc`, `Mỹ`, `Nhật Bản`, `Việt Nam`, `Hàn Quốc`)
3. **Trình phát Video & Quản lý Tiến trình Xem:**
   - Phát luồng HLS `.m3u8` chất lượng cao, tự động fallback sang `IframeEmbed` khi link HLS gặp sự cố.
   - Tự động mở rộng Fullscreen 100% tràn toàn bộ màn hình khi xem phim trên Android TV.
   - Tự động lưu tiến trình xem dở `currentTime` và phục hồi khi mở lại phim.
