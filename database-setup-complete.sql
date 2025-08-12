-- =====================================================
-- DATABASE SETUP HOÀN CHỈNH CHO Bệnh viện ABC
-- Được tạo tự động từ tất cả migration files
-- Ngày tạo: 13:38:20 12/8/2025
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


-- =====================================================
-- 20241220_add_completion_tracking.sql
-- =====================================================
-- Add completion tracking columns to cong_viec_bao_tri table
-- These columns will track whether a scheduled maintenance task has been completed

ALTER TABLE cong_viec_bao_tri
ADD COLUMN thang_1_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN ngay_hoan_thanh_1 TIMESTAMPTZ,
ADD COLUMN thang_2_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN ngay_hoan_thanh_2 TIMESTAMPTZ,
ADD COLUMN thang_3_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN ngay_hoan_thanh_3 TIMESTAMPTZ,
ADD COLUMN thang_4_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN ngay_hoan_thanh_4 TIMESTAMPTZ,
ADD COLUMN thang_5_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN ngay_hoan_thanh_5 TIMESTAMPTZ,
ADD COLUMN thang_6_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN ngay_hoan_thanh_6 TIMESTAMPTZ,
ADD COLUMN thang_7_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN ngay_hoan_thanh_7 TIMESTAMPTZ,
ADD COLUMN thang_8_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN ngay_hoan_thanh_8 TIMESTAMPTZ,
ADD COLUMN thang_9_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN ngay_hoan_thanh_9 TIMESTAMPTZ,
ADD COLUMN thang_10_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN ngay_hoan_thanh_10 TIMESTAMPTZ,
ADD COLUMN thang_11_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN ngay_hoan_thanh_11 TIMESTAMPTZ,
ADD COLUMN thang_12_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN ngay_hoan_thanh_12 TIMESTAMPTZ;

-- Add comments to describe the new columns
COMMENT ON COLUMN cong_viec_bao_tri.thang_1_hoan_thanh IS 'Đánh dấu công việc tháng 1 đã hoàn thành';
COMMENT ON COLUMN cong_viec_bao_tri.ngay_hoan_thanh_1 IS 'Ngày hoàn thành thực tế công việc tháng 1';

COMMENT ON COLUMN cong_viec_bao_tri.thang_2_hoan_thanh IS 'Đánh dấu công việc tháng 2 đã hoàn thành';
COMMENT ON COLUMN cong_viec_bao_tri.ngay_hoan_thanh_2 IS 'Ngày hoàn thành thực tế công việc tháng 2';

COMMENT ON COLUMN cong_viec_bao_tri.thang_3_hoan_thanh IS 'Đánh dấu công việc tháng 3 đã hoàn thành';
COMMENT ON COLUMN cong_viec_bao_tri.ngay_hoan_thanh_3 IS 'Ngày hoàn thành thực tế công việc tháng 3';

COMMENT ON COLUMN cong_viec_bao_tri.thang_4_hoan_thanh IS 'Đánh dấu công việc tháng 4 đã hoàn thành';
COMMENT ON COLUMN cong_viec_bao_tri.ngay_hoan_thanh_4 IS 'Ngày hoàn thành thực tế công việc tháng 4';

COMMENT ON COLUMN cong_viec_bao_tri.thang_5_hoan_thanh IS 'Đánh dấu công việc tháng 5 đã hoàn thành';
COMMENT ON COLUMN cong_viec_bao_tri.ngay_hoan_thanh_5 IS 'Ngày hoàn thành thực tế công việc tháng 5';

COMMENT ON COLUMN cong_viec_bao_tri.thang_6_hoan_thanh IS 'Đánh dấu công việc tháng 6 đã hoàn thành';
COMMENT ON COLUMN cong_viec_bao_tri.ngay_hoan_thanh_6 IS 'Ngày hoàn thành thực tế công việc tháng 6';

COMMENT ON COLUMN cong_viec_bao_tri.thang_7_hoan_thanh IS 'Đánh dấu công việc tháng 7 đã hoàn thành';
COMMENT ON COLUMN cong_viec_bao_tri.ngay_hoan_thanh_7 IS 'Ngày hoàn thành thực tế công việc tháng 7';

COMMENT ON COLUMN cong_viec_bao_tri.thang_8_hoan_thanh IS 'Đánh dấu công việc tháng 8 đã hoàn thành';
COMMENT ON COLUMN cong_viec_bao_tri.ngay_hoan_thanh_8 IS 'Ngày hoàn thành thực tế công việc tháng 8';

COMMENT ON COLUMN cong_viec_bao_tri.thang_9_hoan_thanh IS 'Đánh dấu công việc tháng 9 đã hoàn thành';
COMMENT ON COLUMN cong_viec_bao_tri.ngay_hoan_thanh_9 IS 'Ngày hoàn thành thực tế công việc tháng 9';

COMMENT ON COLUMN cong_viec_bao_tri.thang_10_hoan_thanh IS 'Đánh dấu công việc tháng 10 đã hoàn thành';
COMMENT ON COLUMN cong_viec_bao_tri.ngay_hoan_thanh_10 IS 'Ngày hoàn thành thực tế công việc tháng 10';

COMMENT ON COLUMN cong_viec_bao_tri.thang_11_hoan_thanh IS 'Đánh dấu công việc tháng 11 đã hoàn thành';
COMMENT ON COLUMN cong_viec_bao_tri.ngay_hoan_thanh_11 IS 'Ngày hoàn thành thực tế công việc tháng 11';

COMMENT ON COLUMN cong_viec_bao_tri.thang_12_hoan_thanh IS 'Đánh dấu công việc tháng 12 đã hoàn thành';
COMMENT ON COLUMN cong_viec_bao_tri.ngay_hoan_thanh_12 IS 'Ngày hoàn thành thực tế công việc tháng 12';


-- =====================================================
-- 20241220_create_luan_chuyen_tables.sql
-- =====================================================
-- Migration for Luân chuyển (Equipment Transfer/Circulation) system
-- This creates tables for managing equipment transfers between departments and external organizations

-- Create yeu_cau_luan_chuyen table for transfer requests
CREATE TABLE IF NOT EXISTS yeu_cau_luan_chuyen (
    id SERIAL PRIMARY KEY,
    ma_yeu_cau VARCHAR(50) UNIQUE NOT NULL, -- Auto-generated request ID like LC-2024-001
    thiet_bi_id INTEGER NOT NULL REFERENCES thiet_bi(id) ON DELETE CASCADE,
    loai_hinh VARCHAR(20) NOT NULL CHECK (loai_hinh IN ('noi_bo', 'ben_ngoai')), -- noi_bo (internal) or ben_ngoai (external)
    trang_thai VARCHAR(20) NOT NULL DEFAULT 'cho_duyet' CHECK (trang_thai IN ('cho_duyet', 'da_duyet', 'dang_luan_chuyen', 'hoan_thanh')),
    
    -- Request details
    nguoi_yeu_cau_id INTEGER REFERENCES nhan_vien(id),
    ly_do_luan_chuyen TEXT NOT NULL,
    
    -- For internal transfers (noi_bo)
    khoa_phong_hien_tai VARCHAR(100), -- Current department
    khoa_phong_nhan VARCHAR(100), -- Receiving department
    
    -- For external transfers (ben_ngoai)
    muc_dich VARCHAR(50) CHECK (muc_dich IN ('sua_chua', 'cho_muon', 'thanh_ly', 'khac')), -- repair, loan, disposal, other
    don_vi_nhan VARCHAR(200), -- External organization name
    dia_chi_don_vi TEXT, -- External organization address
    nguoi_lien_he VARCHAR(100), -- Contact person
    so_dien_thoai VARCHAR(20), -- Contact phone
    
    -- Timeline fields
    ngay_du_kien_tra DATE, -- Expected return date (for external only)
    ngay_ban_giao TIMESTAMPTZ, -- Handover date
    ngay_hoan_tra TIMESTAMPTZ, -- Return date (for external)
    ngay_hoan_thanh TIMESTAMPTZ, -- Completion date
    
    -- Approval tracking
    nguoi_duyet_id INTEGER REFERENCES nhan_vien(id),
    ngay_duyet TIMESTAMPTZ,
    ghi_chu_duyet TEXT,
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_by INTEGER REFERENCES nhan_vien(id),
    updated_by INTEGER REFERENCES nhan_vien(id)
);

-- Create lich_su_luan_chuyen table for tracking all state changes
CREATE TABLE IF NOT EXISTS lich_su_luan_chuyen (
    id SERIAL PRIMARY KEY,
    yeu_cau_id INTEGER NOT NULL REFERENCES yeu_cau_luan_chuyen(id) ON DELETE CASCADE,
    trang_thai_cu VARCHAR(20),
    trang_thai_moi VARCHAR(20) NOT NULL,
    hanh_dong VARCHAR(50) NOT NULL, -- create, approve, handover, return, complete, edit
    mo_ta TEXT,
    nguoi_thuc_hien_id INTEGER REFERENCES nhan_vien(id),
    thoi_gian TIMESTAMPTZ DEFAULT NOW()
);

-- Add comments for documentation
COMMENT ON TABLE yeu_cau_luan_chuyen IS 'Bảng quản lý yêu cầu luân chuyển thiết bị';
COMMENT ON COLUMN yeu_cau_luan_chuyen.loai_hinh IS 'Loại hình: noi_bo (nội bộ), ben_ngoai (bên ngoài)';
COMMENT ON COLUMN yeu_cau_luan_chuyen.trang_thai IS 'Trạng thái: cho_duyet, da_duyet, dang_luan_chuyen, hoan_thanh';
COMMENT ON COLUMN yeu_cau_luan_chuyen.muc_dich IS 'Mục đích (chỉ cho bên ngoài): sua_chua, cho_muon, thanh_ly, khac';

-- Create indexes for better performance
CREATE INDEX idx_yeu_cau_luan_chuyen_trang_thai ON yeu_cau_luan_chuyen(trang_thai);
CREATE INDEX idx_yeu_cau_luan_chuyen_loai_hinh ON yeu_cau_luan_chuyen(loai_hinh);
CREATE INDEX idx_yeu_cau_luan_chuyen_thiet_bi ON yeu_cau_luan_chuyen(thiet_bi_id);
CREATE INDEX idx_yeu_cau_luan_chuyen_created_at ON yeu_cau_luan_chuyen(created_at);
CREATE INDEX idx_lich_su_luan_chuyen_yeu_cau ON lich_su_luan_chuyen(yeu_cau_id);

-- Function to auto-generate request codes
CREATE OR REPLACE FUNCTION generate_ma_yeu_cau_luan_chuyen()
RETURNS TRIGGER AS $$
DECLARE
    current_year INTEGER := EXTRACT(YEAR FROM NOW());
    max_number INTEGER;
    new_code VARCHAR(50);
BEGIN
    -- Get the highest number for current year
    SELECT COALESCE(MAX(CAST(SUBSTRING(ma_yeu_cau FROM 'LC-' || current_year || '-(\d+)') AS INTEGER)), 0)
    INTO max_number
    FROM yeu_cau_luan_chuyen
    WHERE ma_yeu_cau LIKE 'LC-' || current_year || '-%';
    
    -- Generate new code
    new_code := 'LC-' || current_year || '-' || LPAD((max_number + 1)::TEXT, 3, '0');
    NEW.ma_yeu_cau := new_code;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for auto-generating request codes
CREATE TRIGGER trigger_generate_ma_yeu_cau_luan_chuyen
    BEFORE INSERT ON yeu_cau_luan_chuyen
    FOR EACH ROW
    WHEN (NEW.ma_yeu_cau IS NULL OR NEW.ma_yeu_cau = '')
    EXECUTE FUNCTION generate_ma_yeu_cau_luan_chuyen();

-- Function to auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for auto-updating updated_at
CREATE TRIGGER trigger_update_yeu_cau_luan_chuyen_updated_at
    BEFORE UPDATE ON yeu_cau_luan_chuyen
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Function to automatically log history when status changes
CREATE OR REPLACE FUNCTION log_luan_chuyen_history()
RETURNS TRIGGER AS $$
BEGIN
    -- Only log if status actually changed
    IF (TG_OP = 'INSERT') OR (OLD.trang_thai IS DISTINCT FROM NEW.trang_thai) THEN
        INSERT INTO lich_su_luan_chuyen (
            yeu_cau_id,
            trang_thai_cu,
            trang_thai_moi,
            hanh_dong,
            mo_ta,
            nguoi_thuc_hien_id
        ) VALUES (
            NEW.id,
            CASE WHEN TG_OP = 'INSERT' THEN NULL ELSE OLD.trang_thai END,
            NEW.trang_thai,
            CASE 
                WHEN TG_OP = 'INSERT' THEN 'create'
                WHEN NEW.trang_thai = 'da_duyet' THEN 'approve'
                WHEN NEW.trang_thai = 'dang_luan_chuyen' THEN 'handover'
                WHEN NEW.trang_thai = 'hoan_thanh' THEN 'complete'
                ELSE 'edit'
            END,
            CASE 
                WHEN TG_OP = 'INSERT' THEN 'Tạo yêu cầu luân chuyển mới'
                WHEN NEW.trang_thai = 'da_duyet' THEN 'Phê duyệt yêu cầu'
                WHEN NEW.trang_thai = 'dang_luan_chuyen' THEN 'Bàn giao thiết bị'
                WHEN NEW.trang_thai = 'hoan_thanh' THEN 'Hoàn thành luân chuyển'
                ELSE 'Chỉnh sửa thông tin yêu cầu'
            END,
            NEW.updated_by
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for auto-logging history
CREATE TRIGGER trigger_log_luan_chuyen_history
    AFTER INSERT OR UPDATE ON yeu_cau_luan_chuyen
    FOR EACH ROW
    EXECUTE FUNCTION log_luan_chuyen_history();


-- =====================================================
-- 20241220_create_nhan_vien_table.sql
-- =====================================================
-- Create nhan_vien table for user management
-- This table stores user accounts with basic authentication (username/password)

CREATE TABLE IF NOT EXISTS nhan_vien (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password TEXT NOT NULL, -- Plain text password as requested
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'to_qltb', 'qltb_khoa', 'user')),
    khoa_phong VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add comments to describe the table and columns
COMMENT ON TABLE nhan_vien IS 'Bảng quản lý tài khoản nhân viên';
COMMENT ON COLUMN nhan_vien.username IS 'Tên đăng nhập (duy nhất)';
COMMENT ON COLUMN nhan_vien.password IS 'Mật khẩu (plain text)';
COMMENT ON COLUMN nhan_vien.full_name IS 'Họ và tên đầy đủ';
COMMENT ON COLUMN nhan_vien.role IS 'Vai trò: admin (Quản trị hệ thống), to_qltb (Tổ QLTB CDC), qltb_khoa (QLTB Khoa/Phòng), user (Nhân viên)';
COMMENT ON COLUMN nhan_vien.khoa_phong IS 'Khoa/Phòng làm việc';

-- Create index for faster username lookup
CREATE INDEX idx_nhan_vien_username ON nhan_vien(username);
CREATE INDEX idx_nhan_vien_role ON nhan_vien(role);

-- Insert default admin account
INSERT INTO nhan_vien (username, password, full_name, role, khoa_phong) 
VALUES ('admin', 'admin123', 'Quản trị viên hệ thống', 'admin', 'Ban Giám đốc')
ON CONFLICT (username) DO NOTHING;


-- =====================================================
-- 20241221_add_da_ban_giao_status.sql
-- =====================================================
-- Migration to add da_ban_giao status for external transfers
-- This allows better tracking of handover vs return for external equipment transfers

-- Add new status to the CHECK constraint
ALTER TABLE yeu_cau_luan_chuyen 
DROP CONSTRAINT IF EXISTS yeu_cau_luan_chuyen_trang_thai_check;

ALTER TABLE yeu_cau_luan_chuyen 
ADD CONSTRAINT yeu_cau_luan_chuyen_trang_thai_check 
CHECK (trang_thai IN ('cho_duyet', 'da_duyet', 'dang_luan_chuyen', 'da_ban_giao', 'hoan_thanh'));

-- Update the history logging function to handle the new status
CREATE OR REPLACE FUNCTION log_luan_chuyen_history()
RETURNS TRIGGER AS $$
BEGIN
    -- Only log if status actually changed
    IF (TG_OP = 'INSERT') OR (OLD.trang_thai IS DISTINCT FROM NEW.trang_thai) THEN
        INSERT INTO lich_su_luan_chuyen (
            yeu_cau_id,
            trang_thai_cu,
            trang_thai_moi,
            hanh_dong,
            mo_ta,
            nguoi_thuc_hien_id
        ) VALUES (
            NEW.id,
            CASE WHEN TG_OP = 'INSERT' THEN NULL ELSE OLD.trang_thai END,
            NEW.trang_thai,
            CASE 
                WHEN TG_OP = 'INSERT' THEN 'create'
                WHEN NEW.trang_thai = 'da_duyet' THEN 'approve'
                WHEN NEW.trang_thai = 'dang_luan_chuyen' THEN 'handover'
                WHEN NEW.trang_thai = 'da_ban_giao' THEN 'delivered'
                WHEN NEW.trang_thai = 'hoan_thanh' THEN 'complete'
                ELSE 'edit'
            END,
            CASE 
                WHEN TG_OP = 'INSERT' THEN 'Tạo yêu cầu luân chuyển mới'
                WHEN NEW.trang_thai = 'da_duyet' THEN 'Phê duyệt yêu cầu'
                WHEN NEW.trang_thai = 'dang_luan_chuyen' THEN 'Bàn giao thiết bị'
                WHEN NEW.trang_thai = 'da_ban_giao' THEN 'Đã bàn giao thiết bị cho đơn vị bên ngoài'
                WHEN NEW.trang_thai = 'hoan_thanh' THEN 'Hoàn thành luân chuyển (đã hoàn trả)'
                ELSE 'Chỉnh sửa thông tin yêu cầu'
            END,
            NEW.updated_by
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add comment about the new status
COMMENT ON COLUMN yeu_cau_luan_chuyen.trang_thai IS 'Trạng thái: cho_duyet, da_duyet, dang_luan_chuyen, da_ban_giao (chỉ cho bên ngoài), hoan_thanh';


-- =====================================================
-- 20241221_secure_user_update_function.sql
-- =====================================================
-- SECURE USER FUNCTIONS WITH PASSWORD HASHING

-- Functions to securely create and update users with password hashing

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Add hashed password column if it doesn't exist
ALTER TABLE nhan_vien ADD COLUMN IF NOT EXISTS hashed_password TEXT;

-- Simple username validation function (no restrictions)
CREATE OR REPLACE FUNCTION validate_username(username TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
  -- Only check that username is not empty and doesn't contain spaces
  RETURN username IS NOT NULL
    AND length(trim(username)) > 0
    AND username !~ '\s';
END;
$$;

-- Function to create new user with hashed password
CREATE OR REPLACE FUNCTION create_user(
  p_username TEXT,
  p_password TEXT,
  p_full_name TEXT,
  p_role TEXT,
  p_khoa_phong TEXT DEFAULT NULL
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  new_user_id INTEGER;
BEGIN
  -- Validate inputs
  IF NOT validate_username(p_username) THEN
    RAISE EXCEPTION 'Invalid username format';
  END IF;

  -- No password validation - allow any password

  -- Insert new user with hashed password
  INSERT INTO nhan_vien (username, password, hashed_password, full_name, role, khoa_phong)
  VALUES (p_username, 'hashed password', crypt(p_password, gen_salt('bf', 12)), p_full_name, p_role, p_khoa_phong)
  RETURNING id INTO new_user_id;

  RETURN new_user_id;
END;
$$;

-- Function to update user information (admin only)
CREATE OR REPLACE FUNCTION update_user_info(
  p_admin_user_id INTEGER,
  p_target_user_id INTEGER,
  p_username TEXT,
  p_password TEXT,
  p_full_name TEXT,
  p_role TEXT,
  p_khoa_phong TEXT DEFAULT NULL
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  admin_role TEXT;
  current_username TEXT;
BEGIN
  -- Verify admin permissions
  SELECT role INTO admin_role
  FROM nhan_vien
  WHERE id = p_admin_user_id;
  
  IF admin_role != 'admin' THEN
    RAISE EXCEPTION 'Access denied: Admin privileges required';
  END IF;
  
  -- Validate inputs
  IF NOT validate_username(p_username) THEN
    RAISE EXCEPTION 'Invalid username format';
  END IF;
  
  -- Check if target user exists
  SELECT username INTO current_username
  FROM nhan_vien
  WHERE id = p_target_user_id;
  
  IF current_username IS NULL THEN
    RAISE EXCEPTION 'User not found with ID: %', p_target_user_id;
  END IF;
  
  -- Update user information with hashed password
  UPDATE nhan_vien
  SET username = p_username,
      hashed_password = crypt(p_password, gen_salt('bf', 12)),
      password = 'hashed password', -- Set placeholder text
      full_name = p_full_name,
      role = p_role,
      khoa_phong = p_khoa_phong
  WHERE id = p_target_user_id;
  
  -- Invalidate all existing sessions for this user if password changed
  UPDATE user_sessions
  SET is_active = FALSE
  WHERE user_id = p_target_user_id;
  
  -- Log the action
  INSERT INTO audit_log (
    user_id, action, resource_type, resource_id, 
    new_values, ip_address
  ) VALUES (
    p_admin_user_id, 'USER_UPDATE', 'nhan_vien', p_target_user_id,
    jsonb_build_object(
      'username', p_username, 
      'full_name', p_full_name, 
      'role', p_role, 
      'khoa_phong', p_khoa_phong,
      'password_updated', true
    ),
    inet_client_addr()
  );
  
  RETURN TRUE;
END;
$$;

-- Function to change password
CREATE OR REPLACE FUNCTION change_password(
  p_user_id INTEGER,
  p_old_password TEXT,
  p_new_password TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  current_hash TEXT;
  current_plain TEXT;
BEGIN
  -- Get current password info
  SELECT hashed_password, password INTO current_hash, current_plain
  FROM nhan_vien
  WHERE id = p_user_id;

  -- Verify old password (try hashed first, then plain text for backward compatibility)
  IF current_hash IS NOT NULL AND current_hash = crypt(p_old_password, current_hash) THEN
    -- Hashed password verification successful
  ELSIF current_plain IS NOT NULL AND current_plain = p_old_password THEN
    -- Plain text password verification successful (backward compatibility)
  ELSE
    RETURN FALSE; -- Invalid old password
  END IF;

  -- Update password with hash
  UPDATE nhan_vien
  SET hashed_password = crypt(p_new_password, gen_salt('bf', 12)),
      password = 'hashed password'
  WHERE id = p_user_id;

  RETURN TRUE;
END;
$$;

-- DUAL MODE AUTHENTICATION FUNCTION

-- Enhanced authentication function supporting both hashed and legacy passwords

CREATE OR REPLACE FUNCTION authenticate_user_dual_mode(
  p_username TEXT,
  p_password TEXT
)
RETURNS TABLE(
  user_id INTEGER,
  username TEXT,
  full_name TEXT,
  role TEXT,
  khoa_phong TEXT,
  is_authenticated BOOLEAN,
  authentication_mode TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_record RECORD;
  password_valid BOOLEAN := FALSE;
  auth_mode TEXT := 'unknown';
BEGIN
  -- Find user by username
  SELECT id, nv.username, nv.full_name, nv.role, nv.khoa_phong, nv.password, nv.hashed_password
  INTO user_record
  FROM nhan_vien nv
  WHERE nv.username = p_username;

  -- Check if user exists
  IF user_record.id IS NULL THEN
    RETURN QUERY SELECT
      NULL::INTEGER,
      p_username::TEXT,
      NULL::TEXT,
      NULL::TEXT,
      NULL::TEXT,
      FALSE,
      'user_not_found'::TEXT;
    RETURN;
  END IF;

  -- 🚨 SECURITY: Block suspicious password attempts
  IF p_password = 'hashed password' OR
     p_password ILIKE '%hash%' OR
     p_password ILIKE '%crypt%' OR
     LENGTH(p_password) > 200 THEN
    RETURN QUERY SELECT
      user_record.id,
      user_record.username::TEXT,
      user_record.full_name::TEXT,
      user_record.role::TEXT,
      user_record.khoa_phong::TEXT,
      FALSE,
      'blocked_suspicious'::TEXT;
    RETURN;
  END IF;

  -- Try hashed password authentication first (preferred method)
  IF user_record.hashed_password IS NOT NULL AND user_record.hashed_password != '' THEN
    password_valid := (user_record.hashed_password = crypt(p_password, user_record.hashed_password));
    IF password_valid THEN
      auth_mode := 'hashed';
    END IF;
  END IF;

  -- Fallback to plain text password (legacy compatibility)
  IF NOT password_valid AND user_record.password IS NOT NULL AND user_record.password != 'hashed password' THEN
    password_valid := (user_record.password = p_password);
    IF password_valid THEN
      auth_mode := 'plain';
    END IF;
  END IF;

  -- Return authentication result
  RETURN QUERY SELECT
    user_record.id,
    user_record.username::TEXT,
    user_record.full_name::TEXT,
    user_record.role::TEXT,
    user_record.khoa_phong::TEXT,
    password_valid,
    auth_mode::TEXT;
END;
$$;

-- Grant permissions for the new functions
GRANT EXECUTE ON FUNCTION validate_username(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION create_user(TEXT, TEXT, TEXT, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION update_user_info(INTEGER, INTEGER, TEXT, TEXT, TEXT, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION change_password(INTEGER, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION authenticate_user_dual_mode(TEXT, TEXT) TO anon;

-- Add comments
COMMENT ON FUNCTION validate_username(TEXT) IS 'Simple username validation (no spaces, not empty)';
COMMENT ON FUNCTION create_user(TEXT, TEXT, TEXT, TEXT, TEXT) IS 'Create new user with bcrypt hashed password';
COMMENT ON FUNCTION update_user_info(INTEGER, INTEGER, TEXT, TEXT, TEXT, TEXT, TEXT) IS 'Securely update user information with password hashing (admin only)';
COMMENT ON FUNCTION change_password(INTEGER, TEXT, TEXT) IS 'Change user password with verification and hashing';
COMMENT ON FUNCTION authenticate_user_dual_mode(TEXT, TEXT) IS 'Dual mode authentication supporting both hashed and legacy passwords with security checks';


-- =====================================================
-- 20241222_add_completion_tracking.sql
-- =====================================================
-- Add completion tracking columns to cong_viec_bao_tri table
ALTER TABLE cong_viec_bao_tri 
ADD COLUMN IF NOT EXISTS thang_1_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS thang_2_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS thang_3_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS thang_4_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS thang_5_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS thang_6_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS thang_7_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS thang_8_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS thang_9_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS thang_10_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS thang_11_hoan_thanh BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS thang_12_hoan_thanh BOOLEAN DEFAULT FALSE;

-- Add completion date tracking columns
ALTER TABLE cong_viec_bao_tri 
ADD COLUMN IF NOT EXISTS ngay_hoan_thanh_1 TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ngay_hoan_thanh_2 TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ngay_hoan_thanh_3 TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ngay_hoan_thanh_4 TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ngay_hoan_thanh_5 TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ngay_hoan_thanh_6 TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ngay_hoan_thanh_7 TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ngay_hoan_thanh_8 TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ngay_hoan_thanh_9 TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ngay_hoan_thanh_10 TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ngay_hoan_thanh_11 TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS ngay_hoan_thanh_12 TIMESTAMPTZ;

-- Add updated_at column if not exists
ALTER TABLE cong_viec_bao_tri 
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

-- Create trigger to automatically update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_cong_viec_bao_tri_updated_at ON cong_viec_bao_tri;
CREATE TRIGGER update_cong_viec_bao_tri_updated_at
    BEFORE UPDATE ON cong_viec_bao_tri
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();


-- =====================================================
-- 20241225_password_migration_backup.sql
-- =====================================================
-- PASSWORD MIGRATION BACKUP & PREPARATION

-- Create backup table and prepare for password migration

-- Create backup table để preserve original data
CREATE TABLE IF NOT EXISTS nhan_vien_backup_pre_hash AS 
SELECT * FROM nhan_vien;

-- Add migration tracking
ALTER TABLE nhan_vien_backup_pre_hash 
ADD COLUMN backup_created_at TIMESTAMPTZ DEFAULT NOW();

-- Create migration log table
CREATE TABLE IF NOT EXISTS password_migration_log (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    username VARCHAR(50),
    migration_status VARCHAR(20) CHECK (migration_status IN ('pending', 'success', 'failed', 'rollback')),
    original_password_hash TEXT, -- For verification during rollback
    migration_timestamp TIMESTAMPTZ DEFAULT NOW(),
    error_message TEXT
);

-- Function to verify current database state
CREATE OR REPLACE FUNCTION verify_migration_prerequisites()
RETURNS TABLE(
    check_name TEXT,
    status TEXT,
    details TEXT
) 
LANGUAGE plpgsql
AS $$
BEGIN
    -- Check if pgcrypto extension exists
    RETURN QUERY SELECT 
        'pgcrypto_extension'::TEXT,
        CASE WHEN EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pgcrypto') 
             THEN 'OK' ELSE 'MISSING' END::TEXT,
        'Required for password hashing'::TEXT;
    
    -- Check if hashed_password column exists
    RETURN QUERY SELECT 
        'hashed_password_column'::TEXT,
        CASE WHEN EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'nhan_vien' AND column_name = 'hashed_password'
        ) THEN 'OK' ELSE 'MISSING' END::TEXT,
        'Column for storing hashed passwords'::TEXT;
        
    -- Check current user count
    RETURN QUERY SELECT 
        'user_count'::TEXT,
        'INFO'::TEXT,
        ('Total users: ' || (SELECT COUNT(*) FROM nhan_vien))::TEXT;
        
    -- Check users with plain text passwords
    RETURN QUERY SELECT 
        'users_need_migration'::TEXT,
        'INFO'::TEXT,
        ('Users needing migration: ' || (
            SELECT COUNT(*) FROM nhan_vien 
            WHERE hashed_password IS NULL OR hashed_password = ''
        ))::TEXT;
END;
$$;

-- Test bcrypt functionality
CREATE OR REPLACE FUNCTION test_bcrypt_functionality()
RETURNS TABLE(
    test_name TEXT,
    result TEXT,
    details TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    test_password TEXT := 'test123';
    test_hash TEXT;
    verification_result BOOLEAN;
BEGIN
    -- Test password hashing
    BEGIN
        test_hash := crypt(test_password, gen_salt('bf', 12));
        
        RETURN QUERY SELECT 
            'hash_generation'::TEXT,
            'SUCCESS'::TEXT,
            ('Generated hash length: ' || LENGTH(test_hash))::TEXT;
    EXCEPTION WHEN OTHERS THEN
        RETURN QUERY SELECT 
            'hash_generation'::TEXT,
            'FAILED'::TEXT,
            SQLERRM::TEXT;
        RETURN;
    END;
    
    -- Test password verification
    BEGIN
        verification_result := (test_hash = crypt(test_password, test_hash));
        
        RETURN QUERY SELECT 
            'hash_verification'::TEXT,
            CASE WHEN verification_result THEN 'SUCCESS' ELSE 'FAILED' END::TEXT,
            ('Verification result: ' || verification_result)::TEXT;
    EXCEPTION WHEN OTHERS THEN
        RETURN QUERY SELECT 
            'hash_verification'::TEXT,
            'FAILED'::TEXT,
            SQLERRM::TEXT;
    END;
END;
$$;

-- Add comments
COMMENT ON TABLE nhan_vien_backup_pre_hash IS 'Backup table created before password hashing migration';
COMMENT ON TABLE password_migration_log IS 'Log table tracking password migration progress and results';
COMMENT ON FUNCTION verify_migration_prerequisites() IS 'Verify all prerequisites for password migration are met';
COMMENT ON FUNCTION test_bcrypt_functionality() IS 'Test bcrypt hashing and verification functionality';


-- =====================================================
-- 20241225_password_migration_execute.sql
-- =====================================================
-- PASSWORD MIGRATION EXECUTION

-- Migrate all existing plain text passwords to hashed format

-- Migration function để hash existing passwords
CREATE OR REPLACE FUNCTION migrate_existing_passwords()
RETURNS TABLE(
    user_id BIGINT,
    username TEXT,
    status TEXT,
    message TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    user_record RECORD;
    hashed_password TEXT;
    migration_count INTEGER := 0;
    total_users INTEGER;
BEGIN
    -- Get total count for progress tracking
    SELECT COUNT(*) INTO total_users 
    FROM nhan_vien 
    WHERE hashed_password IS NULL OR hashed_password = '' OR password != 'hashed password';
    
    RAISE NOTICE 'Starting password migration for % users', total_users;
    
    -- Loop through all users that need migration
    FOR user_record IN 
        SELECT id, username, password, full_name 
        FROM nhan_vien 
        WHERE hashed_password IS NULL OR hashed_password = '' OR password != 'hashed password'
        ORDER BY id
    LOOP
        BEGIN
            -- Log migration start
            INSERT INTO password_migration_log (user_id, username, migration_status)
            VALUES (user_record.id, user_record.username, 'pending');
            
            -- Hash the current plain text password
            hashed_password := crypt(user_record.password, gen_salt('bf', 12));
            
            -- Update user record với hashed password, keep original for verification
            UPDATE nhan_vien 
            SET hashed_password = hashed_password,
                -- Keep original password temporarily for verification
                password = user_record.password  -- Will be changed to 'hashed password' after verification
            WHERE id = user_record.id;
            
            -- Update log với success
            UPDATE password_migration_log 
            SET migration_status = 'success',
                original_password_hash = hashed_password
            WHERE user_id = user_record.id AND migration_status = 'pending';
            
            migration_count := migration_count + 1;
            
            -- Return progress
            RETURN QUERY SELECT 
                user_record.id,
                user_record.username::TEXT,
                'SUCCESS'::TEXT,
                ('Migrated ' || migration_count || '/' || total_users)::TEXT;
                
        EXCEPTION WHEN OTHERS THEN
            -- Log error
            UPDATE password_migration_log 
            SET migration_status = 'failed',
                error_message = SQLERRM
            WHERE user_id = user_record.id AND migration_status = 'pending';
            
            -- Return error
            RETURN QUERY SELECT 
                user_record.id,
                user_record.username::TEXT,
                'FAILED'::TEXT,
                ('Error: ' || SQLERRM)::TEXT;
        END;
    END LOOP;
    
    RAISE NOTICE 'Password migration completed. Migrated: %, Total: %', migration_count, total_users;
END;
$$;

-- Verification function để test migrated passwords
CREATE OR REPLACE FUNCTION verify_migrated_passwords()
RETURNS TABLE(
    user_id BIGINT,
    username TEXT,
    original_password_works BOOLEAN,
    hashed_password_works BOOLEAN,
    verification_status TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    user_record RECORD;
    original_check BOOLEAN;
    hashed_check BOOLEAN;
BEGIN
    -- Loop through migrated users để verify
    FOR user_record IN 
        SELECT id, username, password, hashed_password 
        FROM nhan_vien 
        WHERE hashed_password IS NOT NULL AND hashed_password != ''
        ORDER BY id
    LOOP
        -- Test original password against hash
        original_check := (user_record.hashed_password = crypt(user_record.password, user_record.hashed_password));
        
        -- Test against "hashed password" string (should fail)
        hashed_check := (user_record.hashed_password = crypt('hashed password', user_record.hashed_password));
        
        RETURN QUERY SELECT 
            user_record.id,
            user_record.username::TEXT,
            original_check,
            hashed_check,
            CASE 
                WHEN original_check AND NOT hashed_check THEN 'PASS'
                WHEN NOT original_check THEN 'FAIL - Original password verification failed'
                WHEN hashed_check THEN 'FAIL - Hashed password string should not work'
                ELSE 'UNKNOWN'
            END::TEXT;
    END LOOP;
END;
$$;

-- Function để finalize migration (replace plain text với placeholder)
CREATE OR REPLACE FUNCTION finalize_password_migration()
RETURNS TABLE(
    user_id BIGINT,
    username TEXT,
    status TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    user_record RECORD;
    affected_count INTEGER := 0;
BEGIN
    -- Only finalize users that passed verification
    FOR user_record IN 
        SELECT nv.id, nv.username 
        FROM nhan_vien nv
        JOIN password_migration_log pml ON pml.user_id = nv.id
        WHERE pml.migration_status = 'success' 
        AND nv.hashed_password IS NOT NULL 
        AND nv.password != 'hashed password'
        ORDER BY nv.id
    LOOP
        -- Replace plain text password với placeholder
        UPDATE nhan_vien 
        SET password = 'hashed password'
        WHERE id = user_record.id;
        
        affected_count := affected_count + 1;
        
        RETURN QUERY SELECT 
            user_record.id,
            user_record.username::TEXT,
            'FINALIZED'::TEXT;
    END LOOP;
    
    RAISE NOTICE 'Finalized % user passwords', affected_count;
END;
$$;

-- Rollback function trong trường hợp cần revert
CREATE OR REPLACE FUNCTION rollback_password_migration()
RETURNS TABLE(
    user_id BIGINT,
    username TEXT,
    status TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    user_record RECORD;
    rollback_count INTEGER := 0;
BEGIN
    RAISE NOTICE 'Starting password migration rollback...';
    
    -- Restore từ backup table
    FOR user_record IN 
        SELECT backup.id, backup.username, backup.password
        FROM nhan_vien_backup_pre_hash backup
        WHERE EXISTS (
            SELECT 1 FROM password_migration_log pml 
            WHERE pml.user_id = backup.id AND pml.migration_status = 'success'
        )
        ORDER BY backup.id
    LOOP
        BEGIN
            -- Restore original password và clear hashed_password
            UPDATE nhan_vien 
            SET password = user_record.password,
                hashed_password = NULL
            WHERE id = user_record.id;
            
            -- Mark as rolled back in log
            UPDATE password_migration_log 
            SET migration_status = 'rollback'
            WHERE user_id = user_record.id;
            
            rollback_count := rollback_count + 1;
            
            RETURN QUERY SELECT 
                user_record.id,
                user_record.username::TEXT,
                'ROLLED_BACK'::TEXT;
                
        EXCEPTION WHEN OTHERS THEN
            RETURN QUERY SELECT 
                user_record.id,
                user_record.username::TEXT,
                ('ROLLBACK_FAILED: ' || SQLERRM)::TEXT;
        END;
    END LOOP;
    
    RAISE NOTICE 'Rollback completed for % users', rollback_count;
END;
$$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION migrate_existing_passwords() TO authenticated;
GRANT EXECUTE ON FUNCTION verify_migrated_passwords() TO authenticated;
GRANT EXECUTE ON FUNCTION finalize_password_migration() TO authenticated;
GRANT EXECUTE ON FUNCTION rollback_password_migration() TO authenticated;

-- Add comments
COMMENT ON FUNCTION migrate_existing_passwords() IS 'Migrate all existing plain text passwords to bcrypt hashed format';
COMMENT ON FUNCTION verify_migrated_passwords() IS 'Verify that migrated passwords work correctly with original passwords';
COMMENT ON FUNCTION finalize_password_migration() IS 'Replace plain text passwords with placeholder after successful verification';
COMMENT ON FUNCTION rollback_password_migration() IS 'Rollback password migration to original plain text state';


-- =====================================================
-- 20241226_optimize_thiet_bi_indexes.sql
-- =====================================================
-- OPTIMIZE THIET_BI TABLE INDEXES FOR SEARCH PERFORMANCE

-- Comprehensive indexing strategy for equipment search workflows:
-- 1. Repair requests equipment search
-- 2. Maintenance planning equipment search
-- 3. Equipment catalog filtering and search
-- 4. QR scanner equipment lookup
-- 5. Dashboard equipment status queries
-- 6. Reports and analytics queries

-- 0. ENABLE REQUIRED EXTENSIONS FIRST

-- Enable pg_trgm extension for fuzzy text search (MUST BE FIRST)
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 1. PRIMARY SEARCH INDEXES

-- Composite index for text search (ten_thiet_bi + ma_thiet_bi)
-- Supports ILIKE queries with % wildcards
CREATE INDEX IF NOT EXISTS idx_thiet_bi_search_text
ON thiet_bi USING gin (
  (ten_thiet_bi || ' ' || ma_thiet_bi) gin_trgm_ops
);

-- Individual text search indexes for specific field searches
CREATE INDEX IF NOT EXISTS idx_thiet_bi_ten_thiet_bi_trgm
ON thiet_bi USING gin (ten_thiet_bi gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_thiet_bi_ma_thiet_bi_trgm
ON thiet_bi USING gin (ma_thiet_bi gin_trgm_ops);

-- Exact match index for QR scanner (ma_thiet_bi exact lookup)
-- NOTE: SKIPPED - thiet_bi_ma_thiet_bi_key already exists as UNIQUE constraint
-- CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_thiet_bi_ma_thiet_bi_exact
-- ON thiet_bi (ma_thiet_bi);

-- 2. FILTERING AND GROUPING INDEXES

-- Department/location filtering (most common filters)
CREATE INDEX IF NOT EXISTS idx_thiet_bi_khoa_phong_quan_ly
ON thiet_bi (khoa_phong_quan_ly);

CREATE INDEX IF NOT EXISTS idx_thiet_bi_vi_tri_lap_dat
ON thiet_bi (vi_tri_lap_dat);

-- Equipment status filtering (dashboard and reports)
CREATE INDEX IF NOT EXISTS idx_thiet_bi_tinh_trang_hien_tai
ON thiet_bi (tinh_trang_hien_tai);

-- 3. COMPOSITE INDEXES FOR COMPLEX QUERIES

-- Department + Status filtering (common in reports)
CREATE INDEX IF NOT EXISTS idx_thiet_bi_dept_status
ON thiet_bi (khoa_phong_quan_ly, tinh_trang_hien_tai);

-- Location + Status filtering
CREATE INDEX IF NOT EXISTS idx_thiet_bi_location_status
ON thiet_bi (vi_tri_lap_dat, tinh_trang_hien_tai);

-- Equipment type + department filtering
-- NOTE: SKIPPED - loai_thiet_bi_id column does not exist in current schema
-- CREATE INDEX IF NOT EXISTS idx_thiet_bi_type_dept
-- ON thiet_bi (loai_thiet_bi_id, khoa_phong_quan_ly)
-- WHERE loai_thiet_bi_id IS NOT NULL;

-- 4. MAINTENANCE WORKFLOW INDEXES

-- Maintenance date filtering and sorting (including NULL for complete coverage)
CREATE INDEX IF NOT EXISTS idx_thiet_bi_ngay_bt_tiep_theo
ON thiet_bi (ngay_bt_tiep_theo);

-- Equipment status and maintenance date composite (supports all status filtering)
CREATE INDEX IF NOT EXISTS idx_thiet_bi_status_maintenance
ON thiet_bi (tinh_trang_hien_tai, ngay_bt_tiep_theo);

-- 5. TEMPORAL AND AUDIT INDEXES

-- Date-based filtering for reports
CREATE INDEX IF NOT EXISTS idx_thiet_bi_ngay_nhap
ON thiet_bi (ngay_nhap);

CREATE INDEX IF NOT EXISTS idx_thiet_bi_ngay_dua_vao_su_dung
ON thiet_bi (ngay_dua_vao_su_dung);

-- 6. EQUIPMENT HISTORY INDEXES

-- Equipment history filtering and sorting
CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_thiet_bi_id
ON lich_su_thiet_bi (thiet_bi_id);

CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_ngay_thuc_hien
ON lich_su_thiet_bi (ngay_thuc_hien);

-- Composite index for equipment history queries (most common pattern)
CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_equipment_date
ON lich_su_thiet_bi (thiet_bi_id, ngay_thuc_hien DESC);

-- Event type filtering for history
CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_loai_su_kien
ON lich_su_thiet_bi (loai_su_kien);

-- Audit trail indexes
-- NOTE: SKIPPED - created_at/updated_at columns may not exist in current schema
-- CREATE INDEX IF NOT EXISTS idx_thiet_bi_created_at
-- ON thiet_bi (created_at);
-- CREATE INDEX IF NOT EXISTS idx_thiet_bi_updated_at
-- ON thiet_bi (updated_at);

-- 6. FOREIGN KEY RELATIONSHIP INDEXES

-- Foreign key indexes for JOINs
-- NOTE: SKIPPED - phong_ban_id and loai_thiet_bi_id columns do not exist in current schema
-- CREATE INDEX IF NOT EXISTS idx_thiet_bi_phong_ban_id
-- ON thiet_bi (phong_ban_id)
-- WHERE phong_ban_id IS NOT NULL;
-- CREATE INDEX IF NOT EXISTS idx_thiet_bi_loai_thiet_bi_id
-- ON thiet_bi (loai_thiet_bi_id)
-- WHERE loai_thiet_bi_id IS NOT NULL;

-- 7. SPECIALIZED WORKFLOW INDEXES

-- Equipment value/cost analysis (including NULL and 0 values for complete coverage)
CREATE INDEX IF NOT EXISTS idx_thiet_bi_gia_goc
ON thiet_bi (gia_goc);

-- Warranty tracking (including NULL for equipment without warranty info)
CREATE INDEX IF NOT EXISTS idx_thiet_bi_han_bao_hanh
ON thiet_bi (han_bao_hanh);

-- Manufacturing year analysis (including NULL for unknown manufacturing year)
CREATE INDEX IF NOT EXISTS idx_thiet_bi_nam_san_xuat
ON thiet_bi (nam_san_xuat);

-- 8. EXTENSION ALREADY ENABLED ABOVE

-- pg_trgm extension already enabled at the beginning of this script

-- 9. PERFORMANCE MONITORING VIEWS

-- Create view to monitor index usage
CREATE OR REPLACE VIEW thiet_bi_index_usage AS
SELECT
    schemaname,
    relname as tablename,
    indexrelname as indexname,
    idx_tup_read,
    idx_tup_fetch,
    idx_scan,
    CASE
        WHEN idx_scan = 0 THEN 'UNUSED'
        WHEN idx_scan < 100 THEN 'LOW_USAGE'
        WHEN idx_scan < 1000 THEN 'MEDIUM_USAGE'
        ELSE 'HIGH_USAGE'
    END as usage_level
FROM pg_stat_user_indexes
WHERE relname = 'thiet_bi'
ORDER BY idx_scan DESC;

-- 10. COMMENTS AND DOCUMENTATION

COMMENT ON INDEX idx_thiet_bi_search_text IS 'Composite GIN index for full-text search on equipment name and code';
-- COMMENT ON INDEX idx_thiet_bi_ma_thiet_bi_exact IS 'B-tree index for exact QR code lookups'; -- SKIPPED - using existing unique constraint
COMMENT ON INDEX idx_thiet_bi_dept_status IS 'Composite index for department and status filtering';
COMMENT ON INDEX idx_thiet_bi_status_maintenance IS 'Composite index for status and maintenance date filtering';
COMMENT ON INDEX idx_lich_su_thiet_bi_equipment_date IS 'Composite index for equipment history queries with date sorting';
COMMENT ON VIEW thiet_bi_index_usage IS 'Monitor index usage statistics for thiet_bi table';

-- 11. QUERY OPTIMIZATION HINTS

/*
USAGE EXAMPLES:

1. Equipment Search (Repair Requests, Maintenance):
   SELECT * FROM thiet_bi
   WHERE ten_thiet_bi ILIKE '%keyword%' OR ma_thiet_bi ILIKE '%keyword%'
   -- Uses: idx_thiet_bi_search_text

2. QR Scanner Lookup:
   SELECT * FROM thiet_bi WHERE ma_thiet_bi = 'TB001'
   -- Uses: idx_thiet_bi_ma_thiet_bi_exact

3. Department Filtering:
   SELECT * FROM thiet_bi WHERE khoa_phong_quan_ly = 'Khoa Nội'
   -- Uses: idx_thiet_bi_khoa_phong_quan_ly

4. Dashboard Attention Query:
   SELECT * FROM thiet_bi
   WHERE tinh_trang_hien_tai IN ('Chờ sửa chữa', 'Chờ bảo trì')
   ORDER BY ngay_bt_tiep_theo
   -- Uses: idx_thiet_bi_status_maintenance

5. All Equipment Status Analysis:
   SELECT tinh_trang_hien_tai, COUNT(*) FROM thiet_bi
   GROUP BY tinh_trang_hien_tai
   -- Uses: idx_thiet_bi_tinh_trang_hien_tai

5. Complex Filtering:
   SELECT * FROM thiet_bi
   WHERE khoa_phong_quan_ly = 'Khoa Ngoại'
   AND tinh_trang_hien_tai = 'Hoạt động bình thường'
   -- Uses: idx_thiet_bi_dept_status

6. Real-time Search (as-you-type):
   SELECT id, ma_thiet_bi, ten_thiet_bi
   FROM thiet_bi
   WHERE ten_thiet_bi ILIKE '%search_term%'
   LIMIT 10
   -- Uses: idx_thiet_bi_ten_thiet_bi_trgm

7. Maintenance Planning:
   SELECT * FROM thiet_bi
   WHERE tinh_trang_hien_tai = 'Hoạt động bình thường'
   AND ngay_bt_tiep_theo <= CURRENT_DATE + INTERVAL '30 days'
   ORDER BY ngay_bt_tiep_theo
   -- Uses: idx_thiet_bi_status_maintenance

8. Equipment Reports by Value:
   SELECT * FROM thiet_bi
   WHERE gia_goc > 100000000
   ORDER BY gia_goc DESC NULLS LAST
   -- Uses: idx_thiet_bi_gia_goc

9. Equipment with No Value (NULL or 0):
   SELECT * FROM thiet_bi
   WHERE gia_goc IS NULL OR gia_goc = 0
   -- Uses: idx_thiet_bi_gia_goc

10. Equipment History Query (Equipment Detail Dialog):
    SELECT * FROM lich_su_thiet_bi
    WHERE thiet_bi_id = 123
    ORDER BY ngay_thuc_hien DESC
    -- Uses: idx_lich_su_thiet_bi_equipment_date

11. History by Event Type:
    SELECT * FROM lich_su_thiet_bi
    WHERE loai_su_kien = 'Luân chuyển'
    ORDER BY ngay_thuc_hien DESC
    -- Uses: idx_lich_su_thiet_bi_loai_su_kien
*/

-- 12. PERFORMANCE RECOMMENDATIONS

/*
PERFORMANCE TIPS:

1. Use LIMIT for search results to prevent large result sets
2. Consider using OFFSET with caution - use cursor-based pagination instead
3. Use specific field searches when possible (ma_thiet_bi vs full-text)
4. Monitor index usage with thiet_bi_index_usage view
5. Consider partial indexes for frequently filtered subsets
6. Use EXPLAIN ANALYZE to verify index usage in queries

MAINTENANCE:

1. Run ANALYZE thiet_bi; after bulk data changes
2. Monitor index bloat and rebuild if necessary
3. Review unused indexes periodically
4. Update statistics regularly for optimal query planning
*/


-- =====================================================
-- 20241227_check_transfer_history.sql
-- =====================================================
-- PRE-MIGRATION CHECK: TRANSFER HISTORY ANALYSIS

-- Run this script BEFORE the migration to understand current state
-- This helps you verify what will be migrated
--
-- Table structures:
-- yeu_cau_luan_chuyen: id, ma_yeu_cau, thiet_bi_id, loai_hinh (noi_bo/ben_ngoai/thanh_ly), trang_thai, nguoi_yeu_cau_id, ly_do_luan_chuyen, khoa_phong_hien_tai, khoa_phong_nhan, muc_dich, don_vi_nhan, dia_chi_don_vi, nguoi_lien_he, so_dien_thoai, ngay_du_kien_tra, ngay_ban_giao, ngay_hoan_tra, ngay_hoan_thanh, nguoi_duyet_id, ngay_duyet, ghi_chu_duyet, created_at, updated_at, created_by, updated_by
-- lich_su_thiet_bi: id, thiet_bi_id, ngay_thuc_hien, loai_su_kien, mo_ta, chi_tiet, yeu_cau_id
-- lich_su_luan_chuyen: id, yeu_cau_id, trang_thai_cu, trang_thai_moi, hanh_dong, mo_ta, nguoi_thuc_hien_id, thoi_gian

-- 1. CURRENT STATE ANALYSIS

-- Check completed transfer requests
SELECT
    'Completed Transfer Requests' as check_type,
    COUNT(*) as count,
    'Total transfer requests with status hoan_thanh' as description
FROM yeu_cau_luan_chuyen
WHERE trang_thai = 'hoan_thanh';

-- Check existing transfer history in lich_su_thiet_bi
SELECT
    'Existing Transfer History' as check_type,
    COUNT(*) as count,
    'Transfer history already in lich_su_thiet_bi' as description
FROM lich_su_thiet_bi
WHERE loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý');

-- Check transfer requests WITHOUT history in lich_su_thiet_bi
SELECT
    'Missing Transfer History' as check_type,
    COUNT(*) as count,
    'Completed transfers missing from lich_su_thiet_bi (will be migrated)' as description
FROM yeu_cau_luan_chuyen ylc
WHERE ylc.trang_thai = 'hoan_thanh'
  AND NOT EXISTS (
      SELECT 1
      FROM lich_su_thiet_bi lstb
      WHERE lstb.yeu_cau_id = ylc.id
        AND lstb.loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý')
  );

-- 2. DETAILED BREAKDOWN BY TRANSFER TYPE

SELECT
    ylc.loai_hinh,
    CASE
        WHEN ylc.loai_hinh = 'noi_bo' THEN 'Nội bộ'
        WHEN ylc.loai_hinh = 'ben_ngoai' THEN 'Bên ngoài'
        WHEN ylc.loai_hinh = 'thanh_ly' THEN 'Thanh lý'
        ELSE ylc.loai_hinh
    END as loai_hinh_display,
    COUNT(*) as total_completed,
    COUNT(lstb.id) as has_history,
    COUNT(*) - COUNT(lstb.id) as missing_history
FROM yeu_cau_luan_chuyen ylc
LEFT JOIN lich_su_thiet_bi lstb ON (
    lstb.yeu_cau_id = ylc.id
    AND lstb.loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý')
)
WHERE ylc.trang_thai = 'hoan_thanh'
GROUP BY ylc.loai_hinh
ORDER BY ylc.loai_hinh;

-- 3. SAMPLE RECORDS TO BE MIGRATED

-- Show sample of transfers that will be migrated
SELECT
    ylc.ma_yeu_cau,
    ylc.loai_hinh,
    ylc.khoa_phong_hien_tai,
    ylc.khoa_phong_nhan,
    ylc.don_vi_nhan,
    ylc.created_at,
    ylc.updated_at,
    ylc.ngay_ban_giao,
    -- Show completion date from history (using thoi_gian column)
    (SELECT lslc.thoi_gian
     FROM lich_su_luan_chuyen lslc
     WHERE lslc.yeu_cau_id = ylc.id
       AND lslc.trang_thai_moi = 'hoan_thanh'
     ORDER BY lslc.thoi_gian DESC
     LIMIT 1) as completion_date_from_history
FROM yeu_cau_luan_chuyen ylc
WHERE ylc.trang_thai = 'hoan_thanh'
  AND NOT EXISTS (
      SELECT 1
      FROM lich_su_thiet_bi lstb
      WHERE lstb.yeu_cau_id = ylc.id
        AND lstb.loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý')
  )
ORDER BY ylc.created_at DESC
LIMIT 5;

-- 4. EQUIPMENT WITH MISSING TRANSFER HISTORY

-- Show equipment that have completed transfers but missing history
SELECT 
    tb.ma_thiet_bi,
    tb.ten_thiet_bi,
    tb.khoa_phong_quan_ly,
    COUNT(ylc.id) as completed_transfers_without_history
FROM thiet_bi tb
INNER JOIN yeu_cau_luan_chuyen ylc ON tb.id = ylc.thiet_bi_id
WHERE ylc.trang_thai = 'hoan_thanh'
  AND NOT EXISTS (
      SELECT 1 
      FROM lich_su_thiet_bi lstb 
      WHERE lstb.yeu_cau_id = ylc.id 
        AND lstb.loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý')
  )
GROUP BY tb.id, tb.ma_thiet_bi, tb.ten_thiet_bi, tb.khoa_phong_quan_ly
ORDER BY completed_transfers_without_history DESC
LIMIT 10;

-- 5. DATE RANGE ANALYSIS

-- Show date range of transfers to be migrated
SELECT
    'Date Range Analysis' as analysis_type,
    MIN(ylc.created_at) as earliest_transfer,
    MAX(ylc.created_at) as latest_transfer,
    MIN(COALESCE(
        (SELECT lslc.thoi_gian
         FROM lich_su_luan_chuyen lslc
         WHERE lslc.yeu_cau_id = ylc.id
           AND lslc.trang_thai_moi = 'hoan_thanh'
         ORDER BY lslc.thoi_gian DESC
         LIMIT 1),
        ylc.ngay_ban_giao,
        ylc.updated_at
    )) as earliest_completion,
    MAX(COALESCE(
        (SELECT lslc.thoi_gian
         FROM lich_su_luan_chuyen lslc
         WHERE lslc.yeu_cau_id = ylc.id
           AND lslc.trang_thai_moi = 'hoan_thanh'
         ORDER BY lslc.thoi_gian DESC
         LIMIT 1),
        ylc.ngay_ban_giao,
        ylc.updated_at
    )) as latest_completion
FROM yeu_cau_luan_chuyen ylc
WHERE ylc.trang_thai = 'hoan_thanh'
  AND NOT EXISTS (
      SELECT 1
      FROM lich_su_thiet_bi lstb
      WHERE lstb.yeu_cau_id = ylc.id
        AND lstb.loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý')
  );

-- 6. SAFETY CHECKS

-- Check for any data quality issues
SELECT 
    'Data Quality Check' as check_type,
    COUNT(*) as count,
    'Transfers with missing thiet_bi_id (potential issues)' as description
FROM yeu_cau_luan_chuyen 
WHERE trang_thai = 'hoan_thanh' 
  AND thiet_bi_id IS NULL;

-- Check for orphaned transfers (equipment doesn't exist)
SELECT 
    'Orphaned Transfers' as check_type,
    COUNT(*) as count,
    'Transfers referencing non-existent equipment' as description
FROM yeu_cau_luan_chuyen ylc
WHERE ylc.trang_thai = 'hoan_thanh'
  AND NOT EXISTS (SELECT 1 FROM thiet_bi tb WHERE tb.id = ylc.thiet_bi_id);

-- SUMMARY

-- Final summary
DO $$
DECLARE
    total_completed INTEGER;
    has_history INTEGER;
    will_migrate INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_completed
    FROM yeu_cau_luan_chuyen 
    WHERE trang_thai = 'hoan_thanh';
    
    SELECT COUNT(*) INTO has_history
    FROM yeu_cau_luan_chuyen ylc
    WHERE ylc.trang_thai = 'hoan_thanh'
      AND EXISTS (
          SELECT 1 
          FROM lich_su_thiet_bi lstb 
          WHERE lstb.yeu_cau_id = ylc.id 
            AND lstb.loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý')
      );
    
    will_migrate := total_completed - has_history;
    
    RAISE NOTICE '=== MIGRATION SUMMARY ===';
    RAISE NOTICE 'Total completed transfers: %', total_completed;
    RAISE NOTICE 'Already have history: %', has_history;
    RAISE NOTICE 'Will be migrated: %', will_migrate;
    RAISE NOTICE '========================';
    
    IF will_migrate > 0 THEN
        RAISE NOTICE 'READY: % transfer history records will be created', will_migrate;
    ELSE
        RAISE NOTICE 'INFO: No migration needed - all transfers already have history';
    END IF;
END $$;


-- =====================================================
-- 20241227_migrate_transfer_history.sql
-- =====================================================
-- MIGRATE TRANSFER HISTORY FOR COMPLETED REQUESTS

-- This migration adds missing transfer history records to lich_su_thiet_bi
-- for all completed transfer requests that were processed before the fix.
--
-- Background: Transfer completion was logging to lich_su_luan_chuyen (automatic trigger)
-- but missing from lich_su_thiet_bi (manual insert) due to missing ngay_thuc_hien field.
--
-- Table structures:
-- yeu_cau_luan_chuyen: id, ma_yeu_cau, thiet_bi_id, loai_hinh, trang_thai, nguoi_yeu_cau_id, ly_do_luan_chuyen, khoa_phong_hien_tai, khoa_phong_nhan, muc_dich, don_vi_nhan, dia_chi_don_vi, nguoi_lien_he, so_dien_thoai, ngay_du_kien_tra, ngay_ban_giao, ngay_hoan_tra, ngay_hoan_thanh, nguoi_duyet_id, ngay_duyet, ghi_chu_duyet, created_at, updated_at, created_by, updated_by
-- lich_su_thiet_bi: id, thiet_bi_id, ngay_thuc_hien, loai_su_kien, mo_ta, chi_tiet, yeu_cau_id

-- 1. BACKUP AND VERIFICATION

-- Create backup table for safety
CREATE TABLE IF NOT EXISTS lich_su_thiet_bi_backup_20241227 AS 
SELECT * FROM lich_su_thiet_bi WHERE 1=0; -- Empty structure

-- Insert current data as backup
INSERT INTO lich_su_thiet_bi_backup_20241227 
SELECT * FROM lich_su_thiet_bi;

-- Log migration start
DO $$
BEGIN
    RAISE NOTICE 'Starting transfer history migration at %', NOW();
    RAISE NOTICE 'Backup created: lich_su_thiet_bi_backup_20241227';
END $$;

-- 2. ANALYSIS QUERIES (FOR VERIFICATION)

-- Count completed transfers without history in lich_su_thiet_bi
DO $$
DECLARE
    completed_transfers_count INTEGER;
    existing_history_count INTEGER;
    missing_history_count INTEGER;
BEGIN
    -- Count completed transfers
    SELECT COUNT(*) INTO completed_transfers_count
    FROM yeu_cau_luan_chuyen 
    WHERE trang_thai = 'hoan_thanh';
    
    -- Count existing transfer history in lich_su_thiet_bi
    SELECT COUNT(*) INTO existing_history_count
    FROM lich_su_thiet_bi 
    WHERE loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý');
    
    missing_history_count := completed_transfers_count - existing_history_count;
    
    RAISE NOTICE 'Completed transfers: %', completed_transfers_count;
    RAISE NOTICE 'Existing transfer history: %', existing_history_count;
    RAISE NOTICE 'Missing transfer history: %', missing_history_count;
END $$;

-- 3. MIGRATION LOGIC

-- Insert missing transfer history records
-- Table structure: id, thiet_bi_id, ngay_thuc_hien, loai_su_kien, mo_ta, chi_tiet, yeu_cau_id
INSERT INTO lich_su_thiet_bi (
    thiet_bi_id,
    ngay_thuc_hien,
    loai_su_kien,
    mo_ta,
    chi_tiet,
    yeu_cau_id
)
SELECT
    ylc.thiet_bi_id,
    -- Get completion date from history or fallback to other dates
    COALESCE(
        (SELECT lslc.thoi_gian
         FROM lich_su_luan_chuyen lslc
         WHERE lslc.yeu_cau_id = ylc.id
           AND lslc.trang_thai_moi = 'hoan_thanh'
         ORDER BY lslc.thoi_gian DESC
         LIMIT 1),
        ylc.ngay_hoan_thanh,
        ylc.ngay_ban_giao,
        ylc.ngay_hoan_tra,
        ylc.updated_at,
        ylc.created_at
    ) as ngay_thuc_hien,
    -- Determine event type based on transfer type
    CASE
        WHEN ylc.loai_hinh = 'noi_bo' THEN 'Luân chuyển nội bộ'
        WHEN ylc.loai_hinh = 'ben_ngoai' THEN 'Luân chuyển bên ngoài'
        WHEN ylc.loai_hinh = 'thanh_ly' THEN 'Thanh lý'
        ELSE 'Luân chuyển'
    END as loai_su_kien,
    -- Generate description based on transfer type
    CASE
        WHEN ylc.loai_hinh = 'noi_bo' THEN
            'Thiết bị được luân chuyển từ "' || COALESCE(ylc.khoa_phong_hien_tai, 'N/A') || '" đến "' || COALESCE(ylc.khoa_phong_nhan, 'N/A') || '".'
        WHEN ylc.loai_hinh = 'ben_ngoai' THEN
            'Thiết bị được hoàn trả từ đơn vị bên ngoài "' || COALESCE(ylc.don_vi_nhan, 'N/A') || '".'
        WHEN ylc.loai_hinh = 'thanh_ly' THEN
            'Thiết bị được thanh lý theo yêu cầu "' || ylc.ma_yeu_cau || '".'
        ELSE
            'Hoàn thành luân chuyển thiết bị theo yêu cầu "' || ylc.ma_yeu_cau || '".'
    END as mo_ta,
    -- Build chi_tiet JSON object
    jsonb_build_object(
        'ma_yeu_cau', ylc.ma_yeu_cau,
        'loai_hinh', ylc.loai_hinh,
        'khoa_phong_hien_tai', ylc.khoa_phong_hien_tai,
        'khoa_phong_nhan', ylc.khoa_phong_nhan,
        'don_vi_nhan', ylc.don_vi_nhan,
        'ly_do_luan_chuyen', ylc.ly_do_luan_chuyen,
        'migrated_from_old_request', true,
        'migration_date', NOW()
    ) as chi_tiet,
    ylc.id as yeu_cau_id
FROM yeu_cau_luan_chuyen ylc
WHERE ylc.trang_thai = 'hoan_thanh'
  -- Only insert if not already exists in lich_su_thiet_bi
  AND NOT EXISTS (
      SELECT 1 
      FROM lich_su_thiet_bi lstb 
      WHERE lstb.yeu_cau_id = ylc.id 
        AND lstb.loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý')
  );

-- 4. VERIFICATION AND LOGGING

-- Log migration results
DO $$
DECLARE
    migrated_count INTEGER;
    total_history_count INTEGER;
BEGIN
    -- Count newly migrated records
    SELECT COUNT(*) INTO migrated_count
    FROM lich_su_thiet_bi 
    WHERE chi_tiet->>'migrated_from_old_request' = 'true';
    
    -- Count total transfer history
    SELECT COUNT(*) INTO total_history_count
    FROM lich_su_thiet_bi 
    WHERE loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý');
    
    RAISE NOTICE 'Migration completed at %', NOW();
    RAISE NOTICE 'Records migrated: %', migrated_count;
    RAISE NOTICE 'Total transfer history records: %', total_history_count;
    
    IF migrated_count > 0 THEN
        RAISE NOTICE 'SUCCESS: Transfer history migration completed successfully';
    ELSE
        RAISE NOTICE 'INFO: No records needed migration (all transfers already have history)';
    END IF;
END $$;

-- 5. VERIFICATION QUERIES

-- Show sample of migrated records
DO $$
DECLARE
    sample_record RECORD;
BEGIN
    RAISE NOTICE 'Sample migrated records:';
    FOR sample_record IN 
        SELECT 
            lstb.id,
            lstb.loai_su_kien,
            lstb.mo_ta,
            lstb.ngay_thuc_hien,
            lstb.chi_tiet->>'ma_yeu_cau' as ma_yeu_cau
        FROM lich_su_thiet_bi lstb
        WHERE lstb.chi_tiet->>'migrated_from_old_request' = 'true'
        ORDER BY lstb.ngay_thuc_hien DESC
        LIMIT 3
    LOOP
        RAISE NOTICE 'ID: %, Event: %, Request: %, Date: %', 
            sample_record.id, 
            sample_record.loai_su_kien, 
            sample_record.ma_yeu_cau, 
            sample_record.ngay_thuc_hien;
    END LOOP;
END $$;

-- 6. CLEANUP INSTRUCTIONS

/*
CLEANUP INSTRUCTIONS (run after verification):

-- If migration is successful and verified, you can drop the backup table:
-- DROP TABLE lich_su_thiet_bi_backup_20241227;

-- If you need to rollback the migration:
-- DELETE FROM lich_su_thiet_bi WHERE chi_tiet->>'migrated_from_old_request' = 'true';

VERIFICATION QUERIES:

-- Check migrated records:
SELECT COUNT(*) as migrated_records 
FROM lich_su_thiet_bi 
WHERE chi_tiet->>'migrated_from_old_request' = 'true';

-- Check transfer history by equipment:
SELECT 
    tb.ma_thiet_bi,
    tb.ten_thiet_bi,
    COUNT(lstb.id) as history_count
FROM thiet_bi tb
LEFT JOIN lich_su_thiet_bi lstb ON tb.id = lstb.thiet_bi_id
WHERE lstb.loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý')
GROUP BY tb.id, tb.ma_thiet_bi, tb.ten_thiet_bi
ORDER BY history_count DESC;

-- Check for any missing history:
SELECT ylc.ma_yeu_cau, ylc.trang_thai, ylc.loai_hinh
FROM yeu_cau_luan_chuyen ylc
WHERE ylc.trang_thai = 'hoan_thanh'
  AND NOT EXISTS (
      SELECT 1 FROM lich_su_thiet_bi lstb 
      WHERE lstb.yeu_cau_id = ylc.id
  );
*/


-- =====================================================
-- 20241227_optimize_lich_su_thiet_bi_indexes.sql
-- =====================================================
-- OPTIMIZE LICH_SU_THIET_BI TABLE INDEXES FOR HISTORY QUERIES

-- Comprehensive indexing strategy for equipment history workflows:
-- 1. Equipment detail dialog history display
-- 2. History filtering by event type
-- 3. Date-based history queries
-- 4. Performance optimization for history timeline

-- 1. PRIMARY HISTORY INDEXES

-- Equipment history filtering and sorting (most common query pattern)
CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_thiet_bi_id
ON lich_su_thiet_bi (thiet_bi_id);

-- Date-based sorting for history timeline
CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_ngay_thuc_hien
ON lich_su_thiet_bi (ngay_thuc_hien);

-- Composite index for equipment history queries with date sorting
-- This is the most important index for equipment detail dialog
CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_equipment_date
ON lich_su_thiet_bi (thiet_bi_id, ngay_thuc_hien DESC);

-- 2. EVENT TYPE FILTERING INDEXES

-- Event type filtering for history analysis
CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_loai_su_kien
ON lich_su_thiet_bi (loai_su_kien);

-- Composite index for event type and date filtering
CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_event_date
ON lich_su_thiet_bi (loai_su_kien, ngay_thuc_hien DESC);

-- 3. REQUEST TRACKING INDEXES

-- Request ID tracking for linking history to specific requests
CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_yeu_cau_id
ON lich_su_thiet_bi (yeu_cau_id)
WHERE yeu_cau_id IS NOT NULL;

-- Note: nguoi_thuc_hien_id column does not exist in lich_su_thiet_bi table
-- Table structure: id, thiet_bi_id, ngay_thuc_hien, loai_su_kien, mo_ta, chi_tiet, yeu_cau_id

-- 4. PERFORMANCE MONITORING

-- Create view to monitor index usage
CREATE OR REPLACE VIEW lich_su_thiet_bi_index_usage AS
SELECT
    schemaname,
    relname as tablename,
    indexrelname as indexname,
    idx_tup_read,
    idx_tup_fetch,
    idx_scan
FROM pg_stat_user_indexes
WHERE relname = 'lich_su_thiet_bi'
ORDER BY idx_scan DESC;

-- 5. INDEX COMMENTS FOR DOCUMENTATION

COMMENT ON INDEX idx_lich_su_thiet_bi_equipment_date IS 'Primary composite index for equipment history queries with date sorting';
COMMENT ON INDEX idx_lich_su_thiet_bi_event_date IS 'Composite index for event type and date filtering';
COMMENT ON INDEX idx_lich_su_thiet_bi_yeu_cau_id IS 'Partial index for request tracking (excludes NULL values)';
COMMENT ON VIEW lich_su_thiet_bi_index_usage IS 'Monitor index usage statistics for lich_su_thiet_bi table';

-- 6. USAGE EXAMPLES

/*
Common query patterns that will benefit from these indexes:

1. Equipment History Display (Equipment Detail Dialog):
   SELECT * FROM lich_su_thiet_bi
   WHERE thiet_bi_id = 123
   ORDER BY ngay_thuc_hien DESC
   -- Uses: idx_lich_su_thiet_bi_equipment_date

2. History by Event Type:
   SELECT * FROM lich_su_thiet_bi
   WHERE loai_su_kien = 'Luân chuyển'
   ORDER BY ngay_thuc_hien DESC
   -- Uses: idx_lich_su_thiet_bi_event_date

3. Equipment Transfer History:
   SELECT * FROM lich_su_thiet_bi
   WHERE thiet_bi_id = 123 AND loai_su_kien = 'Luân chuyển'
   ORDER BY ngay_thuc_hien DESC
   -- Uses: idx_lich_su_thiet_bi_equipment_date

4. Recent History Across All Equipment:
   SELECT * FROM lich_su_thiet_bi
   WHERE ngay_thuc_hien >= CURRENT_DATE - INTERVAL '30 days'
   ORDER BY ngay_thuc_hien DESC
   -- Uses: idx_lich_su_thiet_bi_ngay_thuc_hien

5. Request History Tracking:
   SELECT * FROM lich_su_thiet_bi
   WHERE yeu_cau_id = 456
   -- Uses: idx_lich_su_thiet_bi_yeu_cau_id

6. Event Type Analysis:
   SELECT loai_su_kien, COUNT(*)
   FROM lich_su_thiet_bi
   GROUP BY loai_su_kien
   -- Uses: idx_lich_su_thiet_bi_loai_su_kien

*/

-- 7. PERFORMANCE RECOMMENDATIONS

/*
Performance recommendations for lich_su_thiet_bi queries:

1. Always include thiet_bi_id in WHERE clause when querying specific equipment history
2. Use ORDER BY ngay_thuc_hien DESC for chronological sorting (matches index order)
3. Consider LIMIT clauses for large history datasets
4. Use partial indexes for optional fields (yeu_cau_id)
5. Monitor index usage with lich_su_thiet_bi_index_usage view
6. Consider archiving old history records if table grows too large

Index maintenance:
- VACUUM ANALYZE lich_su_thiet_bi regularly
- Monitor index bloat and rebuild if necessary
- Review query plans periodically with EXPLAIN ANALYZE

*/


-- =====================================================
-- 20241227_optimize_role_based_filtering.sql
-- =====================================================
-- OPTIMIZE ROLE-BASED EQUIPMENT FILTERING PERFORMANCE

-- This migration adds indexes specifically for role-based access control
-- filtering on the thiet_bi table, focusing on department-based filtering
-- with fuzzy matching support.

-- 1. FUZZY DEPARTMENT MATCHING INDEX

-- GIN index for fuzzy department matching using ILIKE queries
-- This supports the role-based filtering where users see equipment
-- from their department using partial/fuzzy matching
CREATE INDEX IF NOT EXISTS idx_thiet_bi_khoa_phong_quan_ly_fuzzy
ON thiet_bi USING gin (khoa_phong_quan_ly gin_trgm_ops);

-- 2. ROLE-BASED COMPOSITE INDEXES

-- Composite index for department + search queries
-- This optimizes queries that filter by department AND search text
-- Common in role-based equipment browsing with search
CREATE INDEX IF NOT EXISTS idx_thiet_bi_dept_search
ON thiet_bi USING gin (
  (khoa_phong_quan_ly || ' ' || ten_thiet_bi || ' ' || ma_thiet_bi) gin_trgm_ops
);

-- 3. PERFORMANCE MONITORING

-- Add comments for documentation
COMMENT ON INDEX idx_thiet_bi_khoa_phong_quan_ly_fuzzy IS 'GIN index for fuzzy department matching in role-based access control';
COMMENT ON INDEX idx_thiet_bi_dept_search IS 'Composite GIN index for department-filtered equipment search';

-- 4. QUERY OPTIMIZATION EXAMPLES

/*
OPTIMIZED QUERIES WITH NEW INDEXES:

1. Role-based department filtering (fuzzy match):
   SELECT * FROM thiet_bi 
   WHERE khoa_phong_quan_ly ILIKE '%Khoa Nội%'
   -- Uses: idx_thiet_bi_khoa_phong_quan_ly_fuzzy

2. Role-based department filtering with search:
   SELECT * FROM thiet_bi 
   WHERE khoa_phong_quan_ly ILIKE '%Khoa Nội%'
   AND (ten_thiet_bi ILIKE '%máy%' OR ma_thiet_bi ILIKE '%TB001%')
   -- Uses: idx_thiet_bi_dept_search

3. Admin/manager queries (no department filter):
   SELECT * FROM thiet_bi 
   WHERE ten_thiet_bi ILIKE '%máy%' OR ma_thiet_bi ILIKE '%TB001%'
   -- Uses: existing idx_thiet_bi_search_text

4. Department + status filtering:
   SELECT * FROM thiet_bi 
   WHERE khoa_phong_quan_ly ILIKE '%Khoa Nội%'
   AND tinh_trang_hien_tai = 'Hoạt động bình thường'
   -- Uses: existing idx_thiet_bi_dept_status (for exact matches)
   -- Uses: idx_thiet_bi_khoa_phong_quan_ly_fuzzy (for fuzzy matches)
*/

-- 5. INDEX USAGE MONITORING

-- Create view to monitor role-based filtering performance
CREATE OR REPLACE VIEW role_based_filtering_stats AS
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as scans,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched
FROM pg_stat_user_indexes 
WHERE tablename = 'thiet_bi' 
AND indexname IN (
    'idx_thiet_bi_khoa_phong_quan_ly',
    'idx_thiet_bi_khoa_phong_quan_ly_fuzzy',
    'idx_thiet_bi_dept_search',
    'idx_thiet_bi_search_text'
)
ORDER BY idx_scan DESC;

COMMENT ON VIEW role_based_filtering_stats IS 'Monitor index usage for role-based equipment filtering queries';


-- =====================================================
-- 20241227_simple_check.sql
-- =====================================================
-- SIMPLE TRANSFER HISTORY CHECK

-- Quick check to verify migration readiness

-- 1. Count completed transfers
SELECT 
    'Total completed transfers' as description,
    COUNT(*) as count
FROM yeu_cau_luan_chuyen 
WHERE trang_thai = 'hoan_thanh';

-- 2. Count existing transfer history
SELECT 
    'Existing transfer history in lich_su_thiet_bi' as description,
    COUNT(*) as count
FROM lich_su_thiet_bi 
WHERE loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý');

-- 3. Count missing transfer history
SELECT 
    'Missing transfer history (will be migrated)' as description,
    COUNT(*) as count
FROM yeu_cau_luan_chuyen ylc
WHERE ylc.trang_thai = 'hoan_thanh'
  AND NOT EXISTS (
      SELECT 1 
      FROM lich_su_thiet_bi lstb 
      WHERE lstb.yeu_cau_id = ylc.id 
        AND lstb.loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý')
  );

-- 4. Show sample transfers to be migrated
SELECT 
    ylc.id,
    ylc.ma_yeu_cau,
    ylc.loai_hinh,
    ylc.trang_thai,
    ylc.created_at,
    ylc.ngay_hoan_thanh,
    -- Check if history exists
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM lich_su_thiet_bi lstb 
            WHERE lstb.yeu_cau_id = ylc.id 
              AND lstb.loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý')
        ) THEN 'HAS_HISTORY'
        ELSE 'MISSING_HISTORY'
    END as history_status
FROM yeu_cau_luan_chuyen ylc
WHERE ylc.trang_thai = 'hoan_thanh'
ORDER BY ylc.created_at DESC;

-- 5. Breakdown by transfer type
SELECT 
    ylc.loai_hinh,
    COUNT(*) as total_completed,
    SUM(CASE 
        WHEN EXISTS (
            SELECT 1 FROM lich_su_thiet_bi lstb 
            WHERE lstb.yeu_cau_id = ylc.id 
              AND lstb.loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý')
        ) THEN 1 ELSE 0 
    END) as has_history,
    SUM(CASE 
        WHEN NOT EXISTS (
            SELECT 1 FROM lich_su_thiet_bi lstb 
            WHERE lstb.yeu_cau_id = ylc.id 
              AND lstb.loai_su_kien IN ('Luân chuyển nội bộ', 'Luân chuyển bên ngoài', 'Thanh lý')
        ) THEN 1 ELSE 0 
    END) as missing_history
FROM yeu_cau_luan_chuyen ylc
WHERE ylc.trang_thai = 'hoan_thanh'
GROUP BY ylc.loai_hinh
ORDER BY ylc.loai_hinh;

-- 6. Check equipment references
SELECT 
    'Equipment reference check' as description,
    COUNT(*) as count
FROM yeu_cau_luan_chuyen ylc
LEFT JOIN thiet_bi tb ON tb.id = ylc.thiet_bi_id
WHERE ylc.trang_thai = 'hoan_thanh'
  AND tb.id IS NULL;


-- =====================================================
-- 20241228_add_created_at_to_thiet_bi.sql
-- =====================================================
-- ADD CREATED_AT COLUMN TO THIET_BI TABLE

-- This migration adds created_at column to track when equipment records
-- are added to the system (different from ngay_nhap which is the actual
-- equipment import date into inventory)

-- Add created_at column with default value for new records
ALTER TABLE thiet_bi 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW();

-- Set created_at for existing records to a reasonable default
-- Use ngay_nhap if available, otherwise use a default date
UPDATE thiet_bi 
SET created_at = COALESCE(
    ngay_nhap::timestamptz, 
    '2024-01-01 00:00:00+00'::timestamptz
)
WHERE created_at IS NULL;

-- Make created_at NOT NULL after setting values for existing records
ALTER TABLE thiet_bi 
ALTER COLUMN created_at SET NOT NULL;

-- Add comment to explain the column purpose
COMMENT ON COLUMN thiet_bi.created_at IS 'Thời gian bản ghi thiết bị được tạo trong hệ thống (khác với ngay_nhap là ngày nhập thiết bị vào kho thực tế)';

-- Create index for performance on created_at queries (for reports)
CREATE INDEX IF NOT EXISTS idx_thiet_bi_created_at 
ON thiet_bi (created_at);

COMMENT ON INDEX idx_thiet_bi_created_at IS 'Index for equipment creation date queries in reports';


-- =====================================================
-- 20241228_add_repair_unit_fields.sql
-- =====================================================
-- ADD REPAIR UNIT FIELDS TO YEU_CAU_SUA_CHUA TABLE

-- This migration adds fields to track repair execution unit:
-- - don_vi_thuc_hien: Internal or external repair
-- - ten_don_vi_thue: Name of external repair company (when applicable)

-- 1. BACKUP AND VERIFICATION

-- Create backup table for safety
CREATE TABLE IF NOT EXISTS yeu_cau_sua_chua_backup_20241228 AS 
SELECT * FROM yeu_cau_sua_chua WHERE 1=0; -- Empty structure

-- Insert current data as backup
INSERT INTO yeu_cau_sua_chua_backup_20241228 
SELECT * FROM yeu_cau_sua_chua;

-- Log migration start
DO $$
BEGIN
    RAISE NOTICE 'Starting repair unit fields migration at %', NOW();
    RAISE NOTICE 'Backup created: yeu_cau_sua_chua_backup_20241228';
END $$;

-- 2. ADD NEW COLUMNS

-- Add repair execution unit field
ALTER TABLE yeu_cau_sua_chua 
ADD COLUMN IF NOT EXISTS don_vi_thuc_hien VARCHAR(20) 
CHECK (don_vi_thuc_hien IN ('noi_bo', 'thue_ngoai')) 
DEFAULT 'noi_bo';

-- Add external repair company name field
ALTER TABLE yeu_cau_sua_chua 
ADD COLUMN IF NOT EXISTS ten_don_vi_thue TEXT;

-- 3. ADD COMMENTS FOR DOCUMENTATION

COMMENT ON COLUMN yeu_cau_sua_chua.don_vi_thuc_hien IS 'Đơn vị thực hiện sửa chữa: noi_bo (nội bộ), thue_ngoai (thuê ngoài)';
COMMENT ON COLUMN yeu_cau_sua_chua.ten_don_vi_thue IS 'Tên đơn vị được thuê sửa chữa (chỉ khi don_vi_thuc_hien = thue_ngoai)';

-- 4. CREATE INDEXES FOR PERFORMANCE

-- Index for filtering by repair unit type
CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_don_vi_thuc_hien 
ON yeu_cau_sua_chua(don_vi_thuc_hien);

-- Composite index for external repair queries
CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_external_repair 
ON yeu_cau_sua_chua(don_vi_thuc_hien, ten_don_vi_thue) 
WHERE don_vi_thuc_hien = 'thue_ngoai';

-- 5. UPDATE EXISTING RECORDS

-- Set all existing records to 'noi_bo' (internal repair) as default
UPDATE yeu_cau_sua_chua 
SET don_vi_thuc_hien = 'noi_bo' 
WHERE don_vi_thuc_hien IS NULL;

-- 6. VERIFICATION AND LOGGING

-- Log migration results
DO $$
DECLARE
    total_records INTEGER;
    internal_records INTEGER;
    external_records INTEGER;
BEGIN
    -- Count total records
    SELECT COUNT(*) INTO total_records FROM yeu_cau_sua_chua;
    
    -- Count by repair unit type
    SELECT COUNT(*) INTO internal_records 
    FROM yeu_cau_sua_chua WHERE don_vi_thuc_hien = 'noi_bo';
    
    SELECT COUNT(*) INTO external_records 
    FROM yeu_cau_sua_chua WHERE don_vi_thuc_hien = 'thue_ngoai';
    
    RAISE NOTICE 'Migration completed at %', NOW();
    RAISE NOTICE 'Total repair requests: %', total_records;
    RAISE NOTICE 'Internal repair requests: %', internal_records;
    RAISE NOTICE 'External repair requests: %', external_records;
    RAISE NOTICE 'SUCCESS: Repair unit fields added successfully';
END $$;

-- 7. CLEANUP INSTRUCTIONS

/*
CLEANUP INSTRUCTIONS (run after verification):

-- If migration is successful and verified, you can drop the backup table:
-- DROP TABLE yeu_cau_sua_chua_backup_20241228;

-- If you need to rollback the migration:
-- ALTER TABLE yeu_cau_sua_chua DROP COLUMN IF EXISTS don_vi_thuc_hien;
-- ALTER TABLE yeu_cau_sua_chua DROP COLUMN IF EXISTS ten_don_vi_thue;
-- DROP INDEX IF EXISTS idx_yeu_cau_sua_chua_don_vi_thuc_hien;
-- DROP INDEX IF EXISTS idx_yeu_cau_sua_chua_external_repair;

VERIFICATION QUERIES:

-- Check column structure:
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'yeu_cau_sua_chua' 
  AND column_name IN ('don_vi_thuc_hien', 'ten_don_vi_thue');

-- Check data distribution:
SELECT 
    don_vi_thuc_hien,
    COUNT(*) as count,
    COUNT(ten_don_vi_thue) as with_company_name
FROM yeu_cau_sua_chua 
GROUP BY don_vi_thuc_hien;

-- Check indexes:
SELECT indexname, indexdef 
FROM pg_indexes 
WHERE tablename = 'yeu_cau_sua_chua' 
  AND indexname LIKE '%don_vi%';
*/


-- =====================================================
-- 20241228_optimize_remaining_indexes.sql
-- =====================================================
-- COMPREHENSIVE INDEX OPTIMIZATION - REMAINING TABLES

-- Focus on tables mentioned in code but missing comprehensive indexes:
-- 1. thiet_bi (Equipment) 
-- 2. yeu_cau_sua_chua (Repair Requests)
-- 3. cong_viec_bao_tri (Maintenance Work) - Updated from lich_bao_tri
-- 4. ke_hoach_bao_tri (Maintenance Plans)
-- 5. yeu_cau_luan_chuyen (Transfer Requests)
-- 6. lich_su_thiet_bi (Equipment History)
-- 7. nhan_vien (Staff)

-- This migration creates production-ready indexes with careful consideration for:
-- - Query patterns observed in the codebase
-- - Composite indexes for complex filtering
-- - Text search capabilities
-- - Performance monitoring

-- 1. EQUIPMENT INDEXES (thiet_bi)

-- Basic single-column indexes for filtering
CREATE INDEX IF NOT EXISTS idx_thiet_bi_ma_thiet_bi
ON thiet_bi (ma_thiet_bi);

CREATE INDEX IF NOT EXISTS idx_thiet_bi_trang_thai
ON thiet_bi (trang_thai);

CREATE INDEX IF NOT EXISTS idx_thiet_bi_phong_ban_id
ON thiet_bi (phong_ban_id);

CREATE INDEX IF NOT EXISTS idx_thiet_bi_loai_thiet_bi
ON thiet_bi (loai_thiet_bi);

CREATE INDEX IF NOT EXISTS idx_thiet_bi_ngay_cap_nhat
ON thiet_bi (ngay_cap_nhat);

CREATE INDEX IF NOT EXISTS idx_thiet_bi_khoa_phong_quan_ly
ON thiet_bi (khoa_phong_quan_ly);

-- Composite indexes for common query patterns
CREATE INDEX IF NOT EXISTS idx_thiet_bi_status_department
ON thiet_bi (trang_thai, phong_ban_id);

CREATE INDEX IF NOT EXISTS idx_thiet_bi_department_type
ON thiet_bi (phong_ban_id, loai_thiet_bi);

CREATE INDEX IF NOT EXISTS idx_thiet_bi_status_update_date
ON thiet_bi (trang_thai, ngay_cap_nhat DESC);

-- Full-text search index
CREATE INDEX IF NOT EXISTS idx_thiet_bi_search_text
ON thiet_bi USING gin (
    (setweight(to_tsvector('vietnamese', COALESCE(ma_thiet_bi, '')), 'A') ||
     setweight(to_tsvector('vietnamese', COALESCE(ten_thiet_bi, '')), 'B') ||
     setweight(to_tsvector('vietnamese', COALESCE(mo_ta, '')), 'C'))
);

-- 2. REPAIR REQUESTS INDEXES (yeu_cau_sua_chua)

-- Core business logic indexes
CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_thiet_bi_id
ON yeu_cau_sua_chua (thiet_bi_id);

CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_trang_thai
ON yeu_cau_sua_chua (trang_thai);

CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_muc_do_uu_tien
ON yeu_cau_sua_chua (muc_do_uu_tien);

CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_ngay_yeu_cau
ON yeu_cau_sua_chua (ngay_yeu_cau);

CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_nguoi_yeu_cau
ON yeu_cau_sua_chua (nguoi_yeu_cau);

-- High-performance composite indexes
CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_equipment_status
ON yeu_cau_sua_chua (thiet_bi_id, trang_thai, ngay_yeu_cau DESC);

CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_status_priority_date
ON yeu_cau_sua_chua (trang_thai, muc_do_uu_tien, ngay_yeu_cau DESC);

-- Text search for problem descriptions
CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_search_text
ON yeu_cau_sua_chua USING gin (
    (setweight(to_tsvector('vietnamese', COALESCE(mo_ta_su_co, '')), 'A') ||
     setweight(to_tsvector('vietnamese', COALESCE(ghi_chu, '')), 'B'))
);

-- 3. MAINTENANCE WORK INDEXES (cong_viec_bao_tri)

-- Basic indexes for maintenance work
CREATE INDEX IF NOT EXISTS idx_cong_viec_bao_tri_thiet_bi_id
ON cong_viec_bao_tri (thiet_bi_id);

CREATE INDEX IF NOT EXISTS idx_cong_viec_bao_tri_ke_hoach_id
ON cong_viec_bao_tri (ke_hoach_id);

CREATE INDEX IF NOT EXISTS idx_cong_viec_bao_tri_loai_cong_viec
ON cong_viec_bao_tri (loai_cong_viec);

-- Composite indexes for maintenance work queries
CREATE INDEX IF NOT EXISTS idx_cong_viec_bao_tri_equipment_plan
ON cong_viec_bao_tri (thiet_bi_id, ke_hoach_id);

CREATE INDEX IF NOT EXISTS idx_cong_viec_bao_tri_plan_type
ON cong_viec_bao_tri (ke_hoach_id, loai_cong_viec);

-- Text search index for maintenance work
CREATE INDEX IF NOT EXISTS idx_cong_viec_bao_tri_search_text
ON cong_viec_bao_tri USING gin (
    (setweight(to_tsvector('vietnamese', COALESCE(ten_cong_viec, '')), 'A') ||
     setweight(to_tsvector('vietnamese', COALESCE(mo_ta, '')), 'B'))
);

-- 4. MAINTENANCE PLANS INDEXES (ke_hoach_bao_tri)

-- Essential plan management indexes
CREATE INDEX IF NOT EXISTS idx_ke_hoach_bao_tri_nam
ON ke_hoach_bao_tri (nam);

CREATE INDEX IF NOT EXISTS idx_ke_hoach_bao_tri_trang_thai
ON ke_hoach_bao_tri (trang_thai);

CREATE INDEX IF NOT EXISTS idx_ke_hoach_bao_tri_loai_cong_viec
ON ke_hoach_bao_tri (loai_cong_viec);

CREATE INDEX IF NOT EXISTS idx_ke_hoach_bao_tri_khoa_phong
ON ke_hoach_bao_tri (khoa_phong);

-- Composite indexes for plan filtering
CREATE INDEX IF NOT EXISTS idx_ke_hoach_bao_tri_year_status
ON ke_hoach_bao_tri (nam DESC, trang_thai);

CREATE INDEX IF NOT EXISTS idx_ke_hoach_bao_tri_status_type
ON ke_hoach_bao_tri (trang_thai, loai_cong_viec);

-- 5. TRANSFER REQUESTS INDEXES (yeu_cau_luan_chuyen)

-- Core transfer request indexes
CREATE INDEX IF NOT EXISTS idx_yeu_cau_luan_chuyen_thiet_bi_id
ON yeu_cau_luan_chuyen (thiet_bi_id);

CREATE INDEX IF NOT EXISTS idx_yeu_cau_luan_chuyen_phong_ban_hien_tai
ON yeu_cau_luan_chuyen (phong_ban_hien_tai);

CREATE INDEX IF NOT EXISTS idx_yeu_cau_luan_chuyen_phong_ban_moi
ON yeu_cau_luan_chuyen (phong_ban_moi);

CREATE INDEX IF NOT EXISTS idx_yeu_cau_luan_chuyen_trang_thai
ON yeu_cau_luan_chuyen (trang_thai);

CREATE INDEX IF NOT EXISTS idx_yeu_cau_luan_chuyen_ngay_yeu_cau
ON yeu_cau_luan_chuyen (ngay_yeu_cau);

-- Composite indexes for transfer workflows
CREATE INDEX IF NOT EXISTS idx_yeu_cau_luan_chuyen_equipment_status
ON yeu_cau_luan_chuyen (thiet_bi_id, trang_thai);

CREATE INDEX IF NOT EXISTS idx_yeu_cau_luan_chuyen_department_transfer
ON yeu_cau_luan_chuyen (phong_ban_hien_tai, phong_ban_moi, trang_thai);

-- 6. EQUIPMENT HISTORY INDEXES (lich_su_thiet_bi)

-- Equipment history tracking
CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_thiet_bi_id
ON lich_su_thiet_bi (thiet_bi_id);

CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_loai_su_kien
ON lich_su_thiet_bi (loai_su_kien);

CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_ngay_su_kien
ON lich_su_thiet_bi (ngay_su_kien);

-- Composite for equipment timeline queries
CREATE INDEX IF NOT EXISTS idx_lich_su_thiet_bi_equipment_timeline
ON lich_su_thiet_bi (thiet_bi_id, ngay_su_kien DESC);

-- 7. STAFF INDEXES (nhan_vien)

-- Note: Only using columns that are confirmed to exist in nhan_vien table
-- Department filtering (for role-based access)
CREATE INDEX IF NOT EXISTS idx_nhan_vien_khoa_phong
ON nhan_vien (khoa_phong);

-- Role/position filtering (if chuc_vu column exists)
CREATE INDEX IF NOT EXISTS idx_nhan_vien_chuc_vu
ON nhan_vien (chuc_vu);

-- Text search for staff names
CREATE INDEX IF NOT EXISTS idx_nhan_vien_search_text
ON nhan_vien USING gin (
    (setweight(to_tsvector('vietnamese', COALESCE(ho_ten, '')), 'A') ||
     setweight(to_tsvector('vietnamese', COALESCE(email, '')), 'B'))
);

-- 8. PERFORMANCE MONITORING AND ANALYSIS

-- Analyze tables to update statistics after index creation


-- Create comprehensive monitoring view
CREATE OR REPLACE VIEW index_performance_summary AS
SELECT 
    schemaname,
    tablename,
    indexrelname,
    idx_scan,
    pg_size_pretty(pg_relation_size(indexrelname::regclass)) as index_size,
    CASE
        WHEN idx_scan = 0 THEN 'UNUSED'
        WHEN idx_scan < 100 THEN 'LOW'
        WHEN idx_scan < 1000 THEN 'MEDIUM'
        ELSE 'HIGH'
    END as usage_level
FROM pg_stat_user_indexes
WHERE tablename IN ('thiet_bi', 'yeu_cau_sua_chua', 'ke_hoach_bao_tri', 'cong_viec_bao_tri', 'yeu_cau_luan_chuyen', 'lich_su_thiet_bi', 'nhan_vien')
ORDER BY tablename, idx_scan DESC;

-- Index size summary
CREATE OR REPLACE VIEW index_size_summary AS
SELECT 
    tablename,
    COUNT(*) as index_count,
    pg_size_pretty(SUM(pg_relation_size(indexrelname::regclass))) as total_index_size
FROM pg_stat_user_indexes
WHERE tablename IN ('thiet_bi', 'yeu_cau_sua_chua', 'ke_hoach_bao_tri', 'cong_viec_bao_tri', 'yeu_cau_luan_chuyen', 'lich_su_thiet_bi', 'nhan_vien')
GROUP BY tablename
ORDER BY SUM(pg_relation_size(indexrelname::regclass)) DESC;

-- 9. INDEX COMMENTS FOR DOCUMENTATION

COMMENT ON INDEX idx_thiet_bi_search_text IS 'Full-text search index for equipment names and descriptions';
COMMENT ON INDEX idx_yeu_cau_sua_chua_equipment_status IS 'High-performance composite index for repair request queries';
COMMENT ON INDEX idx_cong_viec_bao_tri_equipment_plan IS 'Composite index for maintenance work equipment and plan queries';
COMMENT ON INDEX idx_ke_hoach_bao_tri_year_status IS 'Optimized index for maintenance plan filtering by year and status';
COMMENT ON INDEX idx_yeu_cau_luan_chuyen_department_transfer IS 'Complex composite for transfer request workflow queries';

-- 10. PERFORMANCE TEST QUERIES

/*
Test these key queries after migration:

-- Equipment searches
SELECT * FROM thiet_bi 
WHERE trang_thai = 'Hoạt động' AND phong_ban_id = 1 
ORDER BY ngay_cap_nhat DESC;

-- Repair request queries
SELECT * FROM yeu_cau_sua_chua 
WHERE thiet_bi_id = 1 AND trang_thai = 'Chờ xử lý' 
ORDER BY ngay_yeu_cau DESC;

-- Maintenance work queries
SELECT * FROM cong_viec_bao_tri
WHERE thiet_bi_id = 1 AND ke_hoach_id = 1;
-- Uses: idx_cong_viec_bao_tri_equipment_plan

-- Maintenance plan filtering
SELECT * FROM ke_hoach_bao_tri 
WHERE nam = 2024 AND trang_thai = 'Đã duyệt'
ORDER BY created_at DESC;

-- Transfer request workflow
SELECT * FROM yeu_cau_luan_chuyen 
WHERE phong_ban_hien_tai = 1 AND phong_ban_moi = 2 AND trang_thai = 'Chờ duyệt';

-- Text search examples
SELECT * FROM thiet_bi 
WHERE to_tsvector('vietnamese', ten_thiet_bi || ' ' || COALESCE(mo_ta, '')) 
@@ plainto_tsquery('vietnamese', 'máy đo huyết áp');

SELECT * FROM yeu_cau_sua_chua 
WHERE to_tsvector('vietnamese', mo_ta_su_co) @@ plainto_tsquery('vietnamese', 'hỏng điện');

-- Staff queries (only using confirmed columns)
SELECT * FROM nhan_vien WHERE khoa_phong = 'Khoa Nội';
SELECT * FROM nhan_vien WHERE ho_ten ILIKE '%Nguyễn%';
*/


-- =====================================================
-- 20241228_safe_indexes_only.sql
-- =====================================================
-- SAFE INDEXES ONLY - VERIFIED COLUMNS

-- This migration creates only indexes for columns that are confirmed to exist
-- Based on actual code analysis and avoiding any risky assumptions

-- 1. REPAIR REQUESTS INDEXES (yeu_cau_sua_chua)

-- Only create indexes for columns we know exist from the code

-- Status filtering (confirmed from code)
CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_trang_thai
ON yeu_cau_sua_chua (trang_thai);

-- Equipment reference for JOINs (confirmed from code)
CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_thiet_bi_id
ON yeu_cau_sua_chua (thiet_bi_id);

-- Date filtering (confirmed from code)
CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_ngay_yeu_cau
ON yeu_cau_sua_chua (ngay_yeu_cau);

CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_ngay_hoan_thanh
ON yeu_cau_sua_chua (ngay_hoan_thanh);

-- Requester filtering (confirmed from code - TEXT field)
CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_nguoi_yeu_cau
ON yeu_cau_sua_chua (nguoi_yeu_cau);

-- Text search on description only (confirmed column)
CREATE INDEX IF NOT EXISTS idx_yeu_cau_sua_chua_mo_ta_trgm
ON yeu_cau_sua_chua USING gin (mo_ta_su_co gin_trgm_ops);

-- 2. MAINTENANCE PLANS INDEXES (ke_hoach_bao_tri)

-- Year filtering
CREATE INDEX IF NOT EXISTS idx_ke_hoach_bao_tri_nam
ON ke_hoach_bao_tri (nam);

-- Status filtering
CREATE INDEX IF NOT EXISTS idx_ke_hoach_bao_tri_trang_thai
ON ke_hoach_bao_tri (trang_thai);

-- Creation date
CREATE INDEX IF NOT EXISTS idx_ke_hoach_bao_tri_created_at
ON ke_hoach_bao_tri (created_at);

-- 3. MAINTENANCE WORK INDEXES (cong_viec_bao_tri)

-- Equipment reference
CREATE INDEX IF NOT EXISTS idx_cong_viec_bao_tri_thiet_bi_id
ON cong_viec_bao_tri (thiet_bi_id);

-- Plan reference
CREATE INDEX IF NOT EXISTS idx_cong_viec_bao_tri_ke_hoach_id
ON cong_viec_bao_tri (ke_hoach_id);

-- Work type filtering
CREATE INDEX IF NOT EXISTS idx_cong_viec_bao_tri_loai_cong_viec
ON cong_viec_bao_tri (loai_cong_viec);

-- Composite index for equipment + plan queries
CREATE INDEX IF NOT EXISTS idx_cong_viec_bao_tri_equipment_plan
ON cong_viec_bao_tri (thiet_bi_id, ke_hoach_id);

-- 4. STAFF INDEXES (nhan_vien)

-- Department filtering (for role-based access)
-- Note: Only using columns that are confirmed to exist
CREATE INDEX IF NOT EXISTS idx_nhan_vien_khoa_phong
ON nhan_vien (khoa_phong);

-- Name search (confirmed column)
CREATE INDEX IF NOT EXISTS idx_nhan_vien_ho_ten_trgm
ON nhan_vien USING gin (ho_ten gin_trgm_ops);

-- 5. PERFORMANCE MONITORING

-- Create simple index usage monitoring view
CREATE OR REPLACE VIEW safe_index_usage AS
SELECT
    schemaname,
    relname as tablename,
    indexrelname as indexname,
    idx_scan,
    CASE
        WHEN idx_scan = 0 THEN 'UNUSED'
        WHEN idx_scan < 100 THEN 'LOW_USAGE'
        WHEN idx_scan < 1000 THEN 'MEDIUM_USAGE'
        ELSE 'HIGH_USAGE'
    END as usage_level
FROM pg_stat_user_indexes
WHERE relname IN ('yeu_cau_sua_chua', 'cong_viec_bao_tri', 'ke_hoach_bao_tri', 'nhan_vien')
ORDER BY relname, idx_scan DESC;

-- 6. INDEX COMMENTS

COMMENT ON INDEX idx_yeu_cau_sua_chua_mo_ta_trgm IS 'GIN index for text search on repair request descriptions';
COMMENT ON INDEX idx_cong_viec_bao_tri_equipment_plan IS 'Composite index for maintenance work queries';
COMMENT ON INDEX idx_nhan_vien_khoa_phong IS 'Index for role-based access control';
COMMENT ON VIEW safe_index_usage IS 'Monitor usage of safe indexes';

-- 7. VERIFICATION QUERIES

/*
To verify these indexes work, run:

-- Check repair request filtering
EXPLAIN ANALYZE SELECT * FROM yeu_cau_sua_chua WHERE trang_thai = 'Chờ xử lý';

-- Check maintenance work by equipment
EXPLAIN ANALYZE SELECT * FROM cong_viec_bao_tri WHERE thiet_bi_id = 1 AND ke_hoach_id = 1;

-- Check department filtering
EXPLAIN ANALYZE SELECT * FROM nhan_vien WHERE khoa_phong = 'Khoa Nội';

-- Check text search
EXPLAIN ANALYZE SELECT * FROM yeu_cau_sua_chua WHERE mo_ta_su_co ILIKE '%máy%';
*/


-- =====================================================
-- 20241229_enable_realtime_for_custom_auth.sql
-- =====================================================
-- ENABLE REALTIME FOR CUSTOM AUTH SYSTEM
-- Date: 2024-12-29  
-- Purpose: Enable Realtime Publications cho custom authentication system
-- Actions: 
--   1. Enable Realtime Publications cho 9 tables chính
--   2. Grant permissions cho anon role (để custom auth hoạt động)
--   3. Verify RLS status (should be disabled for custom auth)

-- SECTION 1: VERIFY RLS STATUS (Should be disabled for custom auth)

-- Check RLS status - should all be false for custom auth
SELECT 
    'RLS STATUS CHECK' as check_type,
    schemaname,
    tablename,
    rowsecurity as rls_enabled,
    CASE 
        WHEN rowsecurity = false THEN '✅ CORRECT - RLS disabled for custom auth'
        ELSE '⚠️ WARNING - RLS enabled, may conflict with custom auth'
    END as status
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN (
    'thiet_bi',
    'nhan_vien', 
    'nhat_ky_su_dung',
    'lich_su_thiet_bi',
    'yeu_cau_luan_chuyen',
    'lich_su_luan_chuyen',
    'ke_hoach_bao_tri',
    'cong_viec_bao_tri',
    'yeu_cau_sua_chua'
)
ORDER BY tablename;

-- SECTION 2: ENABLE Realtime Publications

-- Enable realtime cho 9 tables chính
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS thiet_bi;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS nhan_vien;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS nhat_ky_su_dung;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS lich_su_thiet_bi;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS yeu_cau_luan_chuyen;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS lich_su_luan_chuyen;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS ke_hoach_bao_tri;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS cong_viec_bao_tri;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS yeu_cau_sua_chua;

-- SECTION 3: Grant permissions cho Custom Auth System

-- Grant permissions cho anon role (vì app sử dụng anon key với custom auth)
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT SELECT ON realtime.messages TO anon;

-- Grant full access cho các bảng chính với anon role (cho custom auth)
GRANT ALL ON thiet_bi TO anon;
GRANT ALL ON nhan_vien TO anon; 
GRANT ALL ON nhat_ky_su_dung TO anon;
GRANT ALL ON lich_su_thiet_bi TO anon;
GRANT ALL ON yeu_cau_luan_chuyen TO anon;
GRANT ALL ON lich_su_luan_chuyen TO anon;
GRANT ALL ON ke_hoach_bao_tri TO anon;
GRANT ALL ON cong_viec_bao_tri TO anon;
GRANT ALL ON yeu_cau_sua_chua TO anon;

-- Grant sequence permissions
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon;

-- SECTION 4: Verify Realtime Publications

-- Kiểm tra publications đã được enable
SELECT 
    'REALTIME PUBLICATIONS VERIFICATION' as check_type,
    COUNT(*) as enabled_tables,
    CASE 
        WHEN COUNT(*) = 9 THEN '✅ PERFECT - All 9 tables enabled!'
        WHEN COUNT(*) > 0 THEN '⚠️ PARTIAL - Only ' || COUNT(*) || '/9 tables'
        ELSE '❌ FAILED - No tables enabled'
    END as status
FROM pg_publication_tables 
WHERE pubname = 'supabase_realtime'
AND tablename IN (
    'thiet_bi', 'nhan_vien', 'nhat_ky_su_dung', 'lich_su_thiet_bi',
    'yeu_cau_luan_chuyen', 'lich_su_luan_chuyen', 'ke_hoach_bao_tri',
    'cong_viec_bao_tri', 'yeu_cau_sua_chua'
);

-- List all enabled tables
SELECT 
    'ENABLED TABLES' as check_type,
    tablename,
    '✅ Realtime enabled' as status
FROM pg_publication_tables 
WHERE pubname = 'supabase_realtime'
AND tablename IN (
    'thiet_bi', 'nhan_vien', 'nhat_ky_su_dung', 'lich_su_thiet_bi',
    'yeu_cau_luan_chuyen', 'lich_su_luan_chuyen', 'ke_hoach_bao_tri',
    'cong_viec_bao_tri', 'yeu_cau_sua_chua'
)
ORDER BY tablename;

-- SUCCESS MESSAGE

DO $$
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '🚀 REALTIME ENABLED FOR CUSTOM AUTH!';
    RAISE NOTICE '';
    RAISE NOTICE '✅ Realtime Publications enabled for 9 tables';
    RAISE NOTICE '🔑 Permissions granted for anon role (custom auth)';
    RAISE NOTICE '🔓 Custom auth system will work with realtime';
    RAISE NOTICE '';
    RAISE NOTICE '📋 ENABLED TABLES:';
    RAISE NOTICE '   - thiet_bi (Equipment)';
    RAISE NOTICE '   - nhan_vien (Staff)';
    RAISE NOTICE '   - nhat_ky_su_dung (Usage Logs)';
    RAISE NOTICE '   - lich_su_thiet_bi (Equipment History)';
    RAISE NOTICE '   - yeu_cau_luan_chuyen (Transfer Requests)';
    RAISE NOTICE '   - lich_su_luan_chuyen (Transfer History)';
    RAISE NOTICE '   - ke_hoach_bao_tri (Maintenance Plans)';
    RAISE NOTICE '   - cong_viec_bao_tri (Maintenance Tasks)';
    RAISE NOTICE '   - yeu_cau_sua_chua (Repair Requests)';
    RAISE NOTICE '';
    RAISE NOTICE '🎯 NEXT STEPS:';
    RAISE NOTICE '   1. Test realtime subscriptions in app';
    RAISE NOTICE '   2. Verify instant data updates';
    RAISE NOTICE '   3. Monitor performance';
    RAISE NOTICE '';
    RAISE NOTICE '⚠️ NOTE: Security handled by custom auth layer';
END $$;


-- =====================================================
-- DỮ LIỆU MẪU CHO Bệnh viện ABC
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
('BỆNH_VIỆN__001', 'Máy siêu âm tim', 'Vivid E95', 'VE95001', 'GE Healthcare', 'Mỹ', 2024, 'Khoa Nội', 'Phòng khám tim mạch', 'BS. Nguyễn Văn A', 'Hoạt động', CURRENT_DATE - INTERVAL '1 year', CURRENT_DATE - INTERVAL '11 months', 'Ngân sách nhà nước', 2500000000, CURRENT_DATE + INTERVAL '1 year', 'Màn hình LCD 19 inch, đầu dò tim mạch', 'Gel siêu âm, túi đựng đầu dò', 'Thiết bị hoạt động tốt', 6, CURRENT_DATE + INTERVAL '3 months'),
('BỆNH_VIỆN__002', 'Máy điện tim 12 cần', 'MAC 2000', 'MAC2000002', 'GE Healthcare', 'Mỹ', 2025, 'Khoa Nội', 'Phòng khám tim mạch', 'BS. Nguyễn Văn A', 'Hoạt động', CURRENT_DATE - INTERVAL '6 months', CURRENT_DATE - INTERVAL '5 months', 'Ngân sách nhà nước', 150000000, CURRENT_DATE + INTERVAL '18 months', 'Máy in nhiệt, 12 cần đo', 'Giấy in ECG, cáp kết nối', 'Thiết bị mới', 3, CURRENT_DATE + INTERVAL '1 month'),

-- Thiết bị CĐHA
('BỆNH_VIỆN__003', 'Máy X-quang kỹ thuật số', 'Ysio Max', 'YM2021003', 'Siemens', 'Đức', 2023, 'Phòng Chẩn đoán hình ảnh', 'Phòng X-quang 1', 'KTV. Trần Thị B', 'Hoạt động', CURRENT_DATE - INTERVAL '2 years', CURRENT_DATE - INTERVAL '23 months', 'Vốn ODA', 3500000000, CURRENT_DATE + INTERVAL '6 months', 'Detector phẳng 43x43cm, bàn chụp di động', 'Áo chì bảo vệ, marker kim loại', 'Cần hiệu chuẩn định kỳ', 12, CURRENT_DATE + INTERVAL '2 months'),
('BỆNH_VIỆN__004', 'Máy CT 64 lát cắt', 'SOMATOM go.Top', 'SGT2023004', 'Siemens', 'Đức', 2024, 'Phòng Chẩn đoán hình ảnh', 'Phòng CT', 'KTV. Trần Thị B', 'Hoạt động', CURRENT_DATE - INTERVAL '1 year', CURRENT_DATE - INTERVAL '10 months', 'Vốn ODA', 8500000000, CURRENT_DATE + INTERVAL '2 years', 'Gantry 70cm, bàn bệnh nhân carbon fiber', 'Thuốc cản quang, bơm tiêm tự động', 'Thiết bị cao cấp', 6, CURRENT_DATE + INTERVAL '4 months'),

-- Thiết bị Xét nghiệm
('BỆNH_VIỆN__005', 'Máy xét nghiệm máu tự động', 'DxH 900', 'DXH900005', 'Beckman Coulter', 'Mỹ', 2025, 'Phòng Xét nghiệm', 'Khu vực huyết học', 'KTV. Lê Văn C', 'Hoạt động', CURRENT_DATE - INTERVAL '3 months', CURRENT_DATE - INTERVAL '2 months', 'Ngân sách nhà nước', 1800000000, CURRENT_DATE + INTERVAL '2 years', 'Throughput 90 mẫu/giờ, 29 thông số', 'Reagent pack, control sample', 'Thiết bị mới nhập', 3, CURRENT_DATE + INTERVAL '1 month'),
('BỆNH_VIỆN__006', 'Máy xét nghiệm sinh hóa', 'AU5800', 'AU5800006', 'Beckman Coulter', 'Nhật Bản', 2024, 'Phòng Xét nghiệm', 'Khu vực sinh hóa', 'KTV. Lê Văn C', 'Hoạt động', CURRENT_DATE - INTERVAL '8 months', CURRENT_DATE - INTERVAL '7 months', 'Ngân sách nhà nước', 2200000000, CURRENT_DATE + INTERVAL '1 year', 'Throughput 5400 test/giờ, ISE tích hợp', 'Reagent cartridge, cuvette', 'Hoạt động ổn định', 3, CURRENT_DATE + INTERVAL '2 months'),

-- Thiết bị Cấp cứu
('BỆNH_VIỆN__007', 'Máy thở', 'Servo-i', 'SI2021007', 'Maquet', 'Thụy Điển', 2022, 'Khoa Cấp cứu', 'Phòng hồi sức', 'BS. Phạm Văn D', 'Hoạt động', CURRENT_DATE - INTERVAL '3 years', CURRENT_DATE - INTERVAL '35 months', 'Ngân sách nhà nước', 800000000, CURRENT_DATE - INTERVAL '1 year', 'Màn hình cảm ứng 15 inch, NAVA mode', 'Circuit thở, humidifier', 'Cần bảo trì gấp', 3, CURRENT_DATE + INTERVAL '1 month'),
('BỆNH_VIỆN__008', 'Máy monitor đa thông số', 'IntelliVue MX800', 'MX800008', 'Philips', 'Hà Lan', 2024, 'Khoa Cấp cứu', 'Phòng theo dõi', 'BS. Phạm Văn D', 'Hoạt động', CURRENT_DATE - INTERVAL '1 year', CURRENT_DATE - INTERVAL '11 months', 'Ngân sách nhà nước', 150000000, CURRENT_DATE + INTERVAL '1 year', 'Màn hình 19 inch, 8 sóng hiển thị', 'Cáp kết nối, sensor SpO2', 'Thiết bị ổn định', 6, CURRENT_DATE + INTERVAL '3 months'),

-- Thiết bị Phẫu thuật
('BỆNH_VIỆN__009', 'Máy gây mê', 'Aisys CS2', 'ACS2009', 'GE Healthcare', 'Mỹ', 2023, 'Phòng Phẫu thuật', 'Phòng mổ 1', 'BS. Hoàng Thị E', 'Hoạt động', CURRENT_DATE - INTERVAL '2 years', CURRENT_DATE - INTERVAL '23 months', 'Vốn ODA', 1200000000, CURRENT_DATE + INTERVAL '6 months', 'Ventilator tích hợp, vaporizer Sevoflurane', 'Circuit gây mê, mask thở', 'Thiết bị quan trọng', 6, CURRENT_DATE + INTERVAL '2 months'),
('BỆNH_VIỆN__010', 'Đèn mổ LED', 'Lucea 300', 'LC300010', 'Trumpf', 'Đức', 2025, 'Phòng Phẫu thuật', 'Phòng mổ 1', 'BS. Hoàng Thị E', 'Hoạt động', CURRENT_DATE - INTERVAL '4 months', CURRENT_DATE - INTERVAL '3 months', 'Ngân sách nhà nước', 450000000, CURRENT_DATE + INTERVAL '2 years', 'LED 160.000 lux, điều khiển cảm ứng', 'Tay điều khiển vô trùng, camera HD', 'Thiết bị hiện đại', 12, CURRENT_DATE + INTERVAL '6 months')

ON CONFLICT (ma_thiet_bi) DO NOTHING;

-- 5. Tạo kế hoạch bảo trì mẫu
INSERT INTO ke_hoach_bao_tri (
  thiet_bi_id, loai_bao_tri, mo_ta, ngay_bat_dau, ngay_ket_thuc,
  chu_ky_lap_lai, trang_thai, nguoi_phu_trach_id
) VALUES
-- Bảo trì thiết bị CĐHA
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__003'), 'Hiệu chuẩn', 'Hiệu chuẩn máy X-quang định kỳ', CURRENT_DATE + INTERVAL '1 month', CURRENT_DATE + INTERVAL '1 month', 12, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_cdha')),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__004'), 'Bảo trì định kỳ', 'Bảo trì máy CT định kỳ', CURRENT_DATE + INTERVAL '2 months', CURRENT_DATE + INTERVAL '2 months', 6, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_cdha')),

-- Bảo trì thiết bị xét nghiệm
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__005'), 'Bảo trì định kỳ', 'Bảo trì máy xét nghiệm máu', CURRENT_DATE + INTERVAL '15 days', CURRENT_DATE + INTERVAL '15 days', 3, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_xn')),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__006'), 'Hiệu chuẩn', 'Hiệu chuẩn máy sinh hóa', CURRENT_DATE + INTERVAL '1 month', CURRENT_DATE + INTERVAL '1 month', 6, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_xn')),

-- Bảo trì thiết bị cấp cứu
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__007'), 'Bảo trì định kỳ', 'Bảo trì máy thở định kỳ', CURRENT_DATE + INTERVAL '10 days', CURRENT_DATE + INTERVAL '10 days', 3, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_cc')),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__008'), 'Bảo trì định kỳ', 'Bảo trì monitor đa thông số', CURRENT_DATE + INTERVAL '20 days', CURRENT_DATE + INTERVAL '20 days', 6, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_cc'))

ON CONFLICT DO NOTHING;

-- 6. Tạo một số công việc bảo trì mẫu
INSERT INTO cong_viec_bao_tri (
  ke_hoach_id, thiet_bi_id, ten_cong_viec, mo_ta,
  ngay_thuc_hien_du_kien, trang_thai, nguoi_thuc_hien_id,
  thang_1_hoan_thanh, thang_2_hoan_thanh, thang_3_hoan_thanh
) VALUES
((SELECT id FROM ke_hoach_bao_tri WHERE thiet_bi_id = (SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__005') LIMIT 1),
 (SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__005'),
 'Kiểm tra và vệ sinh máy xét nghiệm máu',
 'Vệ sinh bên ngoài, kiểm tra các bộ phận chính',
 CURRENT_DATE + INTERVAL '15 days',
 'chua_thuc_hien',
 (SELECT id FROM nhan_vien WHERE username = 'qltb_xn'),
 true, false, false),

((SELECT id FROM ke_hoach_bao_tri WHERE thiet_bi_id = (SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__007') LIMIT 1),
 (SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__007'),
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
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__001'), CURRENT_DATE - INTERVAL '1 year', 'Nhập kho', 'Nhập thiết bị mới', 'Máy siêu âm tim Vivid E95 được nhập kho và kiểm tra ban đầu'),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__001'), CURRENT_DATE - INTERVAL '11 months', 'Đưa vào sử dụng', 'Bắt đầu sử dụng', 'Máy siêu âm được đưa vào sử dụng tại Khoa Nội'),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__003'), CURRENT_DATE - INTERVAL '2 years', 'Nhập kho', 'Nhập thiết bị mới', 'Máy X-quang kỹ thuật số được nhập kho'),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__003'), CURRENT_DATE - INTERVAL '23 months', 'Đưa vào sử dụng', 'Bắt đầu sử dụng', 'Máy X-quang được lắp đặt và đưa vào sử dụng'),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__005'), CURRENT_DATE - INTERVAL '3 months', 'Nhập kho', 'Nhập thiết bị mới', 'Máy xét nghiệm máu tự động được nhập kho'),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = 'BỆNH_VIỆN__005'), CURRENT_DATE - INTERVAL '2 months', 'Đưa vào sử dụng', 'Bắt đầu sử dụng', 'Máy xét nghiệm được đưa vào sử dụng tại Phòng XN')

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
  'Dữ liệu mẫu đã được tạo thành công cho Bệnh viện ABC!' as status,
  COUNT(DISTINCT pb.id) as so_phong_ban,
  COUNT(DISTINCT ltb.id) as so_loai_thiet_bi,
  COUNT(DISTINCT nv.id) as so_nhan_vien,
  COUNT(DISTINCT tb.id) as so_thiet_bi,
  COUNT(DISTINCT khbt.id) as so_ke_hoach_bao_tri
FROM phong_ban pb, loai_thiet_bi ltb, nhan_vien nv, thiet_bi tb, ke_hoach_bao_tri khbt;

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
SELECT '🎉 Database đã sẵn sàng sử dụng cho Bệnh viện ABC!' as "Kết quả";

-- =====================================================
-- HƯỚNG DẪN SETUP DATABASE CHO Bệnh viện ABC
-- =====================================================

/*
🚀 HƯỚNG DẪN SỬ DỤNG:

1. TẠO PROJECT SUPABASE MỚI:
   - Truy cập https://supabase.com/dashboard
   - Tạo project mới với tên "Bệnh viện ABC"
   - Chờ project được khởi tạo hoàn tất

2. LẤY THÔNG TIN KẾT NỐI:
   - Vào Settings > Database
   - Copy Connection string (URI)
   - Vào Settings > API
   - Copy Project URL và anon public key

3. CHẠY SCRIPT SETUP:
   Cách 1 - Sử dụng Supabase Dashboard:
   - Vào SQL Editor trong dashboard
   - Copy toàn bộ nội dung file database-setup-complete.sql
   - Paste vào SQL Editor và chạy

   Cách 2 - Sử dụng psql:
   psql "postgresql://postgres:[YOUR-PASSWORD]@[YOUR-HOST]:5432/postgres" -f database-setup-complete.sql

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
