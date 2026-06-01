@echo off
echo ============================================
echo 恢复云电脑电源选项脚本
echo ============================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 请以管理员身份运行此脚本!
    echo 右键点击脚本 - "以管理员身份运行"
    pause
    exit /b 1
)

echo 正在恢复设置...
echo.

echo [1/4] 恢复开始菜单电源选项...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoClose" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoClose" /f >nul 2>&1

echo [2/4] 恢复 Ctrl+Alt+Del 选项...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableChangePassword" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableLockWorkstation" /f >nul 2>&1

echo [3/4] 恢复快捷键...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinKeys" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinKeys" /f >nul 2>&1

echo [4/4] 恢复 Win+X 菜单...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinX" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinX" /f >nul 2>&1

echo.
echo ============================================
echo 所有设置已恢复!
echo ============================================
echo.
echo 已恢复的功能:
echo ✓ 开始菜单电源按钮
echo ✓ Ctrl+Alt+Del 关机选项
echo ✓ Win+X 菜单关机选项
echo ✓ Windows 快捷键
echo.
echo 建议注销并重新登录以使所有设置生效。
echo.
pause
