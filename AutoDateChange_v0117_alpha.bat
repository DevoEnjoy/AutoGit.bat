@echo off
rem 명령어 복창 끔

rem ### 버전정보	:	v1.0.0
rem ### updated by LJS 

rem chcp 65001>nul
rem 참고 https://otrodevym.tistory.com/entry/windows-10-cmd-%EC%9D%B8%EC%BD%94%EB%94%A9-utf-8-%EC%84%A4%EC%A0%95-%EB%B0%A9%EB%B2%95-949-65001-1

setLocal EnableDelayedExpansion
rem 참고 https://kkamagistory.tistory.com/881

rem 0 = 검정색 8 = 회색
rem 1 = 파랑색 9 = 연한 파랑색
rem 2 = 초록색 A = 연한 초록색
rem 3 = 옥색 B = 연한 옥색
rem 4 = 빨강색 C = 연한 빨강색
rem 5 = 자주색 D = 연한 자주색
rem 6 = 노랑색 E = 연한 노랑색
rem 7 = 흰색 F = 밝은 흰색
rem color 09
rem 첫째 자리는 배경, 둘째 자리는 글자색

rem mode con cols=60 lines=30
rem 콘솔창 크기 지정

rem ####################################

cd /d %~dp0
rem 현재 파일 위치 경로를 작업 위치로


title 현재 경로 : %cd%
rem title AutoStaging & AutoCommit

:notice
rem 	230117 0938
rem 		- v01.17 init release
rem 	230117 1009
rem 		- v01.17.10 hotfix01

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
echo 	오늘 날짜 : %yyyymmdd%
echo 	현재 시각 : %hh%%mm%
echo.

echo 	실행할 기능을 선택하세요
rem echo 	1. 전부 스테이징
rem echo 	2. 오토 커밋
rem echo 	3. 오토 푸시
echo 	1. 커밋 날짜 변경(진입 직후 q)
echo 	2. 강제 푸시(날짜 변경 후 사용)
echo 	q. 종료
set /p choice=choice:

rem if %choice% equ 1 goto addAll
rem if %choice% equ 2 goto autoCommit
rem if %choice% equ 3 goto autoPush
if %choice% equ 1 goto changeDate
if %choice% equ 2 goto forcePush
if %choice% equ q exit
cls
goto start

:changeDate
cls
git log

echo 	날짜 변경 기능입니다.
echo 	가장 최근 커밋만 변경 가능합니다.
echo 	아래 형식에 맞게 변경할 날짜 및 시간을 입력해 주세요(연 월일 시분)
echo 	ex) 2023 0117 1817
set /p changedDate=입력 : 
cls
rem set hh=%time:~0,2%
set year=%changedDate:~0,4%
set month=%changedDate:~5,2%
set day=%changedDate:~7,2%
set times1=%changedDate:~10,2%
set times2=%changedDate:~12,2%

if %month% equ 01 set monthStr=Jan
if %month% equ 02 set monthStr=Feb
if %month% equ 03 set monthStr=Mar
if %month% equ 04 set monthStr=Apr
if %month% equ 05 set monthStr=May
if %month% equ 06 set monthStr=Jun
if %month% equ 07 set monthStr=Jul
if %month% equ 08 set monthStr=Aug
if %month% equ 09 set monthStr=Sep
if %month% equ 10 set monthStr=Oct
if %month% equ 11 set monthStr=Nov
if %month% equ 12 set monthStr=Dec

rem if %month:~0,1% equ 0 (
rem 	if %month:~1,1% equ 1 set month=Jan
rem 	if %month:~1,1% equ 2 set month=Feb
rem 	if %month:~1,1% equ 3 set month=Mar
rem 	if %month:~1,1% equ 4 set month=Apr
rem 	if %month:~1,1% equ 5 set month=May
rem 	if %month:~1,1% equ 6 set month=Jun
rem 	if %month:~1,1% equ 7 set month=Jul
rem 	if %month:~1,1% equ 8 set month=Aug
rem 	if %month:~1,1% equ 9 set month=Sep
rem )else (
rem 	rem 10월
rem 	if %month:~1,1% equ 0 set month=Oct
rem 	if %month:~1,1% equ 1 set month=Nov
rem 	if %month:~1,1% equ 2 set month=Dec
rem )

echo 	아래와 같이 명령어를 사용합니다
echo.
echo 	git commit --amend --no-edit --date "%monthStr% %day% %times1%:%times2%:31 %year% +0000"
echo 	GIT_COMMITTER_DATE="Thu %day% %monthStr% %year% %times1%:%times2%:15 KST" git commit --amend --no-edit
echo.
echo 	사용하려면 엔터, 취소하려면 창을 닫아주세요
pause
goto start

:forcePush
cls
echo.
echo 	강제 푸시입니다. 아래 명령어를 사용합니다
echo 	git push -f origin master
echo 	진행하려면 엔터, 취소 혹은 따로 입력하려면 창을 닫아주세요
pause
cls
git push -f origin master
pause
goto start




rem :addAll
rem git add .
rem pause
rem cls
rem echo 	현재 상태 : 
rem git status
rem pause
rem 
rem goto choice
rem 
rem :autoCommit
rem echo 	"auto push %yyyymmdd%%hh%%mm%"
rem echo 	위 내용으로 커밋합니다
rem echo 	실행은 엔터, 취소하려면 창을 꺼주세요
rem pause
rem git commit -m "auto push %yyyymmdd%%hh%%mm%"
rem 
rem goto choice
rem 
rem :autoPush
rem echo 	커밋한 내용을 푸시합니다
rem echo 	실행은 엔터, 취소하려면 창을 꺼주세요
rem 
rem pause
rem 
rem git push origin master
rem 
rem goto choice
