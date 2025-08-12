# Chức năng Cấu hình Google Drive

## Tổng quan

Tính năng này cho phép chủ tài khoản mới tự thay đổi link thư mục Google Drive để lưu trữ file đính kèm của thiết bị y tế, thay vì sử dụng link Google Drive mặc định của chủ cũ.

## Quyền truy cập

Chỉ các người dùng có role `admin` hoặc `to_qltb` mới có thể cấu hình Google Drive settings.

## Tính năng đã được triển khai

### 1. Database Schema
- Tạo bảng `google_drive_settings` để lưu trữ cấu hình
- Bao gồm các trường: `folder_url`, `folder_name`, `is_active`
- Row Level Security (RLS) được áp dụng

### 2. Backend Components

#### Hook: `useDriveSettings`
- Load và quản lý Google Drive settings
- Cung cấp các method: `getFolderUrl()`, `getFolderName()`, `isConfigured`
- Tự động fallback về URL mặc định nếu chưa cấu hình

#### Settings Page: `/settings`
- Giao diện cho phép admin/to_qltb cấu hình Google Drive
- Validation URL Google Drive
- Hướng dẫn chi tiết cách lấy URL thư mục Google Drive
- Hiển thị thông tin thư mục hiện tại

### 3. Frontend Integration

#### Equipment Page Updates
- Tab "File đính kèm" sử dụng dynamic Google Drive URL
- Hiển thị thông báo nếu chưa cấu hình thư mục riêng
- Link dẫn đến thư mục Google Drive được cấu hình

#### Navigation Updates
- Thêm menu "Cài đặt" vào desktop sidebar
- Thêm menu "Cài đặt" vào mobile navigation dropdown
- Chỉ hiển thị cho user có quyền admin/to_qltb

#### Dashboard Banner
- Hiển thị banner thông báo khi chưa cấu hình Google Drive
- Có thể dismiss banner tạm thời
- Tự động ẩn khi đã cấu hình xong

## Hướng dẫn sử dụng

### Cho Admin/To_qltb

1. **Truy cập Settings**
   - Desktop: Menu sidebar > Cài đặt
   - Mobile: Menu "Thêm" > Cài đặt

2. **Cấu hình Google Drive**
   - Tạo thư mục mới trên Google Drive
   - Chia sẻ thư mục với quyền "Bất kỳ ai có link đều xem được"
   - Copy URL thư mục và paste vào form settings
   - Nhập tên mô tả cho thư mục
   - Nhấn "Lưu cấu hình"

3. **Xác nhận hoạt động**
   - Vào trang Thiết bị > Chi tiết thiết bị > Tab "File đính kèm"
   - Link sẽ dẫn đến thư mục Google Drive mới đã cấu hình

### Cho người dùng khác

- Khi thêm file đính kèm, sẽ được dẫn đến thư mục Google Drive đã được admin cấu hình
- Không thể thay đổi cấu hình Google Drive

## Database Migration

Chạy script SQL sau để tạo bảng cần thiết:

```sql
-- Chạy file: sql/create_google_drive_settings_table.sql
```

## URL Google Drive hỗ trợ

Hệ thống hỗ trợ 2 định dạng URL Google Drive:

1. **URL thư mục**: `https://drive.google.com/drive/folders/{FOLDER_ID}`
2. **URL chia sẻ**: `https://drive.google.com/open?id={FOLDER_ID}`

## Technical Details

### File Structure
```
src/
├── app/(app)/settings/
│   └── page.tsx                          # Settings page
├── hooks/
│   └── use-drive-settings.ts            # Drive settings hook
├── components/
│   └── drive-settings-banner.tsx        # Dashboard notification banner
└── app/(app)/equipment/page.tsx         # Updated equipment page

sql/
└── create_google_drive_settings_table.sql # Database migration

docs/
└── GOOGLE_DRIVE_SETTINGS.md            # This documentation
```

### Key Functions

- `useDriveSettings()`: Hook để quản lý Google Drive settings
- `getFolderUrl()`: Trả về URL thư mục (có fallback)
- `getFolderName()`: Trả về tên thư mục
- `isConfigured`: Boolean check xem đã cấu hình chưa

### Security Considerations

- RLS policy chỉ cho phép admin/to_qltb chỉnh sửa settings
- Tất cả authenticated users có thể đọc active settings
- URL validation để đảm bảo chỉ accept Google Drive URLs
- No sensitive data stored (chỉ public folder URLs)

## Troubleshooting

### Vấn đề thường gặp

1. **Không thể lưu cấu hình**
   - Kiểm tra URL có đúng định dạng Google Drive không
   - Đảm bảo user có role admin hoặc to_qltb

2. **File đính kèm vẫn dẫn đến thư mục cũ**
   - Clear browser cache
   - Kiểm tra settings đã lưu chưa
   - Kiểm tra database có record nào với is_active=true không

3. **Banner không ẩn sau khi cấu hình**
   - Clear localStorage: `localStorage.removeItem('drive-settings-banner-dismissed')`
   - Refresh page

### Database Queries để debug

```sql
-- Xem tất cả settings
SELECT * FROM google_drive_settings ORDER BY created_at DESC;

-- Xem setting đang active
SELECT * FROM google_drive_settings WHERE is_active = true;

-- Reset về mặc định (chỉ khi cần thiết)
UPDATE google_drive_settings SET is_active = false;
INSERT INTO google_drive_settings (folder_url, folder_name, is_active) 
VALUES (
    'https://drive.google.com/open?id=1-lgEygGCIfxCbIIdgaCmh3GFJgAMr63e&usp=drive_fs',
    'Thư mục Drive mặc định',
    true
);
```
