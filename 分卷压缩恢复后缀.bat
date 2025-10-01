@echo off
chcp 936 >nul
setlocal enabledelayedexpansion

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 正在请求管理员权限...
    powershell -Command "Start-Process cmd -ArgumentList '/c %0' -Verb RunAs"
    exit /b
)

echo 已获得管理员权限
echo.

cd /d "%~dp0"
echo 当前目录: %cd%
echo.

set /p "file_ext=请输入文件后缀 (例如 zip、7z): "
echo.

if "%file_ext%"=="" (
    echo 错误: 未输入文件后缀!
    pause
    exit /b
)

echo 正在扫描文件...
echo.

set "file_count=0"

:: 使用循环处理001到999的分卷文件
for /l %%n in (1,1,999) do (
    :: 将数字格式化为三位数
    set "number=00%%n"
    set "number=!number:~-3!"
    
    :: 检查文件是否存在
    for %%i in (*.!number!.%file_ext%) do (
        if exist "%%i" (
            echo 找到文件: %%i
            set "filename=%%i"
            
            :: 提取文件名和数字部分
            for /f "tokens=1,2 delims=." %%a in ("%%i") do (
                set "name_part=%%a"
                set "number_part=%%b"
            )
            
            :: 构建新文件名
            set "new_filename=!name_part!.!file_ext!.!number_part!"
            
            echo 重命名: %%i  --^>  !new_filename!
            ren "%%i" "!new_filename!"
            
            if !errorlevel! equ 0 (
                echo 重命名成功
                set /a file_count+=1
            ) else (
                echo 错误: 重命名失败
            )
            echo.
        )
    )
)

echo.
echo 扫描完成!
echo 成功重命名: %file_count% 个文件
echo.

if %file_count% equ 0 (
    echo 未找到匹配的文件
    echo 支持的格式: 文件名.001.%file_ext%, 文件名.002.%file_ext% 等
)

pause