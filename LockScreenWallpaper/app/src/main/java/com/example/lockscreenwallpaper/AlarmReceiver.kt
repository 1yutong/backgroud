package com.example.lockscreenwallpaper

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // 启动服务来更新壁纸
        val serviceIntent = Intent(context, WallpaperUpdateService::class.java).apply {
            action = WallpaperUpdateService.ACTION_UPDATE_WALLPAPER
        }
        context.startService(serviceIntent)
    }
}
