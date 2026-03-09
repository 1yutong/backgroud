package com.example.lockscreenwallpaper

import android.content.Context
import android.graphics.*
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import java.text.SimpleDateFormat
import java.util.*

object WallpaperGenerator {

    private const val WALLPAPER_WIDTH = 1080
    private const val WALLPAPER_HEIGHT = 1920

    fun generateTimeWallpaper(context: Context): Bitmap {
        val bitmap = Bitmap.createBitmap(WALLPAPER_WIDTH, WALLPAPER_HEIGHT, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)

        // 绘制渐变背景
        drawGradientBackground(canvas)

        // 获取当前时间
        val calendar = Calendar.getInstance()
        val timeFormat = SimpleDateFormat("HH:mm", Locale.getDefault())
        val dateFormat = SimpleDateFormat("yyyy年MM月dd日 EEEE", Locale.getDefault())

        val timeString = timeFormat.format(calendar.time)
        val dateString = dateFormat.format(calendar.time)

        // 绘制时间
        drawTime(canvas, timeString)

        // 绘制日期
        drawDate(canvas, dateString)

        return bitmap
    }

    private fun drawGradientBackground(canvas: Canvas) {
        val colors = intArrayOf(
            Color.parseColor("#1a1a2e"),
            Color.parseColor("#16213e"),
            Color.parseColor("#0f3460")
        )
        val positions = floatArrayOf(0f, 0.5f, 1f)

        val gradient = LinearGradient(
            0f, 0f,
            0f, canvas.height.toFloat(),
            colors,
            positions,
            Shader.TileMode.CLAMP
        )

        val paint = Paint().apply {
            shader = gradient
        }

        canvas.drawRect(0f, 0f, canvas.width.toFloat(), canvas.height.toFloat(), paint)
    }

    private fun drawTime(canvas: Canvas, time: String) {
        val paint = Paint().apply {
            color = Color.WHITE
            textSize = 180f
            typeface = Typeface.DEFAULT_BOLD
            textAlign = Paint.Align.CENTER
            isAntiAlias = true

            // 添加阴影效果
            setShadowLayer(20f, 0f, 10f, Color.parseColor("#40000000"))
        }

        val x = canvas.width / 2f
        val y = canvas.height / 2f - 50f

        canvas.drawText(time, x, y, paint)
    }

    private fun drawDate(canvas: Canvas, date: String) {
        val paint = Paint().apply {
            color = Color.parseColor("#CCCCCC")
            textSize = 48f
            typeface = Typeface.DEFAULT
            textAlign = Paint.Align.CENTER
            isAntiAlias = true
        }

        val x = canvas.width / 2f
        val y = canvas.height / 2f + 100f

        canvas.drawText(date, x, y, paint)
    }

    fun generateWallpaperWithBackground(context: Context, backgroundDrawable: Drawable?): Bitmap {
        val bitmap = Bitmap.createBitmap(WALLPAPER_WIDTH, WALLPAPER_HEIGHT, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)

        // 绘制背景图片（如果有）
        backgroundDrawable?.let {
            val bgBitmap = (it as? BitmapDrawable)?.bitmap
            bgBitmap?.let { bmp ->
                val scaledBitmap = Bitmap.createScaledBitmap(bmp, WALLPAPER_WIDTH, WALLPAPER_HEIGHT, true)
                canvas.drawBitmap(scaledBitmap, 0f, 0f, null)

                // 添加半透明遮罩
                val overlayPaint = Paint().apply {
                    color = Color.parseColor("#80000000")
                }
                canvas.drawRect(0f, 0f, canvas.width.toFloat(), canvas.height.toFloat(), overlayPaint)
            }
        } ?: run {
            // 没有背景图片时使用渐变
            drawGradientBackground(canvas)
        }

        // 获取当前时间
        val calendar = Calendar.getInstance()
        val timeFormat = SimpleDateFormat("HH:mm", Locale.getDefault())
        val dateFormat = SimpleDateFormat("yyyy年MM月dd日 EEEE", Locale.getDefault())

        val timeString = timeFormat.format(calendar.time)
        val dateString = dateFormat.format(calendar.time)

        // 绘制时间
        drawTime(canvas, timeString)

        // 绘制日期
        drawDate(canvas, dateString)

        return bitmap
    }
}
