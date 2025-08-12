"use client"

import * as React from "react"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Alert, AlertDescription } from "@/components/ui/alert"
import { Separator } from "@/components/ui/separator"
import { AlertCircle, Save, ExternalLink, Folder } from "lucide-react"
import { useToast } from "@/hooks/use-toast"
import { supabase } from "@/lib/supabase"

interface DriveSettings {
  id?: number
  folder_url: string
  folder_name: string
  is_active: boolean
  created_at?: string
  updated_at?: string
}

export default function SettingsPage() {
  const { toast } = useToast()
  const [isLoading, setIsLoading] = React.useState(true)
  const [isSaving, setIsSaving] = React.useState(false)
  const [settings, setSettings] = React.useState<DriveSettings>({
    folder_url: "",
    folder_name: "",
    is_active: true
  })

  const [formData, setFormData] = React.useState({
    folder_url: "",
    folder_name: ""
  })

  // Load current settings
  React.useEffect(() => {
    loadSettings()
  }, [])

  const loadSettings = async () => {
    try {
      const { data, error } = await supabase
        .from('google_drive_settings')
        .select('*')
        .eq('is_active', true)
        .single()

      if (error && error.code !== 'PGRST116') { // PGRST116 = no rows found
        throw error
      }

      if (data) {
        setSettings(data)
        setFormData({
          folder_url: data.folder_url,
          folder_name: data.folder_name
        })
      } else {
        // No settings found, keep default empty values
        setSettings({
          folder_url: "",
          folder_name: "",
          is_active: true
        })
      }
    } catch (error) {
      console.error('Error loading drive settings:', error)
      toast({
        title: "Lỗi tải cấu hình",
        description: "Không thể tải cấu hình Google Drive",
        variant: "destructive"
      })
    } finally {
      setIsLoading(false)
    }
  }

  const validateDriveUrl = (url: string): boolean => {
    const drivePatterns = [
      /^https:\/\/drive\.google\.com\/drive\/folders\/[a-zA-Z0-9_-]+/,
      /^https:\/\/drive\.google\.com\/open\?id=[a-zA-Z0-9_-]+/
    ]
    return drivePatterns.some(pattern => pattern.test(url))
  }

  const extractFolderId = (url: string): string | null => {
    // For folder URLs: https://drive.google.com/drive/folders/{id}
    const folderMatch = url.match(/\/folders\/([a-zA-Z0-9_-]+)/)
    if (folderMatch) return folderMatch[1]

    // For share URLs: https://drive.google.com/open?id={id}
    const idMatch = url.match(/[?&]id=([a-zA-Z0-9_-]+)/)
    if (idMatch) return idMatch[1]

    return null
  }

  const handleSave = async () => {
    if (!formData.folder_url.trim()) {
      toast({
        title: "Thiếu thông tin",
        description: "Vui lòng nhập URL thư mục Google Drive",
        variant: "destructive"
      })
      return
    }

    if (!validateDriveUrl(formData.folder_url)) {
      toast({
        title: "URL không hợp lệ", 
        description: "Vui lòng nhập URL thư mục Google Drive hợp lệ",
        variant: "destructive"
      })
      return
    }

    if (!formData.folder_name.trim()) {
      toast({
        title: "Thiếu thông tin",
        description: "Vui lòng nhập tên thư mục",
        variant: "destructive"
      })
      return
    }

    setIsSaving(true)

    try {
      // Deactivate old settings first
      if (settings.id) {
        await supabase
          .from('google_drive_settings')
          .update({ is_active: false })
          .eq('id', settings.id)
      }

      // Insert new settings
      const { data, error } = await supabase
        .from('google_drive_settings')
        .insert({
          folder_url: formData.folder_url.trim(),
          folder_name: formData.folder_name.trim(),
          is_active: true,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        })
        .select()
        .single()

      if (error) throw error

      setSettings(data)
      
      toast({
        title: "Lưu thành công",
        description: "Cấu hình Google Drive đã được cập nhật"
      })

    } catch (error) {
      console.error('Error saving drive settings:', error)
      toast({
        title: "Lỗi lưu cấu hình",
        description: "Không thể lưu cấu hình. Vui lòng thử lại.",
        variant: "destructive"
      })
    } finally {
      setIsSaving(false)
    }
  }

  if (isLoading) {
    return (
      <div className="container mx-auto p-6">
        <div className="animate-pulse space-y-4">
          <div className="h-8 bg-gray-200 rounded w-1/4"></div>
          <div className="h-32 bg-gray-200 rounded"></div>
        </div>
      </div>
    )
  }

  return (
    <div className="container mx-auto p-6 space-y-6">
      <div>
        <h1 className="text-2xl font-bold">Cài đặt hệ thống</h1>
        <p className="text-muted-foreground">
          Quản lý cấu hình Google Drive và các thiết lập khác
        </p>
      </div>

      <Separator />

      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Folder className="h-5 w-5" />
            Cấu hình Google Drive
          </CardTitle>
          <CardDescription>
            Cập nhật thư mục Google Drive để lưu trữ file đính kèm của thiết bị
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          {/* Current settings display */}
          {settings.folder_url && (
            <Alert>
              <AlertCircle className="h-4 w-4" />
              <AlertDescription className="space-y-2">
                <div><strong>Thư mục hiện tại:</strong> {settings.folder_name}</div>
                <div className="flex items-center gap-2">
                  <strong>URL:</strong> 
                  <a 
                    href={settings.folder_url} 
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="text-primary hover:underline inline-flex items-center gap-1"
                  >
                    {settings.folder_url}
                    <ExternalLink className="h-3 w-3" />
                  </a>
                </div>
              </AlertDescription>
            </Alert>
          )}

          <form onSubmit={(e) => { e.preventDefault(); handleSave(); }} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="folder-name">Tên thư mục</Label>
              <Input
                id="folder-name"
                placeholder="VD: File thiết bị y tế - Bệnh viện ABC"
                value={formData.folder_name}
                onChange={(e) => setFormData(prev => ({ ...prev, folder_name: e.target.value }))}
                disabled={isSaving}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="folder-url">URL thư mục Google Drive</Label>
              <Input
                id="folder-url"
                type="url"
                placeholder="https://drive.google.com/drive/folders/..."
                value={formData.folder_url}
                onChange={(e) => setFormData(prev => ({ ...prev, folder_url: e.target.value }))}
                disabled={isSaving}
              />
            </div>

            <Alert>
              <AlertCircle className="h-4 w-4" />
              <AlertDescription>
                <div className="space-y-2">
                  <p><strong>Hướng dẫn lấy URL thư mục Google Drive:</strong></p>
                  <ol className="list-decimal list-inside space-y-1 text-sm">
                    <li>Truy cập Google Drive và tạo thư mục mới (hoặc chọn thư mục có sẵn)</li>
                    <li>Nhấp chuột phải vào thư mục và chọn "Chia sẻ"</li>
                    <li>Thay đổi quyền truy cập thành "Bất kỳ ai có liên kết đều có thể xem"</li>
                    <li>Sao chép liên kết và dán vào ô trên</li>
                  </ol>
                  <p className="text-xs text-muted-foreground mt-2">
                    Lưu ý: Thư mục cần được chia sẻ công khai để mọi người có thể truy cập file đính kèm.
                  </p>
                </div>
              </AlertDescription>
            </Alert>

            <Button 
              type="submit" 
              disabled={isSaving || !formData.folder_url.trim() || !formData.folder_name.trim()}
              className="w-full sm:w-auto"
            >
              <Save className="mr-2 h-4 w-4" />
              {isSaving ? "Đang lưu..." : "Lưu cấu hình"}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}
