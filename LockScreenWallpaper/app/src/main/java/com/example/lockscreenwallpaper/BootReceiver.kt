package com.example.lockscreenwallpaper

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            // 开机后重新启动服务
            val serviceIntent = Intent(context, WallpaperUpdateService::class.java)
            context.startForegroundService(serviceIntent)
        }
    }
}
