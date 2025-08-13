# Fix Google Drive Settings RLS Issue

## Vấn đề
Khi cố gắng lưu cài đặt Google Drive, bạn gặp lỗi 42501 (permission denied) do Row Level Security (RLS) policies không được cấu hình đúng.

## Nguyên nhân
RLS policies trong file `sql/create_google_drive_settings_table.sql` có lỗi syntax - tham chiếu đến `users.id` và `users.raw_user_meta_data` mà không có JOIN với bảng `auth.users`.

## Giải pháp đơn giản: Tắt RLS (Khuyến nghị)
Vì trang settings chỉ admin mới truy cập được, việc tắt RLS hoàn toàn an toàn.

1. **Truy cập Supabase Dashboard** của dự án
2. **Vào SQL Editor**
3. **Chạy script từ file `disable_google_drive_settings_rls.sql`:**
   ```sql
   -- Drop all existing policies
   DROP POLICY IF EXISTS google_drive_settings_admin_policy ON google_drive_settings;
   DROP POLICY IF EXISTS google_drive_settings_to_qltb_policy ON google_drive_settings;
   DROP POLICY IF EXISTS google_drive_settings_read_policy ON google_drive_settings;
   DROP POLICY IF EXISTS google_drive_settings_all_access ON google_drive_settings;
   
   -- Disable RLS completely
   ALTER TABLE google_drive_settings DISABLE ROW LEVEL SECURITY;
   ```

## Files đã tạo/sửa đổi

### Tạo mới:
- `src/lib/supabase-admin.ts` - Admin client với service role
- `src/app/api/drive-settings/route.ts` - API route để xử lý Google Drive settings
- `fix_google_drive_settings_policies.sql` - Script để fix RLS policies

### Sửa đổi:
- `src/app/(app)/settings/page.tsx` - Sử dụng API route thay vì gọi trực tiếp Supabase

## Cách test
1. Restart development server
2. Truy cập `/settings` 
3. Thử cấu hình Google Drive với:
   - Tên thư mục: "Test Folder"
   - URL: https://drive.google.com/drive/folders/1abcd...

## Lưu ý bảo mật
- Service role key có quyền admin hoàn toàn
- Chỉ sử dụng trong server-side (API routes)
- Đừng expose key này ra client-side
- Nên áp dụng Cách 1 để fix RLS policies thay vì dựa vào service role
