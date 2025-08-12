-- =====================================================
-- FIX AUTHENTICATION ISSUES
-- Script để khắc phục vấn đề đăng nhập với tài khoản mới
-- =====================================================

-- Bước 1: Kiểm tra xem hàm authenticate_user_dual_mode có tồn tại không
SELECT 
    'FUNCTION CHECK' as check_type,
    proname as function_name,
    CASE 
        WHEN proname = 'authenticate_user_dual_mode' THEN '✅ Function exists'
        ELSE '❌ Function missing'
    END as status
FROM pg_proc 
WHERE proname = 'authenticate_user_dual_mode';

-- Nếu không có kết quả, nghĩa là hàm chưa được tạo

-- Bước 2: Kiểm tra cấu trúc bảng nhan_vien
SELECT 
    'TABLE STRUCTURE' as check_type,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'nhan_vien' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- Bước 3: Kiểm tra tài khoản ntchi/admin
SELECT 
    'USER CHECK' as check_type,
    id,
    username,
    full_name,
    role,
    khoa_phong,
    CASE 
        WHEN password IS NULL THEN '❌ No password'
        WHEN password = '' THEN '❌ Empty password'
        WHEN password = 'admin' THEN '⚠️ Plain text password'
        WHEN password = 'hashed password' THEN '✅ Hashed password marker'
        ELSE '⚠️ Plain text: ' || LEFT(password, 10) || '...'
    END as password_status,
    CASE 
        WHEN hashed_password IS NULL THEN '❌ No hashed password'
        WHEN hashed_password = '' THEN '❌ Empty hashed password'
        WHEN hashed_password LIKE '$2%' THEN '✅ Bcrypt hash'
        ELSE '⚠️ Unknown hash format'
    END as hashed_password_status
FROM nhan_vien 
WHERE username = 'ntchi';

-- Bước 4: Tạo hàm authenticate_user_dual_mode nếu chưa có
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

-- Bước 5: Grant permissions cho hàm
GRANT EXECUTE ON FUNCTION authenticate_user_dual_mode(TEXT, TEXT) TO anon;
GRANT EXECUTE ON FUNCTION authenticate_user_dual_mode(TEXT, TEXT) TO authenticated;

-- Bước 6: Sửa tài khoản ntchi nếu cần
-- Kiểm tra xem tài khoản có tồn tại không
DO $$
DECLARE
    user_exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM nhan_vien WHERE username = 'ntchi') INTO user_exists;
    
    IF user_exists THEN
        -- Cập nhật mật khẩu với hash bcrypt
        UPDATE nhan_vien 
        SET 
            hashed_password = crypt('admin', gen_salt('bf', 12)),
            password = 'hashed password',
            full_name = COALESCE(full_name, 'Administrator'),
            role = COALESCE(role, 'admin'),
            khoa_phong = COALESCE(khoa_phong, 'Ban Giám đốc')
        WHERE username = 'ntchi';
        
        RAISE NOTICE 'Updated user ntchi with hashed password';
    ELSE
        -- Tạo tài khoản mới
        INSERT INTO nhan_vien (username, password, hashed_password, full_name, role, khoa_phong)
        VALUES (
            'ntchi',
            'hashed password',
            crypt('admin', gen_salt('bf', 12)),
            'Administrator',
            'admin',
            'Ban Giám đốc'
        );
        
        RAISE NOTICE 'Created new user ntchi with hashed password';
    END IF;
END $$;

-- Bước 7: Test authentication
SELECT 'AUTHENTICATION TEST' as test_type;

-- Test với tài khoản ntchi/admin
SELECT 
    'ntchi/admin test' as test_name,
    user_id,
    username,
    full_name,
    role,
    is_authenticated,
    authentication_mode
FROM authenticate_user_dual_mode('ntchi', 'admin');

-- Test với tài khoản admin/admin123 (nếu có)
SELECT 
    'admin/admin123 test' as test_name,
    user_id,
    username,
    full_name,
    role,
    is_authenticated,
    authentication_mode
FROM authenticate_user_dual_mode('admin', 'admin123');

-- Bước 8: Kiểm tra kết quả cuối cùng
SELECT 
    'FINAL CHECK' as check_type,
    username,
    full_name,
    role,
    CASE 
        WHEN hashed_password IS NOT NULL AND hashed_password != '' THEN '✅ Has hashed password'
        ELSE '❌ Missing hashed password'
    END as password_status
FROM nhan_vien 
WHERE username IN ('ntchi', 'admin')
ORDER BY username;

-- Thông báo hoàn thành
SELECT '🎉 Authentication fix completed! Try logging in with ntchi/admin' as result;
