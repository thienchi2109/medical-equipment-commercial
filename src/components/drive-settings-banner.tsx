"use client"

import * as React from "react"
import Link from "next/link"
import { AlertCircle, Settings, X } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Alert, AlertDescription } from "@/components/ui/alert"
import { useDriveSettings } from "@/hooks/use-drive-settings"
import { useAuth } from "@/contexts/auth-context"

export function DriveSettingsBanner() {
  const { user } = useAuth()
  const { isConfigured, isLoading } = useDriveSettings()
  const [isDismissed, setIsDismissed] = React.useState(false)

  // Only show for admin and to_qltb roles
  const canConfigure = user?.role === 'admin' || user?.role === 'to_qltb'

  // Load dismissed state from localStorage
  React.useEffect(() => {
    const dismissed = localStorage.getItem('drive-settings-banner-dismissed')
    setIsDismissed(dismissed === 'true')
  }, [])

  const handleDismiss = () => {
    setIsDismissed(true)
    localStorage.setItem('drive-settings-banner-dismissed', 'true')
  }

  // Reset dismissed state when Google Drive is configured
  React.useEffect(() => {
    if (isConfigured) {
      localStorage.removeItem('drive-settings-banner-dismissed')
    }
  }, [isConfigured])

  // Don't show banner if:
  // - Loading
  // - User can't configure
  // - Already configured 
  // - User dismissed it
  if (isLoading || !canConfigure || isConfigured || isDismissed) {
    return null
  }

  return (
    <Alert className="border-orange-200 bg-orange-50 text-orange-800">
      <AlertCircle className="h-4 w-4 text-orange-600" />
      <AlertDescription className="flex items-center justify-between w-full">
        <div className="flex-1">
          <strong>Cấu hình Google Drive:</strong> Hiện tại hệ thống đang sử dụng thư mục Google Drive mặc định. 
          Vui lòng cấu hình thư mục riêng của tổ chức để lưu trữ file đính kèm thiết bị.
        </div>
        <div className="flex items-center gap-2 ml-4 shrink-0">
          <Link href="/settings">
            <Button variant="outline" size="sm" className="bg-white hover:bg-orange-100 border-orange-300 text-orange-800">
              <Settings className="mr-2 h-4 w-4" />
              Cấu hình ngay
            </Button>
          </Link>
          <Button 
            variant="ghost" 
            size="icon"
            onClick={handleDismiss}
            className="h-6 w-6 text-orange-600 hover:bg-orange-100"
          >
            <X className="h-4 w-4" />
            <span className="sr-only">Đóng thông báo</span>
          </Button>
        </div>
      </AlertDescription>
    </Alert>
  )
}
