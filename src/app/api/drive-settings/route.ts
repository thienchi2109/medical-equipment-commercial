import { NextRequest, NextResponse } from 'next/server'
import { supabaseAdmin } from '@/lib/supabase-admin'

export async function GET() {
  try {
    if (!supabaseAdmin) {
      return NextResponse.json(
        { error: 'Supabase admin client not configured' },
        { status: 500 }
      )
    }

    const { data, error } = await supabaseAdmin
      .from('google_drive_settings')
      .select('*')
      .eq('is_active', true)
      .single()

    if (error && error.code !== 'PGRST116') { // PGRST116 = no rows found
      throw error
    }

    return NextResponse.json({ data: data || null })
  } catch (error) {
    console.error('Error fetching drive settings:', error)
    return NextResponse.json(
      { error: 'Failed to fetch drive settings' },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    if (!supabaseAdmin) {
      return NextResponse.json(
        { error: 'Supabase admin client not configured' },
        { status: 500 }
      )
    }

    const body = await request.json()
    const { folder_url, folder_name } = body

    if (!folder_url || !folder_name) {
      return NextResponse.json(
        { error: 'Missing required fields: folder_url and folder_name' },
        { status: 400 }
      )
    }

    // Validate Google Drive URL
    const drivePatterns = [
      /^https:\/\/drive\.google\.com\/drive\/folders\/[a-zA-Z0-9_-]+/,
      /^https:\/\/drive\.google\.com\/open\?id=[a-zA-Z0-9_-]+/
    ]
    
    const isValidUrl = drivePatterns.some(pattern => pattern.test(folder_url))
    if (!isValidUrl) {
      return NextResponse.json(
        { error: 'Invalid Google Drive URL format' },
        { status: 400 }
      )
    }

    // First, deactivate all existing settings
    const { error: deactivateError } = await supabaseAdmin
      .from('google_drive_settings')
      .update({ is_active: false })
      .neq('id', 0) // Update all records

    if (deactivateError) {
      console.warn('Warning deactivating existing settings:', deactivateError)
      // Continue anyway as this might be expected if no existing settings
    }

    // Insert new settings
    const { data, error } = await supabaseAdmin
      .from('google_drive_settings')
      .insert({
        folder_url: folder_url.trim(),
        folder_name: folder_name.trim(),
        is_active: true,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      })
      .select()
      .single()

    if (error) {
      throw error
    }

    return NextResponse.json({ data })
  } catch (error) {
    console.error('Error saving drive settings:', error)
    return NextResponse.json(
      { error: 'Failed to save drive settings' },
      { status: 500 }
    )
  }
}
