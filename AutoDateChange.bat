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
echo 	1. 커밋 날짜 변경
echo 	q. 종료
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
echo 	날짜 변경 기능입니다.
echo 	가장 최근 커밋만 변경 가능합니다.
echo 	아래 형식에 맞게 변경할 날짜 및 시간을 입력해 주세요(연 월일 시분)
echo 	ex) 2023 0117 1817
set /p changedDate=입력 : 
cls
rem set hh=%time:~0,2%
set %year%=%changedDate:~0,4%
set %month%=%changedDate:~6,2%
set %day%=%changedDate:~7,2%
set %times1%=%changedDate:~11,2%
set %times2%=%changedDate:~13,2%


if %month:~0,1% equ 0 (
	if %month:~0,2% equ 1 set month=Jan
	if %month:~0,2% equ 2 set month=Feb
	if %month:~0,2% equ 3 set month=Mar
	if %month:~0,2% equ 4 set month=Apr
	if %month:~0,2% equ 5 set month=May
	if %month:~0,2% equ 6 set month=Jun
	if %month:~0,2% equ 7 set month=Jul
	if %month:~0,2% equ 8 set month=Aug
	if %month:~0,2% equ 9 set month=Sep
)else (
	rem 10월
	if %month:~0,2% equ 0 set month=Oct
	if %month:~0,2% equ 1 set month=Nov
	if %month:~0,2% equ 2 set month=Dec
)

echo 	아래 명령어를 사용합니다
echo 	 git commit --amend --no-edit --date "%month% %day% %times1%:%times2%%:31 %year% +0000"
echo 	사용하려면 엔터, 취소하려면 창을 닫아주세요

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
