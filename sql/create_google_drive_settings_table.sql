-- Create Google Drive Settings table
-- This table stores the configurable Google Drive folder URLs for file attachments

-- Drop table if exists (for development only, remove in production)
-- DROP TABLE IF EXISTS google_drive_settings;

-- Create google_drive_settings table
CREATE TABLE google_drive_settings (
    id SERIAL PRIMARY KEY,
    folder_url TEXT NOT NULL,
    folder_name VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add RLS (Row Level Security) policy
ALTER TABLE google_drive_settings ENABLE ROW LEVEL SECURITY;

-- Policy for admins (can manage all settings)
CREATE POLICY google_drive_settings_admin_policy ON google_drive_settings
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM auth.users 
        WHERE auth.uid() = users.id 
        AND users.raw_user_meta_data->>'role' = 'admin'
    )
);

-- Policy for to_qltb role (can manage all settings)
CREATE POLICY google_drive_settings_to_qltb_policy ON google_drive_settings  
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM auth.users 
        WHERE auth.uid() = users.id 
        AND users.raw_user_meta_data->>'role' = 'to_qltb'
    )
);

-- Policy for read access (all authenticated users can read active settings)
CREATE POLICY google_drive_settings_read_policy ON google_drive_settings
FOR SELECT
TO authenticated
USING (is_active = true);

-- Add index for performance
CREATE INDEX idx_google_drive_settings_active ON google_drive_settings(is_active);
CREATE INDEX idx_google_drive_settings_created_at ON google_drive_settings(created_at);

-- Add trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_google_drive_settings_updated_at 
    BEFORE UPDATE ON google_drive_settings 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Insert default settings (optional - use the old link as fallback)
INSERT INTO google_drive_settings (folder_url, folder_name, is_active) 
VALUES (
    'https://drive.google.com/open?id=1-lgEygGCIfxCbIIdgaCmh3GFJgAMr63e&usp=drive_fs',
    'Thư mục Drive mặc định',
    true
) ON CONFLICT DO NOTHING;

-- Grant permissions
GRANT ALL ON google_drive_settings TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE google_drive_settings_id_seq TO authenticated;
