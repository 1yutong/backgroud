package com.example.lockscreenwallpaper

import android.app.WallpaperManager
import android.content.Context
import android.graphics.Bitmap
import android.os.Build
import android.widget.Toast

object WallpaperSetter {

    fun setLockScreenWallpaper(context: Context, bitmap: Bitmap) {
        try {
            val wallpaperManager = WallpaperManager.getInstance(context)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                // Android 7.0+ 支持分别设置锁屏和桌面壁纸
                wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK)
                Toast.makeText(context, "锁屏壁纸已更新", Toast.LENGTH_SHORT).show()
            } else {
                // 低版本只能同时设置
                wallpaperManager.setBitmap(bitmap)
                Toast.makeText(context, "壁纸已更新（同时设置桌面和锁屏）", Toast.LENGTH_SHORT).show()
            }
        } catch (e: Exception) {
            e.printStackTrace()
            Toast.makeText(context, "设置壁纸失败: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }

    fun updateWallpaperWithCurrentTime(context: Context) {
        val bitmap = WallpaperGenerator.generateTimeWallpaper(context)
        setLockScreenWallpaper(context, bitmap)
    }
}
