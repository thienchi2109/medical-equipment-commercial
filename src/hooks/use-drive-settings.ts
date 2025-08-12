import * as React from 'react'
import { supabase } from '@/lib/supabase'

interface DriveSettings {
  id?: number
  folder_url: string
  folder_name: string
  is_active: boolean
  created_at?: string
  updated_at?: string
}

export function useDriveSettings() {
  const [settings, setSettings] = React.useState<DriveSettings | null>(null)
  const [isLoading, setIsLoading] = React.useState(true)
  const [error, setError] = React.useState<string | null>(null)

  const loadSettings = React.useCallback(async () => {
    try {
      setIsLoading(true)
      setError(null)

      const { data, error } = await supabase
        .from('google_drive_settings')
        .select('*')
        .eq('is_active', true)
        .single()

      if (error && error.code !== 'PGRST116') { // PGRST116 = no rows found
        throw error
      }

      setSettings(data || null)
    } catch (err) {
      console.error('Error loading drive settings:', err)
      setError(err instanceof Error ? err.message : 'Failed to load settings')
    } finally {
      setIsLoading(false)
    }
  }, [])

  React.useEffect(() => {
    loadSettings()
  }, [loadSettings])

  const getFolderUrl = React.useCallback((): string => {
    if (settings?.folder_url) {
      return settings.folder_url
    }
    // Fallback to default URL if no settings configured
    return "https://drive.google.com/open?id=1-lgEygGCIfxCbIIdgaCmh3GFJgAMr63e&usp=drive_fs"
  }, [settings])

  const getFolderName = React.useCallback((): string => {
    return settings?.folder_name || "thư mục Drive chung"
  }, [settings])

  const isConfigured = React.useMemo(() => {
    return !!(settings?.folder_url && settings.folder_name)
  }, [settings])

  return {
    settings,
    isLoading,
    error,
    getFolderUrl,
    getFolderName,
    isConfigured,
    reload: loadSettings
  }
}
