'use client'

import * as React from 'react'
import { useRouter } from 'next/navigation'
import { supabase, supabaseError } from '@/lib/supabase'
import { useToast } from '@/hooks/use-toast'
import { User, UserRole } from '@/types/database'

interface AuthContextType {
  user: User | null;
  login: (username: string, password: string) => Promise<boolean>;
  logout: () => void;
  isInitialized: boolean;
  isLoading: boolean;
}

const AuthContext = React.createContext<AuthContextType | undefined>(undefined);

const SESSION_TOKEN_KEY = 'auth_session_token';

// Safe Base64 encode/decode for Unicode characters
const safeBase64Encode = (str: string): string => {
  try {
    return btoa(unescape(encodeURIComponent(str)));
  } catch (error) {
    console.error('Base64 encode error:', error);
    return btoa(str); // Fallback
  }
};

const safeBase64Decode = (str: string): string => {
  try {
    return decodeURIComponent(escape(atob(str)));
  } catch (error) {
    console.error('Base64 decode error:', error);
    return atob(str); // Fallback
  }
};

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = React.useState<User | null>(null);
  const [isInitialized, setIsInitialized] = React.useState(false);
  const [isLoading, setIsLoading] = React.useState(false);
  const router = useRouter();
  const { toast } = useToast();

  // Initialize session on mount
  React.useEffect(() => {
    const initializeSession = async () => {
      try {
        const sessionToken = localStorage.getItem(SESSION_TOKEN_KEY);

        if (!sessionToken) {
          setIsInitialized(true);
          return;
        }

        // Validate session with new secure function
        // Decode and validate session token
        try {
          const sessionData = JSON.parse(safeBase64Decode(sessionToken));

          // Check if session has expired
          if (Date.now() > sessionData.expires_at) {
            localStorage.removeItem(SESSION_TOKEN_KEY);
            setIsInitialized(true);
            return;
          }

          // Restore user session from token
          const userData: User = {
            id: sessionData.user_id,
            username: sessionData.username,
            password: '', // Never store password in frontend
            full_name: sessionData.full_name || '',
            role: sessionData.role as UserRole,
            khoa_phong: sessionData.khoa_phong,
            created_at: new Date().toISOString(),
          };

          setUser(userData);
        } catch (tokenError) {
          // Invalid token format
          localStorage.removeItem(SESSION_TOKEN_KEY);
          setIsInitialized(true);
          return;
        }
      } catch (error) {
        console.error("Session initialization failed:", error);
        localStorage.removeItem(SESSION_TOKEN_KEY);
      } finally {
        setIsInitialized(true);
      }
    };

    initializeSession();
  }, []);

  const login = async (username: string, password: string): Promise<boolean> => {
    if (supabaseError || !supabase) {
      toast({
        variant: "destructive",
        title: "Lỗi cấu hình",
        description: supabaseError || "Không thể kết nối đến Supabase.",
      });
      return false;
    }

    setIsLoading(true);

    try {
      // 🔄 LEGACY AUTHENTICATION ONLY: Use direct database query for plaintext passwords
      console.log("Using legacy plaintext authentication only...");

      const { data: userData, error: userError } = await supabase!
        .from('nhan_vien')
        .select('*')
        .eq('username', username.trim())
        .single();

      if (userError || !userData) {
        console.error("User lookup failed:", userError);
        toast({
          variant: "destructive",
          title: "Đăng nhập thất bại",
          description: "Tên đăng nhập không tồn tại.",
        });
        return false;
      }

      // 🚨 SECURITY: Block login attempts with suspicious strings
      if (password === 'hashed password' || 
          password.includes('hash') || 
          password.includes('crypt') || 
          password.length > 200) {
        console.warn('Security: Blocked login attempt with suspicious password');
        toast({
          variant: "destructive",
          title: "Đăng nhập thất bại",
          description: "Thông tin đăng nhập không hợp lệ.",
        });
        return false;
      }

      // ⚠️ LEGACY: Check ONLY plaintext password (no hashed password support)
      if (userData.password === password && userData.password !== 'hashed password') {
        // Create session token with 3-hour expiration
        const sessionData = {
          user_id: userData.id,
          username: userData.username,
          role: userData.role,
          khoa_phong: userData.khoa_phong,
          full_name: userData.full_name,
          created_at: Date.now(),
          expires_at: Date.now() + (3 * 60 * 60 * 1000) // 3 hours in milliseconds
        };

        // Safe Base64 encode for Unicode characters
        const sessionToken = safeBase64Encode(JSON.stringify(sessionData));
        localStorage.setItem(SESSION_TOKEN_KEY, sessionToken);
        setUser(userData);

        toast({
          title: "Đăng nhập thành công",
          description: `Chào mừng ${userData.full_name || userData.username}! (⚠️ Legacy Mode)`,
        });

        router.push("/dashboard");
        return true;
      }

      // Password incorrect or user has hashed password (not supported in legacy mode)
      if (userData.password === 'hashed password') {
        toast({
          variant: "destructive",
          title: "Tài khoản không hỗ trợ",
          description: "Tài khoản này sử dụng mật khẩu mã hóa không được hỗ trợ trong chế độ legacy.",
        });
      } else {
        toast({
          variant: "destructive",
          title: "Đăng nhập thất bại",
          description: "Tên đăng nhập hoặc mật khẩu không đúng.",
        });
      }
      return false;

    } catch (error) {
      console.error("Legacy authentication failed:", error);
      toast({
        variant: "destructive",
        title: "Lỗi đăng nhập",
        description: "Có lỗi xảy ra khi đăng nhập. Vui lòng thử lại.",
      });
      return false;
    } finally {
      setIsLoading(false);
    }
  };

  const logout = async () => {
    try {
      const sessionToken = localStorage.getItem(SESSION_TOKEN_KEY);

      // Note: Session invalidation function was removed during rollback
      // Sessions will expire naturally or be cleared on next login
    } catch (error) {
      console.error("Logout error:", error);
    } finally {
      // Clear local state regardless of server response
      setUser(null);
      localStorage.removeItem(SESSION_TOKEN_KEY);
      router.push('/');
    }
  };

  // Auto-logout on session expiry with user notification
  React.useEffect(() => {
    if (!user) return;

    const sessionToken = localStorage.getItem(SESSION_TOKEN_KEY);
    if (!sessionToken) return;

    const checkSession = () => {
      try {
        const sessionData = JSON.parse(safeBase64Decode(sessionToken));

        // Check if session will expire in next 5 minutes
        const timeUntilExpiry = sessionData.expires_at - Date.now();
        const fiveMinutes = 5 * 60 * 1000;

        if (timeUntilExpiry <= 0) {
          // Session expired - logout with notification
          toast({
            variant: "destructive",
            title: "Phiên làm việc đã hết hạn",
            description: "Bạn đã được đăng xuất tự động sau 3 tiếng. Vui lòng đăng nhập lại.",
            duration: 5000,
          });
          logout();
        } else if (timeUntilExpiry <= fiveMinutes) {
          // Warn user about upcoming expiry
          const minutesLeft = Math.ceil(timeUntilExpiry / (60 * 1000));
          toast({
            title: "Phiên làm việc sắp hết hạn",
            description: `Phiên làm việc sẽ hết hạn trong ${minutesLeft} phút. Vui lòng lưu công việc.`,
            duration: 4000,
          });
        }
      } catch (error) {
        console.error("Session validation error:", error);
        // Invalid token - logout
        logout();
      }
    };

    // Check immediately
    checkSession();

    // Check session every minute for more responsive expiry handling
    const interval = setInterval(checkSession, 60 * 1000);
    return () => clearInterval(interval);
  }, [user, toast]);

  return (
    <AuthContext.Provider value={{
      user,
      login,
      logout,
      isInitialized,
      isLoading
    }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = React.useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
