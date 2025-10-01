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

:: 扫描所有匹配 *.%file_ext%.* 格式的文件
for /f "delims=" %%i in ('dir /b /a-d *.%file_ext%.* 2^>nul') do (
    echo 找到文件: %%i
    set "filename=%%i"
    
    :: 正确的文件名解析
    for /f "tokens=1,2,3 delims=." %%a in ("%%i") do (
        set "name_part=%%a"
        set "ext_part=%%b"
        set "number_part=%%c"
    )
    
    :: 确保我们找到的是正确的文件格式
    if "!ext_part!"=="%file_ext%" (
        :: 构建新文件名
        set "new_filename=!name_part!.!number_part!.!file_ext!"
        
        echo 重命名: %%i  --^>  !new_filename!
        ren "%%i" "!new_filename!"
        
        if !errorlevel! equ 0 (
            echo 重命名成功
            set /a file_count+=1
        ) else (
            echo 错误: 重命名失败
        )
        echo.
    ) else (
        echo 跳过 !filename! - 格式不匹配
        echo.
    )
)

echo.
echo 扫描完成!
echo 成功重命名: %file_count% 个文件
echo.

if %file_count% equ 0 (
    echo 未找到匹配的文件
    echo 支持的格式: 文件名.%file_ext%.001, 文件名.%file_ext%.002 等
    echo.
    echo 当前目录下的文件列表:
    dir /b *.%file_ext%.* 2>nul || echo 没有找到匹配文件
)

pause