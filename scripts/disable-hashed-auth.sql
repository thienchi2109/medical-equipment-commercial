-- =====================================================
-- DISABLE HASHED PASSWORD AUTHENTICATION
-- Tắt hệ thống password hashed, chỉ giữ legacy plaintext
-- =====================================================

-- Tạo function authenticate chỉ dùng plaintext password (legacy mode only)
CREATE OR REPLACE FUNCTION authenticate_user_legacy_only(
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
BEGIN
  -- Find user by username
  SELECT id, nv.username, nv.full_name, nv.role, nv.khoa_phong, nv.password
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

  -- ONLY check plaintext password (no hashed password check)
  IF user_record.password IS NOT NULL AND user_record.password != 'hashed password' THEN
    password_valid := (user_record.password = p_password);
  END IF;

  -- Return authentication result
  RETURN QUERY SELECT
    user_record.id,
    user_record.username::TEXT,
    user_record.full_name::TEXT,
    user_record.role::TEXT,
    user_record.khoa_phong::TEXT,
    password_valid,
    CASE 
      WHEN password_valid THEN 'plain'::TEXT
      ELSE 'failed'::TEXT
    END;
END;
$$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION authenticate_user_legacy_only(TEXT, TEXT) TO anon;
GRANT EXECUTE ON FUNCTION authenticate_user_legacy_only(TEXT, TEXT) TO authenticated;

-- Optional: Backup existing dual mode function
DROP FUNCTION IF EXISTS authenticate_user_dual_mode_backup(TEXT, TEXT);
CREATE OR REPLACE FUNCTION authenticate_user_dual_mode_backup AS authenticate_user_dual_mode;

-- Replace dual mode function with legacy-only version
DROP FUNCTION IF EXISTS authenticate_user_dual_mode(TEXT, TEXT);
CREATE OR REPLACE FUNCTION authenticate_user_dual_mode AS authenticate_user_legacy_only;

-- Test the changes
SELECT 'TESTING LEGACY-ONLY AUTHENTICATION' as test_status;

-- Test with existing plaintext accounts
SELECT 
    'Legacy auth test' as test_name,
    user_id,
    username,
    is_authenticated,
    authentication_mode
FROM authenticate_user_dual_mode('admin', 'admin123')
WHERE authentication_mode = 'plain';

SELECT '✅ Hashed password authentication disabled. Only legacy plaintext passwords work now.' as result;
