# 📦 Hướng dẫn đóng gói Database Schema cho Supabase mới

Thư mục này chứa các script để tạo file SQL hoàn chỉnh cho việc setup database trên tài khoản Supabase mới.

## 🎯 Mục đích

Khi cần triển khai hệ thống cho khách hàng mới, thay vì phải chạy từng migration file một cách thủ công, bạn có thể sử dụng các script này để:

1. **Export chính xác database schema** từ Supabase hiện tại
2. **Bao gồm dữ liệu mẫu** phù hợp cho khách hàng
3. **Đảm bảo tính chính xác** bằng Supabase CLI
4. **Cung cấp hướng dẫn chi tiết** cho việc setup

## 📁 Các file script

### 1. `export-supabase-schema.js` (Script chính - Khuyến nghị)
Script sử dụng Supabase CLI để export chính xác toàn bộ database schema.

**Cách sử dụng:**
```bash
# Cách 1: Sử dụng tham số mặc định
node scripts/export-supabase-schema.js

# Cách 2: Chỉ định tên khách hàng và file output
node scripts/export-supabase-schema.js --customer="Bệnh viện ABC" --output="setup-abc.sql"
```

**Tính năng:**
- ✅ Sử dụng Supabase CLI để export chính xác
- ✅ Bao gồm toàn bộ cấu trúc database
- ✅ Export cả dữ liệu hiện tại (tùy chọn)
- ✅ Tạo dữ liệu mẫu cho khách hàng mới
- ✅ Hướng dẫn setup chi tiết

### 2. `setup-supabase-cli.js` (Script setup)
Script giúp cài đặt và cấu hình Supabase CLI.

**Cách sử dụng:**
```bash
node scripts/setup-supabase-cli.js
```

**Tính năng:**
- ✅ Kiểm tra và cài đặt Supabase CLI
- ✅ Hướng dẫn đăng nhập Supabase
- ✅ Link với project hiện tại
- ✅ Kiểm tra kết nối

### 3. `package-database-schema.js` (Script cũ)
Script cũ dựa trên migration files (không khuyến nghị do có thể thiếu sót).

**Cách sử dụng:**
```bash
node scripts/package-database-schema.js --customer="Bệnh viện ABC"
```

### 2. `create-customer-database.js` (Script tổng hợp - Khuyến nghị)
Script tổng hợp tự động chọn phương pháp tốt nhất để tạo file setup.

**Cách sử dụng:**
```bash
# Chạy script tương tác
node scripts/create-customer-database.js

# Hoặc truyền tên khách hàng trực tiếp
node scripts/create-customer-database.js "Bệnh viện Đa khoa XYZ"
```

**Tính năng:**
- ✅ Tự động chọn phương pháp tốt nhất (CLI hoặc migration)
- ✅ Giao diện tương tác thân thiện
- ✅ Fallback tự động nếu CLI không khả dụng
- ✅ Validation input và kiểm tra lỗi
- ✅ Hướng dẫn từng bước chi tiết

### 3. `create-customer-setup.js` (Script cũ)
Script cũ chỉ sử dụng migration files (không khuyến nghị).

### 3. `setup-customer-database.js` (Script triển khai)
Script để triển khai database lên Supabase project có sẵn.

**Cách sử dụng:**
```bash
node scripts/setup-customer-database.js \
  --customer="Hospital ABC" \
  --supabase-url="https://xxx.supabase.co" \
  --supabase-key="eyJ..."
```

## 🚀 Quy trình triển khai cho khách hàng mới (Khuyến nghị)

### Bước 0: Setup Supabase CLI (Chỉ cần làm 1 lần)
```bash
# Chạy script setup tự động
node scripts/setup-supabase-cli.js

# Hoặc setup thủ công:
npm install -g supabase
supabase login
supabase projects list
supabase link --project-ref [your-project-ref]
```

### Bước 1: Tạo file setup database
```bash
# Sử dụng script tổng hợp (khuyến nghị - tự động chọn phương pháp tốt nhất)
node scripts/create-customer-database.js "Bệnh viện ABC"

# Hoặc chỉ định phương pháp cụ thể:
# Sử dụng Supabase CLI
node scripts/export-supabase-schema.js --customer="Bệnh viện ABC"

# Sử dụng migration files
node scripts/package-database-schema.js --customer="Bệnh viện ABC"
```

### Bước 2: Gửi file cho khách hàng
File SQL được tạo sẽ chứa:
- Toàn bộ database schema
- Dữ liệu mẫu phù hợp
- Hướng dẫn setup chi tiết
- Tài khoản mặc định

### Bước 3: Hướng dẫn khách hàng setup

#### 3.1. Tạo Supabase project mới
1. Truy cập https://supabase.com/dashboard
2. Tạo project mới
3. Chờ project được khởi tạo

#### 3.2. Chạy script SQL
**Cách 1 - Supabase Dashboard (Khuyến nghị):**
1. Vào SQL Editor trong dashboard
2. Copy toàn bộ nội dung file SQL
3. Paste và chạy

**Cách 2 - psql:**
```bash
psql "postgresql://postgres:[PASSWORD]@[HOST]:5432/postgres" -f setup-file.sql
```

#### 3.3. Cập nhật .env.local
```env
NEXT_PUBLIC_SUPABASE_URL=https://[project-ref].supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[anon-key]
SUPABASE_SERVICE_ROLE_KEY=[service-role-key]
```

#### 3.4. Test hệ thống
1. Chạy ứng dụng: `npm run dev`
2. Đăng nhập với: `admin / admin123`
3. Kiểm tra các chức năng cơ bản
4. **Đổi mật khẩu mặc định ngay lập tức**

## 📋 Tài khoản mặc định

Mỗi file setup sẽ tạo các tài khoản sau:

| Username | Password | Vai trò | Khoa/Phòng |
|----------|----------|---------|------------|
| admin | admin123 | Quản trị viên | Ban Giám đốc |
| to_qltb | qltb123 | Trưởng tổ QLTB | Tổ QLTB |
| qltb_noi | qltb123 | QLTB Khoa | Khoa Nội |
| qltb_ngoai | qltb123 | QLTB Khoa | Khoa Ngoại |
| qltb_cdha | qltb123 | QLTB Khoa | Phòng CĐHA |
| user_demo | user123 | Nhân viên | Khoa Nội |

⚠️ **Quan trọng:** Đổi tất cả mật khẩu mặc định ngay sau khi setup!

## 🛠️ Dữ liệu mẫu được tạo

- **12 phòng ban** (Khoa Nội, Ngoại, Sản, Nhi, Cấp cứu, XN, CĐHA, v.v.)
- **8 loại thiết bị** (Y tế chung, XN, CĐHA, Phẫu thuật, v.v.)
- **10 thiết bị mẫu** với thông tin đầy đủ
- **6 kế hoạch bảo trì** định kỳ
- **2 công việc bảo trì** mẫu
- **6 bản ghi lịch sử** thiết bị

## 🔧 Tùy chỉnh

### Thêm dữ liệu mẫu
Chỉnh sửa function `generateSampleData()` trong `package-database-schema.js`:

```javascript
// Thêm phòng ban mới
INSERT INTO phong_ban (ten_phong_ban, mo_ta) VALUES
('Phòng mới', 'Mô tả phòng mới');

// Thêm thiết bị mới
INSERT INTO thiet_bi (...) VALUES (...);
```

### Thay đổi tài khoản mặc định
Chỉnh sửa phần tạo `nhan_vien` trong function `generateSampleData()`.

## ⚠️ Lưu ý bảo mật

1. **Đổi mật khẩu mặc định** ngay sau khi setup
2. **Không commit** file setup chứa thông tin nhạy cảm
3. **Backup database** định kỳ
4. **Không chia sẻ** thông tin kết nối database
5. **Sử dụng HTTPS** cho tất cả kết nối

## 🐛 Troubleshooting

### Lỗi thường gặp:

**1. "Extension pg_trgm not found"**
- Đảm bảo Supabase project hỗ trợ extension này
- Thử chạy `CREATE EXTENSION IF NOT EXISTS pg_trgm;` riêng

**2. "Table already exists"**
- Database đã có dữ liệu từ trước
- Sử dụng database mới hoặc xóa dữ liệu cũ

**3. "Permission denied"**
- Kiểm tra quyền của user kết nối database
- Sử dụng service role key thay vì anon key

### Liên hệ hỗ trợ
Nếu gặp vấn đề, vui lòng liên hệ team phát triển với thông tin:
- Tên khách hàng
- File setup đã sử dụng
- Lỗi cụ thể (screenshot nếu có)
- Thông tin Supabase project (không bao gồm credentials)

## 📝 Changelog

- **v1.0.0**: Phiên bản đầu tiên với đầy đủ tính năng
- Hỗ trợ tạo file SQL hoàn chỉnh
- Bao gồm dữ liệu mẫu và hướng dẫn
- Script tương tác thân thiện
