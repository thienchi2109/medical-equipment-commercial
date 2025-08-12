# 🚀 Quick Start: Tạo Database Setup cho Khách hàng mới

## 📋 Tóm tắt

Bạn đã có một hệ thống hoàn chỉnh để tạo file setup database cho khách hàng mới. Hệ thống này sẽ tự động export toàn bộ database schema và tạo file SQL hoàn chỉnh để setup trên tài khoản Supabase mới.

## 🎯 Cách sử dụng nhanh

### Phương pháp 1: Script tổng hợp (Khuyến nghị)
```bash
# Chạy script tự động - sẽ chọn phương pháp tốt nhất
node scripts/create-customer-database.js "Bệnh viện ABC"

# Hoặc chạy tương tác
node scripts/create-customer-database.js
```

### Phương pháp 2: Sử dụng Supabase CLI (Chính xác nhất)
```bash
# Bước 1: Setup Supabase CLI (chỉ cần làm 1 lần)
node scripts/setup-supabase-cli.js

# Bước 2: Export schema
node scripts/export-supabase-schema.js --customer="Bệnh viện ABC"
```

### Phương pháp 3: Sử dụng Migration files (Fallback)
```bash
node scripts/package-database-schema.js --customer="Bệnh viện ABC"
```

## 📁 Kết quả

Sau khi chạy script, bạn sẽ có:
- **File SQL hoàn chỉnh** (VD: `setup-benh-vien-abc.sql`)
- **Toàn bộ database schema** từ Supabase hiện tại
- **Dữ liệu mẫu** phù hợp cho khách hàng
- **Hướng dẫn setup chi tiết** trong file SQL

## 🔄 Quy trình giao hàng

1. **Tạo file setup**
   ```bash
   node scripts/create-customer-database.js "Bệnh viện ABC"
   ```

2. **Gửi cho khách hàng**
   - File SQL setup
   - Hướng dẫn sử dụng (có trong file SQL)

3. **Hướng dẫn khách hàng**
   - Tạo project Supabase mới
   - Chạy file SQL trong SQL Editor
   - Cập nhật .env.local
   - Test đăng nhập

## 📋 Tài khoản mặc định

Mỗi file setup sẽ tạo các tài khoản:
- `admin / admin123` - Quản trị viên
- `to_qltb / qltb123` - Trưởng tổ QLTB  
- `qltb_noi / qltb123` - QLTB Khoa Nội
- `user_demo / user123` - Nhân viên demo

⚠️ **Quan trọng**: Đổi mật khẩu ngay sau khi setup!

## 🛠️ Troubleshooting

### Lỗi "Supabase CLI not found"
```bash
# Cài đặt Supabase CLI
npm install -g supabase

# Hoặc chạy script setup
node scripts/setup-supabase-cli.js
```

### Lỗi "Not logged in"
```bash
# Đăng nhập Supabase
supabase login

# Kiểm tra projects
supabase projects list

# Link với project hiện tại
supabase link --project-ref [your-project-ref]
```

### Lỗi "Migration files not found"
- Đảm bảo thư mục `supabase/migrations` tồn tại
- Kiểm tra các file migration có đúng format không

### File SQL quá lớn
- File lớn là bình thường (100-200KB)
- Nếu quá lớn (>1MB), kiểm tra có dữ liệu thừa không

## 📞 Hỗ trợ

Nếu gặp vấn đề:
1. Kiểm tra log lỗi chi tiết
2. Thử phương pháp fallback (migration files)
3. Liên hệ team phát triển với thông tin:
   - Tên khách hàng
   - Phương pháp đã sử dụng
   - Log lỗi đầy đủ

## 🎉 Hoàn thành

Bây giờ bạn đã có thể:
- ✅ Tạo file setup database cho khách hàng mới
- ✅ Export chính xác schema từ Supabase
- ✅ Tự động fallback nếu CLI không khả dụng
- ✅ Cung cấp hướng dẫn chi tiết cho khách hàng
- ✅ Đảm bảo tính nhất quán và chính xác

**Chúc bạn triển khai thành công! 🚀**
