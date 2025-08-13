-- Fix RLS policies for google_drive_settings table
-- The original policies had incorrect references to users table

-- Drop existing policies
DROP POLICY IF EXISTS google_drive_settings_admin_policy ON google_drive_settings;
DROP POLICY IF EXISTS google_drive_settings_to_qltb_policy ON google_drive_settings;
DROP POLICY IF EXISTS google_drive_settings_read_policy ON google_drive_settings;

-- Policy for admins (can manage all settings)
CREATE POLICY google_drive_settings_admin_policy ON google_drive_settings
FOR ALL
TO authenticated
USING (
    auth.jwt() ->> 'role' = 'admin'
    OR 
    (auth.jwt() ->> 'user_metadata')::jsonb ->> 'role' = 'admin'
);

-- Policy for to_qltb role (can manage all settings) 
CREATE POLICY google_drive_settings_to_qltb_policy ON google_drive_settings
FOR ALL
TO authenticated
USING (
    auth.jwt() ->> 'role' = 'to_qltb'
    OR
    (auth.jwt() ->> 'user_metadata')::jsonb ->> 'role' = 'to_qltb'
);

-- Policy for read access (all authenticated users can read active settings)
CREATE POLICY google_drive_settings_read_policy ON google_drive_settings
FOR SELECT
TO authenticated
USING (is_active = true);

-- Alternative simpler approach: Allow all authenticated users to manage settings
-- (Remove this comment and uncomment below if the role-based approach doesn't work)
/*
DROP POLICY IF EXISTS google_drive_settings_admin_policy ON google_drive_settings;
DROP POLICY IF EXISTS google_drive_settings_to_qltb_policy ON google_drive_settings;

CREATE POLICY google_drive_settings_all_access ON google_drive_settings
FOR ALL
TO authenticated
USING (true);
*/
