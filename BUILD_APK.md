# 构建 Android APK 指南

## 方案一：使用 Android Studio 构建（推荐）

### 1. 安装 Android Studio
- 下载地址：https://developer.android.com/studio
- 安装完成后，首次启动会自动下载 Android SDK

### 2. 导入项目
- 打开 Android Studio
- 选择 "Open an existing project"
- 导航到 `LockScreenWallpaper` 文件夹

### 3. 同步项目
- 点击 "Sync Project with Gradle Files"
- 等待依赖下载和同步完成

### 4. 构建 Debug APK
- 点击菜单：Build → Build Bundle(s) / APK(s) → Build APK(s)
- 等待构建完成
- APK 文件位置：`LockScreenWallpaper/app/build/outputs/apk/debug/app-debug.apk`

### 5. 构建 Release APK（用于发布）
- 在 `app/build.gradle` 中配置签名信息
- 点击菜单：Build → Generate Signed Bundle / APK
- 选择 APK，配置签名信息
- 构建完成后：`LockScreenWallpaper/app/build/outputs/apk/release/app-release.apk`

## 方案二：使用命令行构建

### 1. 安装必要工具
```bash
# 安装 JDK
sudo apt install openjdk-11-jdk

# 安装 Android SDK
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux-9477386_latest.zip
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# 接受许可
yes | sdkmanager --licenses

# 安装必要组件
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

### 2. 构建项目
```bash
cd LockScreenWallpaper

# 构建 Debug 版本
./gradlew assembleDebug

# 构建 Release 版本
./gradlew assembleRelease
```

### 3. APK 位置
- Debug: `app/build/outputs/apk/debug/app-debug.apk`
- Release: `app/build/outputs/apk/release/app-release.apk`

## 方案三：使用在线构建服务

### 1. GitHub Actions
创建 `.github/workflows/build.yml`:
```yaml
name: Build APK

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Set up JDK 11
      uses: actions/setup-java@v2
      with:
        java-version: '11'
        distribution: 'temurin'
    - name: Grant execute permission for gradlew
      run: chmod +x gradlew
    - name: Build with Gradle
      run: ./gradlew assembleDebug
    - name: Upload APK
      uses: actions/upload-artifact@v2
      with:
        name: app-debug
        path: app/build/outputs/apk/debug/app-debug.apk
```

### 2. 使用 GitHub Actions
- 推送代码到 GitHub
- Actions 会自动构建 APK
- 在 Actions 页面下载构建的 APK

## 方案四：使用 CI/CD 平台

### 1. Bitrise
- 注册账号：https://www.bitrise.io
- 连接 GitHub 仓库
- 配置构建流程
- 自动构建 APK

### 2. CircleCI
- 注册账号：https://circleci.com
- 连接 GitHub 仓库
- 配置 `.circleci/config.yml`
- 自动构建 APK

## 应用功能说明

### 主要功能
1. **自动更新壁纸**：每分钟自动更新锁屏壁纸
2. **实时显示时间**：显示当前时间和日期
3. **美观界面**：深色渐变背景
4. **后台运行**：前台服务确保持续运行
5. **开机自启**：设备重启后自动恢复

### 使用方法
1. 安装 APK 到手机
2. 打开应用，授予必要权限
3. 点击"启动自动更新服务"
4. 应用会在后台运行，自动更新锁屏壁纸
5. 锁屏时会显示当前时间和日期

### 权限需求
- SET_WALLPAPER - 设置壁纸
- FOREGROUND_SERVICE - 前台服务
- RECEIVE_BOOT_COMPLETED - 开机启动
- POST_NOTIFICATIONS - 通知（Android 13+）

## 注意事项

1. **Android 版本**：支持 Android 7.0+ (API 24+)
2. **电池优化**：需要在系统设置中关闭应用的电池优化
3. **自启动权限**：部分手机需要手动授予自启动权限
4. **后台运行**：部分国产 ROM 可能限制后台服务，需要在设置中允许
