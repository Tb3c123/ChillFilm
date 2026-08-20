# 05. HƯỚNG DẪN XỬ LÝ 10 SỰ CỐ THỰC TẾ THƯỜNG GẶP (DEBUG & TROUBLESHOOTING)

## 1. LỖI CORS KHÌ GỌI API TRỰC TIẾP TRÊN TRÌNH DUYỆT WEB
- **Nguyên nhân:** Trình duyệt chặn request cross-origin khi gọi từ `localhost:3000` sang `phim.nguonc.com`.
- **Cách khắc phục:** Cấu hình Next.js Rewrites trong `apps/web/next.config.js`:
  ```javascript
  async rewrites() {
    return [
      {
        source: '/api-proxy/:path*',
        destination: 'https://phim.nguonc.com/api/:path*',
      },
    ];
  }
  ```

---

## 2. LỖI VIDEO HLS `.m3u8` KHÔNG PHÁT ĐƯỢC (FATAL STREAM ERROR)
- **Nguyên nhân:** Máy chủ chứa file m3u8 bị ngắt kết nối hoặc thiếu header CORS.
- **Cách khắc phục:** Tự động bắt sự kiện `hls.on(HLS.Events.ERROR)` và chuyển trạng thái `setUseIframe(true)` để phát qua `IframeEmbed`.

---

## 3. LỖI MẤT FOCUS STATE KHI BẤM D-PAD REMOTE TRÊN ANDROID TV
- **Nguyên nhân:** Widget bị rebuilt làm mất reference của `FocusNode`.
- **Cách khắc phục:** Duy trì mảng `contentFocusables` cố định và gọi `initTVFocus()` ngay khi cây Widget được render xong.

---

## 4. LỖI CRASH ỨNG DỤNG DO MẤT KẾT NỐI MẠNG ĐỘT NGỘT
- **Nguyên nhân:** Ngoại lệ mạng không được bắt dẫn đến sập giao diện.
- **Cách khắc phục:** Bọc ứng dụng trong `ErrorBoundary` (Web) và `runZonedGuarded` (Flutter).

---

## 5. LỖI GOOGLE PLAY STORE TỪ CHỐI DO THIẾU LEANBACK BANNER
- **Nguyên nhân:** Thiếu khai báo `android:banner` hoặc `touchscreen: false`.
- **Cách khắc phục:** Khai báo đầy đủ trong `AndroidManifest.xml`:
  ```xml
  <uses-feature android:name="android.software.leanback" android:required="false" />
  <uses-feature android:name="android.hardware.touchscreen" android:required="false" />
  <application android:banner="@drawable/tv_banner">
  ```

---

## 6. LỖI MEMORY LEAK KHI CHUYỂN TẬP PHIM LIÊN TỤC
- **Nguyên nhân:** Trình phát `Hls.js` hoặc `VideoPlayerController` chưa được hủy (`destroy()` / `dispose()`).
- **Cách khắc phục:** Luôn gọi `hls.destroy()` trong hàm cleanup của `useEffect` hoặc `_controller.dispose()` trong `dispose()`.

---

## 7. LỖI SAI SỐ TẬP KHI BẤM CHỌN TẬP BẤT KỲ
- **Nguyên nhân:** Nút bấm truyền cố định tham số `episodeNum = 1`.
- **Cách khắc phục:** Truyền đúng chỉ số `i` động: `openMoviePlayer(slug, i)`.

---

## 8. LỖI FONT CHỮ BỊ NHỎ TRÊN SMART TV 10-FOOT UI
- **Nguyên nhân:** Dùng cỡ font tiêu chuẩn của di động (12px - 14px).
- **Cách khắc phục:** Nâng kích thước font tiêu đề lên tối thiểu `24px - 32px` cho màn hình TV.

---

## 9. LỖI MẤT TIẾN TRÌNH XEM DỞ KHI TẮT ỨNG DỤNG
- **Nguyên nhân:** Ghi dữ liệu vào bộ nhớ tạm không kịp trước khi tắt tab.
- **Cách khắc phục:** Đặt hook tự động ghi tiến trình mỗi 5 giây (`useWatchHistory`).

---

## 10. LỖI BUILD APK THẤT BẠI DO LỖI GRADLE JAVA VERSION
- **Nguyên nhân:** Không tương thích giữa Flutter SDK và Java JDK.
- **Cách khắc phục:** Sử dụng chính xác Java JDK 17 trong GitHub Actions Pipeline.
