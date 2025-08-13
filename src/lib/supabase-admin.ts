import { createClient, type SupabaseClient } from "@supabase/supabase-js"

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY

let supabaseAdmin: SupabaseClient | null = null;
let supabaseAdminError: string | null = null;

if (!supabaseUrl || !supabaseServiceKey) {
  supabaseAdminError = "Missing Supabase admin configuration. Make sure SUPABASE_SERVICE_ROLE_KEY is set in your environment.";
} else {
    try {
        supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
          auth: {
            autoRefreshToken: false,
            persistSession: false
          }
        })
    } catch (e: any) {
        supabaseAdminError = "Error initializing Supabase admin client: " + e.message;
    }
}

export { supabaseAdmin, supabaseAdminError };
