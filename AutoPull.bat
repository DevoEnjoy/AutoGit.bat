@echo off
rem ���ɾ� ��â ��

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
rem 	230117 1013
rem 		- v01.17 init release


:start
cls
git pull origin master

pause