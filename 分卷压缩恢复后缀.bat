@echo off
chcp 936 >nul
setlocal enabledelayedexpansion

:: ������ԱȨ��
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo �����������ԱȨ��...
    powershell -Command "Start-Process cmd -ArgumentList '/c %0' -Verb RunAs"
    exit /b
)

echo �ѻ�ù���ԱȨ��
echo.

cd /d "%~dp0"
echo ��ǰĿ¼: %cd%
echo.

set /p "file_ext=�������ļ���׺ (���� zip��7z): "
echo.

if "%file_ext%"=="" (
    echo ����: δ�����ļ���׺!
    pause
    exit /b
)

echo ����ɨ���ļ�...
echo.

set "file_count=0"

:: ʹ��ѭ������001��999�ķ־��ļ�
for /l %%n in (1,1,999) do (
    :: �����ָ�ʽ��Ϊ��λ��
    set "number=00%%n"
    set "number=!number:~-3!"
    
    :: ����ļ��Ƿ����
    for %%i in (*.!number!.%file_ext%) do (
        if exist "%%i" (
            echo �ҵ��ļ�: %%i
            set "filename=%%i"
            
            :: ��ȡ�ļ��������ֲ���
            for /f "tokens=1,2 delims=." %%a in ("%%i") do (
                set "name_part=%%a"
                set "number_part=%%b"
            )
            
            :: �������ļ���
            set "new_filename=!name_part!.!file_ext!.!number_part!"
            
            echo ������: %%i  --^>  !new_filename!
            ren "%%i" "!new_filename!"
            
            if !errorlevel! equ 0 (
                echo �������ɹ�
                set /a file_count+=1
            ) else (
                echo ����: ������ʧ��
            )
            echo.
        )
    )
)

echo.
echo ɨ�����!
echo �ɹ�������: %file_count% ���ļ�
echo.

if %file_count% equ 0 (
    echo δ�ҵ�ƥ����ļ�
    echo ֧�ֵĸ�ʽ: �ļ���.001.%file_ext%, �ļ���.002.%file_ext% ��
)

pause