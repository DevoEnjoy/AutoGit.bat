@echo off
rem 명령어 복창 끔

rem ### 버전정보	:	v0116_alpha
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
rem 	230116 v0116_alpha
rem 		- add, restore, commit, push 구현

:start
@echo off
echo ----------------------------------------------------------------------
git status
echo ----------------------------------------------------------------------
echo.
echo 	실행할 기능을 선택해 주세요
rem echo 	0. 
echo 	1. cd (작업 위치 이동)
echo 	2. git add(스테이징)
echo 	3. git restore(스테이징 내리기)
echo 	4. git commit(커밋)
echo 	5. git push(푸시)
echo 	6. (※미구현)커밋 날짜 변경
echo 	q. 프로그램 종료
echo.
set /p choice=선택(예: 1 엔터) :

if %choice% equ 1 goto OnDirectory
if %choice% equ 2 goto add
if %choice% equ 3 goto restore
if %choice% equ 4 goto commit
if %choice% equ 5 goto push
if %choice% equ 6 goto date
if %choice% equ q exit
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
echo 현재 경로 : %cd%
echo ----------------------------------------------------------------------
for /l %%i in (1,1,%dirnum%) do echo %%i. !dirlist[%%i]!
echo %dirlistnum%. [..]상위 디렉터리로 가기
echo ----------------------------------------------------------------------
echo 현재 경로의 디렉터리 수 : %dirnum%
echo 현재 경로를 작업공간으로 설정하기 : S
set /a dirnum=dirnum+1
set dirlist[%dirlistnum%]=..
set /p Todir=Choice : 
if %Todir% equ S goto quitExplore
if %Todir% equ s goto quitExplore
set /a temp=Todir-1
if %Todir% gtr %dirnum% (echo 1~%dirnum%까지만 선택 가능합니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
if %temp% lss 0 (echo 1~%dirnum%까지만 선택 가능합니다. & pause>nul & cls & set /a dirnum=dirnum-1 & goto EOF)
goto MvDir
:NoDir
echo 현재 경로 : %cd%
echo ----------------------------------------------------------------------
echo %dirlistnum%. [..]상위 디렉터리로 가기
echo ----------------------------------------------------------------------
echo 현재 경로의 디렉터리 수 : %dirnum%
echo 현재 경로를 작업공간으로 설정하기 : S
set /a dirnum=dirnum+1
set dirlist[%dirlistnum%]=..
set /p Todir=Choice : 
if %Todir% equ S goto quitExplore
if %Todir% equ s goto quitExplore
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
echo 	모든 파일 스테이징 : . 입력
echo 	메인으로 돌아가려면 :q 입력
set /p select=입력: 
rem echo %select%
if %select%==:q cls&goto start
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
set restoreTemp=
cls
echo ----------------------------------------------------------------------
git status
echo ----------------------------------------------------------------------
rem echo 스테이징 취소 예정 : %restoreTemp%
echo 	커밋하지 않을, add된 파일이나 폴더를 모두 입력하세요.
echo 	메인으로 돌아가려면 :q 입력
set /p restoreTemp=입력: 
echo ----------------------------------------------------------------------

if %restoreTemp%==:q goto start

git restore --staged %restoreTemp%
echo ----------------------------------------------------------------------

goto start

:commit
cls
echo ----------------------------------------------------------------------
git status
echo ----------------------------------------------------------------------
echo 	-커밋 메시지 입력-
echo 	1. 직접 입력
echo 	2. 오토 커밋
echo 		형식:	"yyyyMMdd hhmm AutoCommit"
echo 		ex)	"20230116 1840 AutoCommit"
echo 	q. 메인메뉴로
set /p choiceCommit=입력 : 
if %choiceCommit% equ 1 goto customCommit
if %choiceCommit% equ 2 goto autoCommit
if %choiceCommit% equ q goto start
echo 	잘못입력하셨습니다.
pause
goto commit

:customCommit
cls
echo ----------------------------------------------------------------------
git status
echo ----------------------------------------------------------------------
echo 	커밋할 내용을 입력하세요
echo 	q. 메인메뉴로
set /p commitMsg=입력 : 
if "%commitMsg%==" echo 	잘못 입력하셨습니다&pause&goto customCommit
if %commitMsg% equ q goto start
git commit -m "%commitMsg%"
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
echo 	1. git push origin master
echo 	2. 직접 입력
echo 	q. 메인메뉴로
set /p choicePush=choice: 
if %choicePush% equ 1 git push origin master&pause&goto start
if %choicePush% equ 2 goto customPush
if %choicePush% equ q goto start
echo 	잘못 입력하셨습니다
pause
goto push

:customPush
echo 	custom push
echo 	git push를 제외한 명령어를 입력해 주세요
echo 	ex) git push origin master 라면
echo 	origin master 만 입력
echo 	push를 취소하려면 우측 상단의 X를 눌러 종료해주세요
set /p pushPath=입력: 
if "%pushPath%==" cls&goto customPush
git push %pushPath%
pause
cls
goto start


:date
goto start

