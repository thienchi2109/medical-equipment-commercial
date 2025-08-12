#!/usr/bin/env node

/**
 * 📦 PACKAGE COMPLETE DATABASE SCHEMA FOR NEW SUPABASE SETUP
 * 
 * Script này tạo ra một file SQL hoàn chỉnh chứa toàn bộ database schema
 * để setup trên tài khoản Supabase mới. Chỉ cần thay đổi biến môi trường
 * trong .env.local là có thể chạy được ngay.
 * 
 * Tính năng:
 * - Kết hợp tất cả migration files thành 1 file SQL duy nhất
 * - Tạo sample data phù hợp cho khách hàng mới
 * - Tối ưu hóa thứ tự thực thi để tránh lỗi dependency
 * - Bao gồm indexes và performance optimizations
 * - Tự động tạo user accounts mặc định
 * 
 * Usage:
 *   node scripts/package-database-schema.js --customer="Bệnh viện ABC" --output="setup-abc.sql"
 */

const fs = require('fs');
const path = require('path');

// Color utilities for console output
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m'
};

function log(message, color = colors.reset) {
  console.log(`${color}${message}${colors.reset}`);
}

function logStep(step, message) {
  log(`\n${colors.cyan}${colors.bright}🔄 Bước ${step}: ${message}${colors.reset}`);
}

function logSuccess(message) {
  log(`✅ ${message}`, colors.green);
}

function logError(message) {
  log(`❌ ${message}`, colors.red);
}

function logWarning(message) {
  log(`⚠️  ${message}`, colors.yellow);
}

// Parse command line arguments
function parseArgs() {
  const args = process.argv.slice(2);
  const config = {
    customer: 'Bệnh viện Demo',
    output: 'database-setup-complete.sql'
  };
  
  args.forEach(arg => {
    if (arg.startsWith('--')) {
      const [key, value] = arg.substring(2).split('=');
      if (value) {
        config[key] = value.replace(/['"]/g, ''); // Remove quotes
      }
    }
  });
  
  return config;
}

// Get all migration files in correct order
function getMigrationFiles() {
  const migrationsDir = path.join(__dirname, '../supabase/migrations');
  
  if (!fs.existsSync(migrationsDir)) {
    throw new Error('Thư mục migrations không tồn tại');
  }
  
  const files = fs.readdirSync(migrationsDir)
    .filter(file => file.endsWith('.sql'))
    .sort(); // Files có timestamp nên sort sẽ đúng thứ tự
  
  return files.map(file => ({
    name: file,
    path: path.join(migrationsDir, file),
    content: fs.readFileSync(path.join(migrationsDir, file), 'utf8')
  }));
}

// Clean and optimize SQL content
function processSQLContent(content, fileName) {
  // Remove comment separators
  content = content.replace(/^-- =+.*$/gm, '');
  
  // Remove excessive blank lines
  content = content.replace(/\n\s*\n\s*\n/g, '\n\n');
  
  // Remove ANALYZE statements (will be added at the end)
  content = content.replace(/^ANALYZE\s+.*;$/gm, '');
  
  // Add file header
  const header = `\n-- =====================================================\n-- ${fileName}\n-- =====================================================\n`;
  
  return header + content.trim() + '\n';
}

// Generate comprehensive sample data
function generateSampleData(customerName) {
  const customerCode = customerName.replace(/\s+/g, '_').toUpperCase().substring(0, 10);
  const currentYear = new Date().getFullYear();
  
  return `
-- =====================================================
-- DỮ LIỆU MẪU CHO ${customerName}
-- =====================================================

-- 1. Tạo các phòng ban mẫu
INSERT INTO phong_ban (ten_phong_ban, mo_ta) VALUES
('Ban Giám đốc', 'Ban Giám đốc bệnh viện'),
('Khoa Nội', 'Khoa Nội tổng hợp'),
('Khoa Ngoại', 'Khoa Ngoại tổng hợp'),
('Khoa Sản', 'Khoa Sản phụ khoa'),
('Khoa Nhi', 'Khoa Nhi'),
('Khoa Cấp cứu', 'Khoa Cấp cứu'),
('Phòng Xét nghiệm', 'Phòng Xét nghiệm'),
('Phòng Chẩn đoán hình ảnh', 'Phòng CĐHA'),
('Phòng Phẫu thuật', 'Phòng Phẫu thuật'),
('Khoa Dược', 'Khoa Dược'),
('Phòng Kế hoạch tổng hợp', 'Phòng KHTC'),
('Tổ Quản lý thiết bị', 'Tổ QLTB trực thuộc KHTC')
ON CONFLICT (ten_phong_ban) DO NOTHING;

-- 2. Tạo các loại thiết bị mẫu
INSERT INTO loai_thiet_bi (ten_loai, mo_ta) VALUES
('Thiết bị y tế chung', 'Thiết bị y tế sử dụng chung'),
('Máy xét nghiệm', 'Máy xét nghiệm các loại'),
('Máy chẩn đoán hình ảnh', 'Máy X-quang, CT, MRI, siêu âm'),
('Thiết bị phẫu thuật', 'Thiết bị phẫu thuật và can thiệp'),
('Thiết bị hồi sức', 'Thiết bị hồi sức cấp cứu'),
('Thiết bị theo dõi', 'Thiết bị theo dõi bệnh nhân'),
('Thiết bị thông tin', 'Máy tính, máy in, thiết bị IT'),
('Thiết bị vận chuyển', 'Xe đẩy, cáng, thiết bị vận chuyển')
ON CONFLICT (ten_loai) DO NOTHING;

-- 3. Tạo tài khoản người dùng mẫu
INSERT INTO nhan_vien (username, password, full_name, role, khoa_phong) VALUES
('admin', 'admin123', 'Quản trị viên hệ thống', 'admin', 'Ban Giám đốc'),
('to_qltb', 'qltb123', 'Trưởng tổ QLTB', 'to_qltb', 'Tổ Quản lý thiết bị'),
('qltb_noi', 'qltb123', 'QLTB Khoa Nội', 'qltb_khoa', 'Khoa Nội'),
('qltb_ngoai', 'qltb123', 'QLTB Khoa Ngoại', 'qltb_khoa', 'Khoa Ngoại'),
('qltb_san', 'qltb123', 'QLTB Khoa Sản', 'qltb_khoa', 'Khoa Sản'),
('qltb_nhi', 'qltb123', 'QLTB Khoa Nhi', 'qltb_khoa', 'Khoa Nhi'),
('qltb_cc', 'qltb123', 'QLTB Cấp cứu', 'qltb_khoa', 'Khoa Cấp cứu'),
('qltb_xn', 'qltb123', 'QLTB Xét nghiệm', 'qltb_khoa', 'Phòng Xét nghiệm'),
('qltb_cdha', 'qltb123', 'QLTB CĐHA', 'qltb_khoa', 'Phòng Chẩn đoán hình ảnh'),
('user_demo', 'user123', 'Nhân viên demo', 'user', 'Khoa Nội')
ON CONFLICT (username) DO NOTHING;

-- 4. Tạo thiết bị mẫu
INSERT INTO thiet_bi (
  ma_thiet_bi, ten_thiet_bi, model, serial, hang_san_xuat, noi_san_xuat, nam_san_xuat,
  khoa_phong_quan_ly, vi_tri_lap_dat, nguoi_dang_truc_tiep_quan_ly, tinh_trang_hien_tai,
  ngay_nhap, ngay_dua_vao_su_dung, nguon_kinh_phi, gia_goc, han_bao_hanh,
  cau_hinh_thiet_bi, phu_kien_kem_theo, ghi_chu,
  chu_ky_bt_dinh_ky, ngay_bt_tiep_theo
) VALUES
-- Thiết bị Khoa Nội
('${customerCode}_001', 'Máy siêu âm tim', 'Vivid E95', 'VE95001', 'GE Healthcare', 'Mỹ', ${currentYear - 1}, 'Khoa Nội', 'Phòng khám tim mạch', 'BS. Nguyễn Văn A', 'Hoạt động', CURRENT_DATE - INTERVAL '1 year', CURRENT_DATE - INTERVAL '11 months', 'Ngân sách nhà nước', 2500000000, CURRENT_DATE + INTERVAL '1 year', 'Màn hình LCD 19 inch, đầu dò tim mạch', 'Gel siêu âm, túi đựng đầu dò', 'Thiết bị hoạt động tốt', 6, CURRENT_DATE + INTERVAL '3 months'),
('${customerCode}_002', 'Máy điện tim 12 cần', 'MAC 2000', 'MAC2000002', 'GE Healthcare', 'Mỹ', ${currentYear}, 'Khoa Nội', 'Phòng khám tim mạch', 'BS. Nguyễn Văn A', 'Hoạt động', CURRENT_DATE - INTERVAL '6 months', CURRENT_DATE - INTERVAL '5 months', 'Ngân sách nhà nước', 150000000, CURRENT_DATE + INTERVAL '18 months', 'Máy in nhiệt, 12 cần đo', 'Giấy in ECG, cáp kết nối', 'Thiết bị mới', 3, CURRENT_DATE + INTERVAL '1 month'),

-- Thiết bị CĐHA
('${customerCode}_003', 'Máy X-quang kỹ thuật số', 'Ysio Max', 'YM2021003', 'Siemens', 'Đức', ${currentYear - 2}, 'Phòng Chẩn đoán hình ảnh', 'Phòng X-quang 1', 'KTV. Trần Thị B', 'Hoạt động', CURRENT_DATE - INTERVAL '2 years', CURRENT_DATE - INTERVAL '23 months', 'Vốn ODA', 3500000000, CURRENT_DATE + INTERVAL '6 months', 'Detector phẳng 43x43cm, bàn chụp di động', 'Áo chì bảo vệ, marker kim loại', 'Cần hiệu chuẩn định kỳ', 12, CURRENT_DATE + INTERVAL '2 months'),
('${customerCode}_004', 'Máy CT 64 lát cắt', 'SOMATOM go.Top', 'SGT2023004', 'Siemens', 'Đức', ${currentYear - 1}, 'Phòng Chẩn đoán hình ảnh', 'Phòng CT', 'KTV. Trần Thị B', 'Hoạt động', CURRENT_DATE - INTERVAL '1 year', CURRENT_DATE - INTERVAL '10 months', 'Vốn ODA', 8500000000, CURRENT_DATE + INTERVAL '2 years', 'Gantry 70cm, bàn bệnh nhân carbon fiber', 'Thuốc cản quang, bơm tiêm tự động', 'Thiết bị cao cấp', 6, CURRENT_DATE + INTERVAL '4 months'),

-- Thiết bị Xét nghiệm
('${customerCode}_005', 'Máy xét nghiệm máu tự động', 'DxH 900', 'DXH900005', 'Beckman Coulter', 'Mỹ', ${currentYear}, 'Phòng Xét nghiệm', 'Khu vực huyết học', 'KTV. Lê Văn C', 'Hoạt động', CURRENT_DATE - INTERVAL '3 months', CURRENT_DATE - INTERVAL '2 months', 'Ngân sách nhà nước', 1800000000, CURRENT_DATE + INTERVAL '2 years', 'Throughput 90 mẫu/giờ, 29 thông số', 'Reagent pack, control sample', 'Thiết bị mới nhập', 3, CURRENT_DATE + INTERVAL '1 month'),
('${customerCode}_006', 'Máy xét nghiệm sinh hóa', 'AU5800', 'AU5800006', 'Beckman Coulter', 'Nhật Bản', ${currentYear - 1}, 'Phòng Xét nghiệm', 'Khu vực sinh hóa', 'KTV. Lê Văn C', 'Hoạt động', CURRENT_DATE - INTERVAL '8 months', CURRENT_DATE - INTERVAL '7 months', 'Ngân sách nhà nước', 2200000000, CURRENT_DATE + INTERVAL '1 year', 'Throughput 5400 test/giờ, ISE tích hợp', 'Reagent cartridge, cuvette', 'Hoạt động ổn định', 3, CURRENT_DATE + INTERVAL '2 months'),

-- Thiết bị Cấp cứu
('${customerCode}_007', 'Máy thở', 'Servo-i', 'SI2021007', 'Maquet', 'Thụy Điển', ${currentYear - 3}, 'Khoa Cấp cứu', 'Phòng hồi sức', 'BS. Phạm Văn D', 'Hoạt động', CURRENT_DATE - INTERVAL '3 years', CURRENT_DATE - INTERVAL '35 months', 'Ngân sách nhà nước', 800000000, CURRENT_DATE - INTERVAL '1 year', 'Màn hình cảm ứng 15 inch, NAVA mode', 'Circuit thở, humidifier', 'Cần bảo trì gấp', 3, CURRENT_DATE + INTERVAL '1 month'),
('${customerCode}_008', 'Máy monitor đa thông số', 'IntelliVue MX800', 'MX800008', 'Philips', 'Hà Lan', ${currentYear - 1}, 'Khoa Cấp cứu', 'Phòng theo dõi', 'BS. Phạm Văn D', 'Hoạt động', CURRENT_DATE - INTERVAL '1 year', CURRENT_DATE - INTERVAL '11 months', 'Ngân sách nhà nước', 150000000, CURRENT_DATE + INTERVAL '1 year', 'Màn hình 19 inch, 8 sóng hiển thị', 'Cáp kết nối, sensor SpO2', 'Thiết bị ổn định', 6, CURRENT_DATE + INTERVAL '3 months'),

-- Thiết bị Phẫu thuật
('${customerCode}_009', 'Máy gây mê', 'Aisys CS2', 'ACS2009', 'GE Healthcare', 'Mỹ', ${currentYear - 2}, 'Phòng Phẫu thuật', 'Phòng mổ 1', 'BS. Hoàng Thị E', 'Hoạt động', CURRENT_DATE - INTERVAL '2 years', CURRENT_DATE - INTERVAL '23 months', 'Vốn ODA', 1200000000, CURRENT_DATE + INTERVAL '6 months', 'Ventilator tích hợp, vaporizer Sevoflurane', 'Circuit gây mê, mask thở', 'Thiết bị quan trọng', 6, CURRENT_DATE + INTERVAL '2 months'),
('${customerCode}_010', 'Đèn mổ LED', 'Lucea 300', 'LC300010', 'Trumpf', 'Đức', ${currentYear}, 'Phòng Phẫu thuật', 'Phòng mổ 1', 'BS. Hoàng Thị E', 'Hoạt động', CURRENT_DATE - INTERVAL '4 months', CURRENT_DATE - INTERVAL '3 months', 'Ngân sách nhà nước', 450000000, CURRENT_DATE + INTERVAL '2 years', 'LED 160.000 lux, điều khiển cảm ứng', 'Tay điều khiển vô trùng, camera HD', 'Thiết bị hiện đại', 12, CURRENT_DATE + INTERVAL '6 months')

ON CONFLICT (ma_thiet_bi) DO NOTHING;

-- 5. Tạo kế hoạch bảo trì mẫu
INSERT INTO ke_hoach_bao_tri (
  thiet_bi_id, loai_bao_tri, mo_ta, ngay_bat_dau, ngay_ket_thuc,
  chu_ky_lap_lai, trang_thai, nguoi_phu_trach_id
) VALUES
-- Bảo trì thiết bị CĐHA
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_003'), 'Hiệu chuẩn', 'Hiệu chuẩn máy X-quang định kỳ', CURRENT_DATE + INTERVAL '1 month', CURRENT_DATE + INTERVAL '1 month', 12, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_cdha')),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_004'), 'Bảo trì định kỳ', 'Bảo trì máy CT định kỳ', CURRENT_DATE + INTERVAL '2 months', CURRENT_DATE + INTERVAL '2 months', 6, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_cdha')),

-- Bảo trì thiết bị xét nghiệm
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_005'), 'Bảo trì định kỳ', 'Bảo trì máy xét nghiệm máu', CURRENT_DATE + INTERVAL '15 days', CURRENT_DATE + INTERVAL '15 days', 3, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_xn')),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_006'), 'Hiệu chuẩn', 'Hiệu chuẩn máy sinh hóa', CURRENT_DATE + INTERVAL '1 month', CURRENT_DATE + INTERVAL '1 month', 6, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_xn')),

-- Bảo trì thiết bị cấp cứu
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_007'), 'Bảo trì định kỳ', 'Bảo trì máy thở định kỳ', CURRENT_DATE + INTERVAL '10 days', CURRENT_DATE + INTERVAL '10 days', 3, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_cc')),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_008'), 'Bảo trì định kỳ', 'Bảo trì monitor đa thông số', CURRENT_DATE + INTERVAL '20 days', CURRENT_DATE + INTERVAL '20 days', 6, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_cc'))

ON CONFLICT DO NOTHING;

-- 6. Tạo một số công việc bảo trì mẫu
INSERT INTO cong_viec_bao_tri (
  ke_hoach_id, thiet_bi_id, ten_cong_viec, mo_ta,
  ngay_thuc_hien_du_kien, trang_thai, nguoi_thuc_hien_id,
  thang_1_hoan_thanh, thang_2_hoan_thanh, thang_3_hoan_thanh
) VALUES
((SELECT id FROM ke_hoach_bao_tri WHERE thiet_bi_id = (SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_005') LIMIT 1),
 (SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_005'),
 'Kiểm tra và vệ sinh máy xét nghiệm máu',
 'Vệ sinh bên ngoài, kiểm tra các bộ phận chính',
 CURRENT_DATE + INTERVAL '15 days',
 'chua_thuc_hien',
 (SELECT id FROM nhan_vien WHERE username = 'qltb_xn'),
 true, false, false),

((SELECT id FROM ke_hoach_bao_tri WHERE thiet_bi_id = (SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_007') LIMIT 1),
 (SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_007'),
 'Kiểm tra hệ thống máy thở',
 'Kiểm tra áp suất, lưu lượng, cảm biến',
 CURRENT_DATE + INTERVAL '10 days',
 'chua_thuc_hien',
 (SELECT id FROM nhan_vien WHERE username = 'qltb_cc'),
 true, true, false)

ON CONFLICT DO NOTHING;

-- 7. Tạo một số lịch sử thiết bị mẫu
INSERT INTO lich_su_thiet_bi (
  thiet_bi_id, ngay_thuc_hien, loai_su_kien, mo_ta, chi_tiet
) VALUES
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_001'), CURRENT_DATE - INTERVAL '1 year', 'Nhập kho', 'Nhập thiết bị mới', 'Máy siêu âm tim Vivid E95 được nhập kho và kiểm tra ban đầu'),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_001'), CURRENT_DATE - INTERVAL '11 months', 'Đưa vào sử dụng', 'Bắt đầu sử dụng', 'Máy siêu âm được đưa vào sử dụng tại Khoa Nội'),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_003'), CURRENT_DATE - INTERVAL '2 years', 'Nhập kho', 'Nhập thiết bị mới', 'Máy X-quang kỹ thuật số được nhập kho'),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_003'), CURRENT_DATE - INTERVAL '23 months', 'Đưa vào sử dụng', 'Bắt đầu sử dụng', 'Máy X-quang được lắp đặt và đưa vào sử dụng'),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_005'), CURRENT_DATE - INTERVAL '3 months', 'Nhập kho', 'Nhập thiết bị mới', 'Máy xét nghiệm máu tự động được nhập kho'),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_005'), CURRENT_DATE - INTERVAL '2 months', 'Đưa vào sử dụng', 'Bắt đầu sử dụng', 'Máy xét nghiệm được đưa vào sử dụng tại Phòng XN')

ON CONFLICT DO NOTHING;

-- 8. Cập nhật thống kê để tối ưu hiệu suất
ANALYZE phong_ban;
ANALYZE loai_thiet_bi;
ANALYZE nhan_vien;
ANALYZE thiet_bi;
ANALYZE ke_hoach_bao_tri;
ANALYZE cong_viec_bao_tri;
ANALYZE lich_su_thiet_bi;

-- 9. Thông báo hoàn thành
SELECT
  'Dữ liệu mẫu đã được tạo thành công cho ${customerName}!' as status,
  COUNT(DISTINCT pb.id) as so_phong_ban,
  COUNT(DISTINCT ltb.id) as so_loai_thiet_bi,
  COUNT(DISTINCT nv.id) as so_nhan_vien,
  COUNT(DISTINCT tb.id) as so_thiet_bi,
  COUNT(DISTINCT khbt.id) as so_ke_hoach_bao_tri
FROM phong_ban pb, loai_thiet_bi ltb, nhan_vien nv, thiet_bi tb, ke_hoach_bao_tri khbt;
`;
}

// Generate setup instructions
function generateSetupInstructions(customerName, outputFile) {
  return `
-- =====================================================
-- HƯỚNG DẪN SETUP DATABASE CHO ${customerName}
-- =====================================================

/*
🚀 HƯỚNG DẪN SỬ DỤNG:

1. TẠO PROJECT SUPABASE MỚI:
   - Truy cập https://supabase.com/dashboard
   - Tạo project mới với tên "${customerName}"
   - Chờ project được khởi tạo hoàn tất

2. LẤY THÔNG TIN KẾT NỐI:
   - Vào Settings > Database
   - Copy Connection string (URI)
   - Vào Settings > API
   - Copy Project URL và anon public key

3. CHẠY SCRIPT SETUP:
   Cách 1 - Sử dụng Supabase Dashboard:
   - Vào SQL Editor trong dashboard
   - Copy toàn bộ nội dung file ${outputFile}
   - Paste vào SQL Editor và chạy

   Cách 2 - Sử dụng psql:
   psql "postgresql://postgres:[YOUR-PASSWORD]@[YOUR-HOST]:5432/postgres" -f ${outputFile}

   Cách 3 - Sử dụng Supabase CLI:
   supabase db reset --db-url "postgresql://postgres:[YOUR-PASSWORD]@[YOUR-HOST]:5432/postgres"

4. CẬP NHẬT .ENV.LOCAL:
   NEXT_PUBLIC_SUPABASE_URL=https://[your-project-ref].supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=[your-anon-key]
   SUPABASE_SERVICE_ROLE_KEY=[your-service-role-key]

5. KIỂM TRA KẾT NỐI:
   - Chạy ứng dụng: npm run dev
   - Đăng nhập với tài khoản: admin / admin123
   - Kiểm tra các chức năng cơ bản

📋 TÀI KHOẢN MẶC ĐỊNH:
   - admin / admin123 (Quản trị viên)
   - to_qltb / qltb123 (Trưởng tổ QLTB)
   - qltb_noi / qltb123 (QLTB Khoa Nội)
   - qltb_cdha / qltb123 (QLTB CĐHA)
   - user_demo / user123 (Nhân viên demo)

⚠️  LƯU Ý BẢO MẬT:
   - Đổi mật khẩu mặc định ngay sau khi setup
   - Không chia sẻ thông tin kết nối database
   - Backup database định kỳ

🎯 TÍNH NĂNG ĐÃ SETUP:
   ✅ Quản lý thiết bị y tế
   ✅ Lập kế hoạch bảo trì
   ✅ Theo dõi sửa chữa
   ✅ Luân chuyển thiết bị
   ✅ Báo cáo và thống kê
   ✅ Phân quyền người dùng
   ✅ Lịch sử hoạt động
   ✅ Tối ưu hiệu suất

📞 HỖ TRỢ:
   Nếu gặp vấn đề trong quá trình setup, vui lòng liên hệ team phát triển.
*/
`;
}

// Main function to package complete database schema
function packageDatabaseSchema() {
  const config = parseArgs();

  log(`${colors.blue}${colors.bright}📦 ĐÓNG GÓI DATABASE SCHEMA CHO SUPABASE MỚI${colors.reset}\n`);
  log(`${colors.blue}Khách hàng: ${config.customer}${colors.reset}`);
  log(`${colors.blue}File output: ${config.output}${colors.reset}\n`);

  try {
    // Step 1: Get migration files
    logStep(1, 'Đọc các file migration');
    const migrationFiles = getMigrationFiles();
    logSuccess(`Tìm thấy ${migrationFiles.length} file migration`);

    // Step 2: Build complete schema
    logStep(2, 'Tạo schema hoàn chỉnh');

    let completeSchema = `-- =====================================================
-- DATABASE SETUP HOÀN CHỈNH CHO ${config.customer}
-- Được tạo tự động từ tất cả migration files
-- Ngày tạo: ${new Date().toLocaleString('vi-VN')}
-- =====================================================

-- Bật các extension cần thiết
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Thiết lập timezone
SET timezone = 'Asia/Ho_Chi_Minh';

-- Thiết lập encoding
SET client_encoding = 'UTF8';

-- Bắt đầu transaction để đảm bảo tính toàn vẹn
BEGIN;

`;

    // Step 3: Process migration files
    logStep(3, 'Xử lý các file migration');
    let processedCount = 0;

    for (const file of migrationFiles) {
      log(`  📄 Xử lý: ${file.name}`);

      try {
        const processedContent = processSQLContent(file.content, file.name);
        completeSchema += processedContent + '\n';
        processedCount++;
      } catch (error) {
        logWarning(`Bỏ qua file ${file.name}: ${error.message}`);
      }
    }

    logSuccess(`Đã xử lý ${processedCount}/${migrationFiles.length} file migration`);

    // Step 4: Add sample data
    logStep(4, 'Tạo dữ liệu mẫu');
    const sampleData = generateSampleData(config.customer);
    completeSchema += sampleData;
    logSuccess('Đã tạo dữ liệu mẫu');

    // Step 5: Add final verification and commit
    completeSchema += `
-- =====================================================
-- HOÀN TẤT SETUP VÀ KIỂM TRA
-- =====================================================

-- Commit transaction
COMMIT;

-- Kiểm tra kết quả setup
SELECT
  'Setup database hoàn tất!' as status,
  COUNT(*) as total_tables
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE';

-- Hiển thị danh sách bảng đã tạo
SELECT
  table_name as "Tên bảng",
  CASE
    WHEN table_name LIKE '%thiet_bi%' THEN 'Quản lý thiết bị'
    WHEN table_name LIKE '%nhan_vien%' THEN 'Quản lý người dùng'
    WHEN table_name LIKE '%bao_tri%' THEN 'Bảo trì'
    WHEN table_name LIKE '%sua_chua%' THEN 'Sửa chữa'
    WHEN table_name LIKE '%luan_chuyen%' THEN 'Luân chuyển'
    WHEN table_name LIKE '%phong_ban%' THEN 'Phòng ban'
    WHEN table_name LIKE '%loai%' THEN 'Danh mục'
    ELSE 'Khác'
  END as "Nhóm chức năng"
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY "Nhóm chức năng", table_name;

-- Hiển thị thống kê dữ liệu mẫu
SELECT
  'Thống kê dữ liệu mẫu' as "Loại thống kê",
  (SELECT COUNT(*) FROM phong_ban) as "Phòng ban",
  (SELECT COUNT(*) FROM loai_thiet_bi) as "Loại thiết bị",
  (SELECT COUNT(*) FROM nhan_vien) as "Người dùng",
  (SELECT COUNT(*) FROM thiet_bi) as "Thiết bị",
  (SELECT COUNT(*) FROM ke_hoach_bao_tri) as "Kế hoạch BT";

-- Thông báo hoàn thành
SELECT '🎉 Database đã sẵn sàng sử dụng cho ${config.customer}!' as "Kết quả";
`;

    // Step 6: Add setup instructions
    const instructions = generateSetupInstructions(config.customer, config.output);
    completeSchema += instructions;

    // Step 7: Write output file
    logStep(5, 'Ghi file output');
    const outputPath = path.join(__dirname, '..', config.output);
    fs.writeFileSync(outputPath, completeSchema, 'utf8');

    logSuccess(`File đã được tạo: ${config.output}`);

    // Step 8: Show summary
    log(`\n${colors.green}${colors.bright}🎉 HOÀN TẤT ĐÓNG GÓI DATABASE SCHEMA${colors.reset}`);
    log(`\n📊 Thống kê:`);
    log(`  - File migration đã xử lý: ${processedCount}`);
    log(`  - Kích thước file: ${Math.round(completeSchema.length / 1024)} KB`);
    log(`  - Khách hàng: ${config.customer}`);
    log(`  - File output: ${config.output}`);

    log(`\n🚀 Bước tiếp theo:`);
    log(`  1. Tạo project Supabase mới`);
    log(`  2. Chạy file ${config.output} trong SQL Editor`);
    log(`  3. Cập nhật .env.local với thông tin Supabase mới`);
    log(`  4. Đăng nhập với tài khoản admin/admin123`);
    log(`  5. Đổi mật khẩu mặc định`);

  } catch (error) {
    logError(`Lỗi khi đóng gói schema: ${error.message}`);
    console.error(error);
    process.exit(1);
  }
}

// Run the packager
if (require.main === module) {
  packageDatabaseSchema();
}

module.exports = {
  packageDatabaseSchema,
  generateSampleData,
  generateSetupInstructions
};
