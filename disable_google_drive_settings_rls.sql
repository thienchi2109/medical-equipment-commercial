-- Disable RLS for google_drive_settings table
-- Since only admins can access the settings page, RLS is not needed

-- Drop all existing policies
DROP POLICY IF EXISTS google_drive_settings_admin_policy ON google_drive_settings;
DROP POLICY IF EXISTS google_drive_settings_to_qltb_policy ON google_drive_settings;
DROP POLICY IF EXISTS google_drive_settings_read_policy ON google_drive_settings;
DROP POLICY IF EXISTS google_drive_settings_all_access ON google_drive_settings;

-- Disable RLS completely
ALTER TABLE google_drive_settings DISABLE ROW LEVEL SECURITY;
