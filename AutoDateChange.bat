@echo off
rem ��ɾ� ��â ��

rem ### ��������	:	v1.0.0
rem ### updated by LJS 

rem chcp 65001>nul
rem ���� https://otrodevym.tistory.com/entry/windows-10-cmd-%EC%9D%B8%EC%BD%94%EB%94%A9-utf-8-%EC%84%A4%EC%A0%95-%EB%B0%A9%EB%B2%95-949-65001-1

setLocal EnableDelayedExpansion
rem ���� https://kkamagistory.tistory.com/881

rem 0 = ������ 8 = ȸ��
rem 1 = �Ķ��� 9 = ���� �Ķ���
rem 2 = �ʷϻ� A = ���� �ʷϻ�
rem 3 = ���� B = ���� ����
rem 4 = ������ C = ���� ������
rem 5 = ���ֻ� D = ���� ���ֻ�
rem 6 = ����� E = ���� �����
rem 7 = ��� F = ���� ���
rem color 09
rem ù° �ڸ��� ���, ��° �ڸ��� ���ڻ�

rem mode con cols=60 lines=30
rem �ܼ�â ũ�� ����

rem ####################################

cd /d %~dp0
rem ���� ���� ��ġ ��θ� �۾� ��ġ��


title ���� ��� : %cd%
rem title AutoStaging & AutoCommit

:notice
rem 	230117 0938
rem 		- v01.17 init release

:start
cls
FOR /F "tokens=1-4 delims=- " %%i IN ('date /t') DO SET yyyymmdd=%%i%%j%%k
REM FOR /F "tokens=2-6 delims=/ " %%i IN ('date /t') DO SET yyyymmdd=%%k%%i%%j
rem ECHO %yyyymmdd%

set tm=%time%
set hh=%time:~0,2%
set mm=%time:~3,2%
set ss=%time:~6,2%
set hh1=%time:~0,1%
set hh2=%time:~1,1%
if "%hh1%" == " " set hh=0%hh2%

rem echo original time = %tm%
rem echo transformed time = %hh%%mm%
:choice
echo 	���� ��¥ : %yyyymmdd%
echo 	���� �ð� : %hh%%mm%
echo.

echo 	������ ����� �����ϼ���
rem echo 	1. ���� ������¡
rem echo 	2. ���� Ŀ��
rem echo 	3. ���� Ǫ��
echo 	1. Ŀ�� ��¥ ����(���� ���� q �Է�)
echo 	q. ����
set /p choice=choice:

rem if %choice% equ 1 goto addAll
rem if %choice% equ 2 goto autoCommit
rem if %choice% equ 3 goto autoPush
if %choice% equ 1 goto changeDate
if %choice% equ q exit
cls
goto start

:changeDate
cls
git log

echo 	��¥ ���� ����Դϴ�.
echo 	���� �ֱ� Ŀ�Ը� ���� �����մϴ�.
echo 	�Ʒ� ���Ŀ� �°� ������ ��¥ �� �ð��� �Է��� �ּ���(�� ���� �ú�)
echo 	ex) 2023 0117 1817
set /p changedDate=�Է� : 
cls
rem set hh=%time:~0,2%
set %year%=%changedDate:~0,4%
set %month%=%changedDate:~6,2%
set %day%=%changedDate:~7,2%
set %times1%=%changedDate:~11,2%
set %times2%=%changedDate:~13,2%


if %month:~0,1% equ 0 (
	if %month:~1,2% equ 1 set month=Jan
	if %month:~1,2% equ 2 set month=Feb
	if %month:~1,2% equ 3 set month=Mar
	if %month:~1,2% equ 4 set month=Apr
	if %month:~1,2% equ 5 set month=May
	if %month:~1,2% equ 6 set month=Jun
	if %month:~1,2% equ 7 set month=Jul
	if %month:~1,2% equ 8 set month=Aug
	if %month:~1,2% equ 9 set month=Sep
)else (
	rem 10��
	if %month:~1,2% equ 0 set month=Oct
	if %month:~1,2% equ 1 set month=Nov
	if %month:~1,2% equ 2 set month=Dec
)

echo 	�Ʒ� ��ɾ ����մϴ�
echo 	 git commit --amend --no-edit --date "%month% %day% %times1%:%times2%%:31 %year% +0000"
echo 	����Ϸ��� ����, ����Ϸ��� â�� �ݾ��ּ���

goto start

rem :addAll
rem git add .
rem pause
rem cls
rem echo 	���� ���� : 
rem git status
rem pause
rem 
rem goto choice
rem 
rem :autoCommit
rem echo 	"auto push %yyyymmdd%%hh%%mm%"
rem echo 	�� �������� Ŀ���մϴ�
rem echo 	������ ����, ����Ϸ��� â�� ���ּ���
rem pause
rem git commit -m "auto push %yyyymmdd%%hh%%mm%"
rem 
rem goto choice
rem 
rem :autoPush
rem echo 	Ŀ���� ������ Ǫ���մϴ�
rem echo 	������ ����, ����Ϸ��� â�� ���ּ���
rem 
rem pause
rem 
rem git push origin master
rem 
rem goto choice
