package com.example.lockscreenwallpaper

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class MainActivity : AppCompatActivity() {

    private lateinit var btnStartService: Button
    private lateinit var btnStopService: Button
    private lateinit var btnUpdateNow: Button
    private lateinit var tvStatus: TextView

    private val PERMISSIONS_REQUEST_CODE = 100

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        initViews()
        checkPermissions()
        updateStatus()
    }

    private fun initViews() {
        btnStartService = findViewById(R.id.btnStartService)
        btnStopService = findViewById(R.id.btnStopService)
        btnUpdateNow = findViewById(R.id.btnUpdateNow)
        tvStatus = findViewById(R.id.tvStatus)

        btnStartService.setOnClickListener {
            startWallpaperService()
        }

        btnStopService.setOnClickListener {
            stopWallpaperService()
        }

        btnUpdateNow.setOnClickListener {
            updateWallpaperNow()
        }
    }

    private fun checkPermissions() {
        val permissions = mutableListOf<String>()

        // 检查设置壁纸权限
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.SET_WALLPAPER)
            != PackageManager.PERMISSION_GRANTED) {
            permissions.add(Manifest.permission.SET_WALLPAPER)
        }

        // Android 13+ 需要通知权限
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS)
                != PackageManager.PERMISSION_GRANTED) {
                permissions.add(Manifest.permission.POST_NOTIFICATIONS)
            }
        }

        if (permissions.isNotEmpty()) {
            ActivityCompat.requestPermissions(this, permissions.toTypedArray(), PERMISSIONS_REQUEST_CODE)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSIONS_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
                Toast.makeText(this, "权限已获取", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(this, "需要相关权限才能正常使用", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun startWallpaperService() {
        try {
            val serviceIntent = Intent(this, WallpaperUpdateService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(serviceIntent)
            } else {
                startService(serviceIntent)
            }
            updateStatus()
            Toast.makeText(this, "服务已启动", Toast.LENGTH_SHORT).show()
        } catch (e: Exception) {
            e.printStackTrace()
            Toast.makeText(this, "启动服务失败: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }

    private fun stopWallpaperService() {
        val serviceIntent = Intent(this, WallpaperUpdateService::class.java)
        stopService(serviceIntent)
        updateStatus()
        Toast.makeText(this, "服务已停止", Toast.LENGTH_SHORT).show()
    }

    private fun updateWallpaperNow() {
        try {
            WallpaperSetter.updateWallpaperWithCurrentTime(this)
        } catch (e: Exception) {
            e.printStackTrace()
            Toast.makeText(this, "更新失败: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }

    private fun updateStatus() {
        // 检查服务是否运行
        val isRunning = isServiceRunning()
        tvStatus.text = if (isRunning) "服务状态：运行中" else "服务状态：已停止"
    }

    private fun isServiceRunning(): Boolean {
        val manager = getSystemService(ACTIVITY_SERVICE) as android.app.ActivityManager
        return manager.getRunningServices(Integer.MAX_VALUE)
            .any { it.service.className == WallpaperUpdateService::class.java.name }
    }

    override fun onResume() {
        super.onResume()
        updateStatus()
    }
}
