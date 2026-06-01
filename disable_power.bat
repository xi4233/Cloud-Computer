@echo off
echo ============================================
echo 云电脑电源选项全禁脚本
echo 防范所有关机途径
echo ============================================
echo.
echo 此脚本将禁用以下功能:
echo - 开始菜单电源按钮
echo - Ctrl+Alt+Del 中的关机选项
echo - Alt+F4 关机对话框
echo - Win+X 菜单中的关机选项
echo - 关机快捷键(部分键盘)
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 请以管理员身份运行此脚本!
    echo 右键点击脚本 - "以管理员身份运行"
    pause
    exit /b 1
)

echo 正在应用设置...
echo.

REM 1. 移除开始菜单中的"关机"命令
echo [1/4] 禁用开始菜单电源选项...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoClose" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoClose" /t REG_DWORD /d 1 /f >nul 2>&1

REM 2. 禁用 Ctrl+Alt+Del 界面中的更改密码和任务管理器(防止通过任务管理器关机)
echo [2/4] 禁用 Ctrl+Alt+Del 相关选项...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableChangePassword" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableLockWorkstation" /t REG_DWORD /d 1 /f >nul 2>&1

REM 3. 禁用关机快捷键和系统热键
echo [3/4] 禁用关机快捷键...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinKeys" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinKeys" /t REG_DWORD /d 1 /f >nul 2>&1

REM 4. 禁用 Win+X 高级用户菜单(包含关机选项)
echo [4/4] 禁用 Win+X 菜单...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinX" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinX" /t REG_DWORD /d 1 /f >nul 2>&1

echo.
echo ============================================
echo 所有设置已完成!
echo ============================================
echo.
echo 已禁用的关机途径:
echo ✓ 开始菜单电源按钮
echo ✓ Ctrl+Alt+Del 关机选项
echo ✓ Win+X 菜单关机选项
echo ✓ Windows 快捷键(Win键相关)
echo.
echo 注意:
echo - Alt+F4 在桌面仍可能弹出关机对话框(无法完全禁用)
echo - 命令行 shutdown 命令仍然有效(需要管理员权限)
echo - 物理电源按钮行为需在电源选项中设置
echo - 可能需要注销或重启使所有设置生效
echo.
echo 如需恢复,请以管理员身份运行 enable_power.bat
echo.
pause
