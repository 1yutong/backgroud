# 锁屏时间壁纸应用

一个自动更新锁屏壁纸的 Android 应用，实时显示当前时间和日期。

## 功能特点

- 📱 自动定时更新锁屏壁纸
- ⏰ 实时显示当前时间和日期
- 🎨 美观的渐变背景
- 🔄 开机自启动
- 📊 前台服务确保持续运行

## 技术实现

- **语言**：Kotlin
- **架构**：前台服务 + 定时任务
- **权限**：设置壁纸、前台服务、开机启动

## 构建和安装

### 前提条件

- [Android Studio](https://developer.android.com/studio)
- JDK 8 或更高版本
- Android 设备或模拟器（API 24+）

### 构建步骤

1. **克隆项目**
   ```bash
   git clone <repository-url>
   ```

2. **打开项目**
   - 启动 Android Studio
   - 选择 "Open an existing project"
   - 导航到 `LockScreenWallpaper` 文件夹

3. **同步依赖**
   - 点击 "Sync Project with Gradle Files"
   - 等待 Gradle 同步完成

4. **构建项目**
   - 点击 "Build" → "Make Project"
   - 或者使用快捷键 `Ctrl+F9` (Windows) / `Cmd+F9` (Mac)

5. **安装到设备**
   - 连接 Android 设备（开启 USB 调试）
   - 点击 "Run" → "Run 'app'"
   - 或者使用快捷键 `Shift+F10` (Windows) / `Ctrl+R` (Mac)

## 使用方法

1. **首次打开应用**
   - 授予必要的权限（设置壁纸、通知）

2. **启动服务**
   - 点击 "启动自动更新服务"
   - 应用会开始在后台运行

3. **查看状态**
   - 应用会显示当前服务状态
   - 通知栏会显示服务运行状态

4. **手动更新**
   - 点击 "立即更新壁纸" 可以手动触发更新

5. **停止服务**
   - 点击 "停止服务" 可以停止自动更新

## 权限说明

- `SET_WALLPAPER` - 设置壁纸权限
- `FOREGROUND_SERVICE` - 前台服务权限
- `RECEIVE_BOOT_COMPLETED` - 开机启动权限
- `POST_NOTIFICATIONS` - 通知权限（Android 13+）

## 技术细节

- **更新频率**：每分钟自动更新一次
- **壁纸分辨率**：1080x1920（适合大多数手机）
- **后台运行**：使用前台服务确保在后台持续运行
- **开机自启**：设备重启后自动恢复服务

## 常见问题

### 服务不运行
- 检查是否授予了所有必要的权限
- 检查设备是否限制了应用的后台活动
- 在系统设置中允许应用自启动

### 壁纸更新不及时
- 检查服务是否正在运行
- 检查设备电量是否充足
- 检查网络连接（如果使用网络时间）

### 低版本 Android 兼容性
- Android 7.0 以下版本会同时设置桌面和锁屏壁纸
- Android 7.0+ 支持单独设置锁屏壁纸

## 项目结构

```
LockScreenWallpaper/
├── app/
│   ├── src/main/
│   │   ├── java/com/example/lockscreenwallpaper/
│   │   │   ├── MainActivity.kt          # 主界面
│   │   │   ├── WallpaperGenerator.kt    # 生成带时间的壁纸
│   │   │   ├── WallpaperManager.kt      # 设置锁屏壁纸
│   │   │   ├── WallpaperUpdateService.kt # 后台更新服务
│   │   │   ├── AlarmReceiver.kt         # 定时任务接收器
│   │   │   └── BootReceiver.kt          # 开机启动接收器
│   │   ├── res/                         # 资源文件
│   │   └── AndroidManifest.xml          # 应用配置
│   └── build.gradle                     # 模块配置
├── build.gradle                         # 项目配置
└── settings.gradle                      # 项目设置
```

## 许可证

MIT License
