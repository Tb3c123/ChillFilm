# 02. BẢN MÔ TẢ KỸ THUẬT TÍCH HỢP API (API INTEGRATION SPEC)

## 1. MÁY CHỦ API CỐT LÕI
- **Base URL:** `https://phim.nguonc.com/api`
- **Thời gian chờ kết nối (Timeout):** 10.000 ms (10 giây).
- **Cơ chế Tự động Thử lại (Auto-Retry):** 3 lần với Exponential Backoff (2s, 4s, 8s).

---

## 2. DANH SÁCH ENDPOINTS CỦA PHIM.NGUONC.COM
1. **Phim Mới Cập Nhật:**
   - **GET** `/films/phim-moi-cap-nhat?page={page}`
   - **Mô tả:** Lấy danh sách phim vừa được cập nhật tập mới nhất.
2. **Chi Tiết Phim:**
   - **GET** `/film/{slug}`
   - **Mô tả:** Lấy toàn bộ metadata 7 trường, danh sách server máy phát và danh sách tập phim.
3. **Tìm Kiếm Phim:**
   - **GET** `/films/search?keyword={keyword}&page={page}`
   - **Mô tả:** Tìm kiếm phim theo tên hoặc tên gốc.
4. **Lọc Theo Danh Mục / Thể Loại / Quốc Gia:**
   - **GET** `/films/danh-sach/{category}?page={page}`
   - **GET** `/films/the-loai/{genre}?page={page}`
   - **GET** `/films/quoc-gia/{country}?page={page}`

---

## 3. CẤU TRÚC PHẢN HỒI LUỒNG VIDEO (STREAM RESPONSE)
Trong mỗi tập phim trả về từ API:
- `m3u8`: Đường dẫn luồng video HLS (`.m3u8`) ưu tiên sử dụng cho Native VideoPlayer.
- `embed`: Đường dẫn trang web phát video nhúng dạng Iframe sử dụng dự phòng fallback khi link `.m3u8` bị hỏng.
