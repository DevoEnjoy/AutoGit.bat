@echo off
rem 명령어 복창 끔

rem ### 버전정보	:	v0201_alpha
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
rem 		업데이트 23.02.01 커스텀 커밋 수정

cd /d %~dp0
rem 현재 파일 위치 경로를 작업 위치로


title 현재 경로 : %cd%
rem title AutoStaging & AutoCommit
:notice
rem 	230116 v0116_alpha
rem 		- add, restore, commit, push 구현
rem		230118 v0118_beta
rem			- hotfixes
rem		230119 v0119_alpha
rem			- add changeDate

:start
set choice=1
@echo off
echo ----------------------------------------------------------------------
git status
echo ----------------------------------------------------------------------
echo.
echo 	실행할 기능을 선택해 주세요
rem echo 	0. 
echo 	[1]. cd (작업 위치 이동)
echo 	[2]. git add(스테이징)
echo 	[3]. git restore(스테이징 내리기)
echo 	[4]. git commit(커밋)
echo 	[5]. git push(푸시)
echo 	[6]. 커밋 날짜 변경
echo 	[q]. 프로그램 종료
echo.
set /p choice=선택(예: 1 엔터) :

if %choice% equ 1 goto OnDirectory
if %choice% equ 2 goto add
if %choice% equ 3 goto restore
if %choice% equ 4 goto commit
if %choice% equ 5 goto push
if %choice% equ 6 goto changeDate
if /i %choice% equ q exit
goto start

rem ##########디렉터리 탐색##########
:OnDirectory
cls
title 현재 디렉터리 경로 : %cd%
set /a dirnum=0
set /a dirlistnum=1
rem #####디렉터리 리스트 배열[1~N]#####
set dirlist=NULL
for /f %%i in ('dir /a:d /b') do set /a dirnum=dirnum+1
if %dirnum% lss 1 goto NoDir
for /f "tokens=*" %%i in ('dir /a:d /b') do (set dirlist[%dirlistnum%]=%%i & goto LoadDirList)
:LoadDirList
set /a dirlistnum=dirlistnum+1
rem #####리스트의 인덱스는 1부터 시작, 따라서 문장스킵은 리스트의 인덱스 - 1#####
set /a skips=dirlistnum-1
if %skips% equ %dirnum% goto EOF
for /f "tokens=* skip=%skips%" %%i in ('dir /a:d /b') do (set dirlist[%dirlistnum%]=%%i & goto LoadDirList)
goto quit
:EOF
cls
git status
echo ----------------------------------------------------------------------
echo 현재 경로 : %cd%
echo ----------------------------------------------------------------------
for /l %%i in (1,1,%dirnum%) do echo %%i. !dirlist[%%i]!
echo %dirlistnum%. [..]상위 디렉터리로 가기
echo ----------------------------------------------------------------------
echo 현재 경로의 디렉터리 수 : %dirnum%
echo 현재 경로를 작업공간으로 설정하기 : [S] 입력(대소문자 무관)
set /a dirnum=dirnum+1
set dirlist[%dirlistnum%]=..
set /p Todir=Choice : 
if /i %Todir% equ S goto quitExplore
rem if %Todir% equ s goto quitExplore
set /a temp=Todir-1
if %Todir% gtr %dirnum% (echo 1~%dirnum%까지만 선택 가능합니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
if %temp% lss 0 (echo 1~%dirnum%까지만 선택 가능합니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
goto MvDir
:NoDir
cls
git status
echo ----------------------------------------------------------------------
echo 현재 경로 : %cd%
echo ----------------------------------------------------------------------
echo %dirlistnum%. [..]상위 디렉터리로 가기
echo ----------------------------------------------------------------------
echo 현재 경로의 디렉터리 수 : %dirnum%
echo 현재 경로를 작업공간으로 설정하기 : [S] 입력(대소문자 무관)
set /a dirnum=dirnum+1
set dirlist[%dirlistnum%]=..
set /p Todir=Choice : 
if /i %Todir% equ S goto quitExplore
rem if %Todir% equ s goto quitExplore
set /a temp=Todir-1
if %temp% neq 0 (echo 현재 디렉터리에 디렉터리가 없습니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
goto MvDir

:MvDir
cd !dirlist[%Todir%]!
cls
goto OnDirectory
:quitExplore
set /a skips=1
set /a number=1

cls & title 작업할 디렉터리 경로 : %cd%
goto start

:add

:addFor
set select=:
cls
echo ----------------------------------------------------------------------
git status
echo ----------------------------------------------------------------------
echo 	(현재 경로 : %cd%)
echo 	스테이징할 폴더나 파일을 띄어쓰기로 구분하여 입력해 주세요
echo 	ex) class .gitignore test.txt
echo 	모든 파일 스테이징 [.] 입력
echo 	메인으로 돌아가려면 [:q] 입력
set /p select=입력: 
rem echo %select%
if %select% equ :q cls&goto start
rem if "%select%==:" goto doStaging
set stagingList=%select%
cls
:doStaging
git add %stagingList%
echo ----------------------------------------------------------------------
echo 스테이징됨 : %stagingList%
echo ----------------------------------------------------------------------
echo Enter 입력시 메인으로
pause
cls
goto start

:restore
set restoreTemp=:q
cls
echo ----------------------------------------------------------------------
git status
echo ----------------------------------------------------------------------
rem echo 스테이징 취소 예정 : %restoreTemp%
echo 	커밋하지 않을, add된 파일이나 폴더를 모두 입력하세요.
echo 	메인으로 돌아가려면 [:q] 입력
set /p restoreTemp=입력: 
echo ----------------------------------------------------------------------

if %restoreTemp%==:q goto start

git restore --staged %restoreTemp%
echo ----------------------------------------------------------------------

goto start

:commit
set choiceCommit=q
cls
echo ----------------------------------------------------------------------
git status
echo ----------------------------------------------------------------------
echo 	-커밋 메시지 입력-
echo 	[1]. 직접 입력
echo 	[2]. 오토 커밋
echo 		형식:	"yyyyMMdd hhmm AutoCommit"
echo 		ex)	"20230116 1840 AutoCommit"
echo 	[q]. 메인메뉴로
set /p choiceCommit=입력 : 
if %choiceCommit% equ 1 goto customCommit
if %choiceCommit% equ 2 goto autoCommit
if %choiceCommit% equ q goto start
echo 	잘못입력하셨습니다.
pause
goto commit

:customCommit
set commitMsg=
cls
echo ----------------------------------------------------------------------
git status
echo ----------------------------------------------------------------------
echo 	커밋할 내용을 입력하세요
echo 	[q]. 메인메뉴로
set /p commitMsg=입력 : 
rem if commitMsg== echo 	잘못 입력하셨습니다&pause&goto customCommit
if /i %commitMsg% equ q goto start
pause
echo 	[git commit -m "%commitMsg%"]
echo 	위와 같이 명령어를 실행합니다.
set /p yon=[y/n]
if /i %yon% equ y goto doCommit
if /i %yon% equ n goto commit
cls
goto start

:doCommit
cls
git commit -m ^"%commitMsg%^"
pause
cls
echo ----------------------------------------------------------------------
echo 	commit Message : %commitMsg%
echo ----------------------------------------------------------------------
goto start

:autoCommit
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
cls
echo ----------------------------------------------------------------------
echo 	[commit : auto push %yyyymmdd% %hh%%mm%]
git commit -m "auto push %yyyymmdd% %hh%%mm%"
echo ----------------------------------------------------------------------
goto start

:push
cls
echo ----------------------------------------------------------------------
git status
echo ----------------------------------------------------------------------
echo 	푸시하시겠습니까?
echo 	[1]. git push origin master
echo 	[2]. 직접 입력
echo 	[q]. 메인메뉴로
set /p choicePush=choice: 
if %choicePush% equ 1 git push origin master&goto start
if %choicePush% equ 2 goto customPush
if %choicePush% equ q goto start
echo 	잘못 입력하셨습니다
pause
goto push

:customPush
echo 	### custom push ###
echo 	git push를 제외한 명령어를 입력해 주세요
echo 	ex) git push origin master ->
echo 	origin master 만 입력
rem echo 	push를 취소하려면 우측 상단의 X를 눌러 종료해주세요
echo 	[q]. 메인메뉴로 이동
set /p pushPath=입력: 
if %pushPath% equ q cls&goto start
echo 	[git push %pushPath%]
echo 	위 명령어를 실행합니다.
echo 	계속하려면 아무키 입력, 취소하려면 우측 상단의 x를 눌러주세요.
pause
git push %pushPath%
pause
cls
goto start


:changeDate
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

