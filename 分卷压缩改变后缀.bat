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

:: ɨ������ƥ�� *.%file_ext%.* ��ʽ���ļ�
for /f "delims=" %%i in ('dir /b /a-d *.%file_ext%.* 2^>nul') do (
    echo �ҵ��ļ�: %%i
    set "filename=%%i"
    
    :: ��ȷ���ļ�������
    for /f "tokens=1,2,3 delims=." %%a in ("%%i") do (
        set "name_part=%%a"
        set "ext_part=%%b"
        set "number_part=%%c"
    )
    
    :: ȷ�������ҵ�������ȷ���ļ���ʽ
    if "!ext_part!"=="%file_ext%" (
        :: �������ļ���
        set "new_filename=!name_part!.!number_part!.!file_ext!"
        
        echo ������: %%i  --^>  !new_filename!
        ren "%%i" "!new_filename!"
        
        if !errorlevel! equ 0 (
            echo �������ɹ�
            set /a file_count+=1
        ) else (
            echo ����: ������ʧ��
        )
        echo.
    ) else (
        echo ���� !filename! - ��ʽ��ƥ��
        echo.
    )
)

echo.
echo ɨ�����!
echo �ɹ�������: %file_count% ���ļ�
echo.

if %file_count% equ 0 (
    echo δ�ҵ�ƥ����ļ�
    echo ֧�ֵĸ�ʽ: �ļ���.%file_ext%.001, �ļ���.%file_ext%.002 ��
    echo.
    echo ��ǰĿ¼�µ��ļ��б�:
    dir /b *.%file_ext%.* 2>nul || echo û���ҵ�ƥ���ļ�
)

pause