@echo off
REM  使用 UTF-8 编码方式来保存脚本
chcp 65001>nul
setlocal enabledelayedexpansion
cd /d "%~dp0"
c:

REM 检测管理员权限 
net session >nul 2>&1
if %errorLevel% == 0 (
    echo "权限满足" >nul
) else (
    echo "权限不足!"
    echo "请关闭窗口后重新右键以管理员运行cmd"
    echo "脚本即将退出..."
    ping 127.0.0.1 -n 3 >nul
    exit
)

set folderPath=C:\Program Files (x86)
set rime_folder=Rime
set weasel_server=WeaselServer.exe
set Project_DL=C:\Users\%USERNAME%\Downloads\092DL_temp
if not exist "%Project_DL%" mkdir "%Project_DL%"

set mirrors=https://ghproxy.com/https://github.com/ ^
    https://hub.fgit.ml/ ^
    https://kgithub.com/ ^
    https://hub.fgit.gq/ ^
    https://github.moeyy.xyz/https://github.com/ ^
    https://hub.njuu.cf/ ^
    https://hub.yzuu.cf/ ^
    https://github.com.cnpmjs.org/ ^
    https://github.com/

set raw_mirrors=https://ghproxy.com/https://raw.githubusercontent.com/ ^
    https://raw.iqiq.io/ ^
    https://raw.kgithub.com/ ^
    https://ghp.quickso.cn/https://raw.githubusercontent.com/ ^
    https://github.com/https://raw.githubusercontent.com/


set user=mlzzz
set repo=092wb
set weasel_user=rime
set weasel_repo=weasel
set version=0.14.3
set weasel_name=weasel-0.14.3.0-installer

set mb=%repo%
set Project_092_Dir=%Project_DL%\%mb%
set tables=%Project_092_Dir%

call :path_UD  >nul 2>&1
set "schema_file=%UserDir%\092wb.schema.yaml"
set "default_file=%UserDir%\default.custom.yaml"
set "weasel_file=%UserDir%\weasel.custom.yaml"
set "extended_file=%UserDir%\092wb.extended.dict.yaml"
set "temp_file=%UserDir%\temp.yaml"

set "font=%SystemRoot%\Fonts"
set "fontdir=%tables%\fonts"
set "etymon=092.otf"
set "msyhfont=MSYH.TTC"
set "fontkey=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
set "fallback=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\LanguagePack\SurrogateFallback"
set "linkkey=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink"




:main
if "%1"=="" (
    echo 命令中的参数不能为空
    ping 127.0.0.1 -n 3 >nul
    exit
) 
if "%1"=="b" (
    call :backup
) else if "%1"=="r" (
    call :restore
) else if "%1"=="092" (
    call :wb_092
) else if "%1"=="en" (
    call :en_zh_092
) else if "%1"=="zh" (
    call :en_zh_092
) else if "%1"=="h" (
    call :vh
) else if "%1"=="v" (
    call :vh
) else if "%1"=="s" (
    call :spelling
) else if "%1"=="ns" (
    call :spelling
) else if "%1"=="d" (
    call :rk
) else if "%1"=="z" (
    call :rk
) else if "%1"=="d-092" (
    call :switch_dicts_092
) else if "%1"=="d-092k" (
    call :switch_dicts_092k
) else if "%1"=="d-092K" (
    call :switch_dicts_092k
) else if "%1"=="d-092p" (
    call :switch_dicts_092p
) else if "%1"=="d-092P" (
    call :switch_dicts_092p
) else if "%1"=="clover" (
    call :py_clover
) else if "%1"=="unclover" (
    call :unclover
) else if "%1"=="c" (
    call :Clear_Project_DL
) else (
    echo 非法参数，请输入正确的命令。
    ping 127.0.0.1 -n 3 >nul
    exit
)
shift
REM 跳转到：next 标签
if not "%1"=="" goto :main

:next
echo "即将唤醒算法服务"
ping -n 2 127.0.0.1>nul
start "" "%regvalue%\WeaselServer.exe"
echo "唤醒算法服务成功"
ping -n 2 127.0.0.1>nul
echo 准备重新布署
ping -n 2 127.0.0.1>nul
echo "正在重新布署,请耐心等待..."
"%regvalue%/WeaselDeployer.exe" /deploy
ping -n 5 127.0.0.1>nul
echo "布署完成!"
ping 127.0.0.1 -n 2 -w 2000 >nul
echo "5s 后即将退出, 你可以按 Ctrl+C 终止退出"
ping 127.0.0.1 -n 2 -w 1000 >nul
echo "4s 后即将退出, 你可以按 Ctrl+C 终止退出"
ping 127.0.0.1 -n 2 -w 1000 >nul
echo "3s 后即将退出, 你可以按 Ctrl+C 终止退出"
ping 127.0.0.1 -n 2 -w 1000 >nul
echo "2s 后即将退出, 你可以按 Ctrl+C 终止退出"
ping 127.0.0.1 -n 2 -w 1000 >nul
echo "1s 后即将退出, 你可以按 Ctrl+C 终止退出"
ping 127.0.0.1 -n 2 -w 1000 >nul
echo 退出成功
endlocal
exit



:wb_092
call :base
call :first_install
goto :eof

:py_clover
call :path_UD  >nul 2>&1
if exist "%Project_DL%\%repo%\clover\clover.schema.yaml" (
    echo 找到 clover 文件
    xcopy /S "%Project_DL%\%repo%\clover" "%UserDir%" >nul 2>&1
) else (
    echo 没找到 clover 文件，准备 clone
    call :base
)
call :clover
goto :eof

:switch_dicts_092k
set dict_dir=dicts
set dict_file_name=092K.dict
set dict_name=092K
echo 准备更换^&更新词库
call :dictionarys
goto :eof

:switch_dicts_092p
set dict_dir=dicts
set dict_file_name=092P.dict
set dict_name=092P
echo 准备更换^&更新词库
call :dictionarys
goto :eof

:switch_dicts_092
set dict_dir=092
set dict_file_name=092wb.dict
set dict_name=092wb
echo 准备更换^&更新词库
call :dictionarys
goto :eof


:base
REM 检测是否安装 Git
echo %PATH% | find /i "git" >nul 2>nul
if %errorlevel% equ 0 (
    echo "在 PATH 中检测到 Git"
    git --version >nul 2>nul
    ping 127.0.0.1 -n 2 >nul
    if %errorlevel% equ 0 (
	echo "Git 命令已安装"
    ) else (
	REM 在默认安装目录中查找
        if exist "%ProgramFiles%\Git\bin\git.exe" (
	    echo 在默认安装目录中找到 Git
	    echo 准备添加到PATH
            ping 127.0.0.1 -n 2 >nul
	    set PATH=%PATH%;C:\Program Files\Git\bin
            ping 127.0.0.1 -n 2 >nul
	    echo 添加 PATH 完成
        ) else (
	    echo 在默认安装目录中没有找到 Git
	    echo 准备安装新的 Git
	    call :install_git
            ping 127.0.0.1 -n 2 >nul
	    echo Git 安装完成
        )
    )
) else (
    echo 未在 PATH 中检测到 Git
    REM 在默认安装目录中查找
    if exist "%ProgramFiles%\Git\bin\git.exe" (
        echo 在默认安装目录中找到 Git
        echo 准备添加到PATH
        ping 127.0.0.1 -n 2 >nul
	set PATH=%PATH%;C:\Program Files\Git\bin
        ping 127.0.0.1 -n 2 >nul
        echo 添加 PATH 完成
    ) else (
        echo 在默认安装目录中没有找到 Git
        echo 准备安装新的 Git
        call :install_git
        ping 127.0.0.1 -n 2 >nul
        echo Git 安装完成
    )
)


REM 检测是否安装小狼毫
tasklist /FI "IMAGENAME eq %weasel_server%" 2>NUL | find /I /N "%weasel_server%">NUL
if "%ERRORLEVEL%"=="0" (
REM echo 检测到已安装小狼毫
) else (
   if exist "%folderPath%\%rime_folder%" (
       set count=0
       for /d %%i in ("%folderPath%\%rime_folder%\*") do (
           set /a count+=1
       )
       if !count! equ 0 (
           echo 检测到未安装小狼毫,准备执行安装.
           echo 正在下载...
           call :install_weasel
           call :checkProcess
           echo 已完成安装小狼毫!
       ) else (
           echo 找到 rime 目录
           for /d %%i in ("%folderPath%\%rime_folder%\*") do (
               if exist "%%i\%weasel_server%" (
                   echo 找到 %weasel_server% 在 %%~nxi 目录.
                   echo 检测到已安装小狼毫
               ) else (
                   echo 检测到未安装小狼毫,准备执行安装.
                   echo 正在下载...
                   call :install_weasel
                   call :checkProcess
                   echo 已完成安装小狼毫!
               )
           )
       )
   ) else (
       echo 检测到未安装小狼毫,准备执行安装.
       echo 正在下载...
       call :install_weasel
       call :checkProcess
       echo 已完成安装小狼毫!
   )
)

echo 正在检测旧项目
echo 项目地址为: %Project_092_Dir%
if exist "%Project_092_Dir%" (
    echo 检测到旧项目, 执行更新!
    rd /s /q "%Project_092_Dir%"
) else (
    echo 项目不存在,准备 clone
)

:clone_092wb
echo 准备克隆 092wb 项目
for %%i in (%mirrors%) do (
    echo Trying to clone from %%i%user%/%repo%.git
    if "%%i"=="https://github.com/" (
        git clone %%i%user%/%repo%.git "%Project_DL%\%repo%"
    ) else (
        git clone --config http.sslVerify=false %%i%user%/%repo%.git "%Project_DL%\%repo%"
    )

    if !ERRORLEVEL! == 0 (
        echo Clone success from %%i%user%/%repo%.git
        goto end_of_clone
    ) else (
        echo Clone failed from %%i%user%/%repo%.git
    )
)
echo 所有镜像 clone 失败! 请检查网络.
exit

:end_of_clone
echo clone成功!
ping -n 1 127.0.0.1>nul
echo 准备添加方案
call :path_UD  >nul 2>&1 
echo 码表目录为: %tables%
echo 初始化算法服务
start "" "%regvalue%\WeaselServer.exe"
if !ERRORLEVEL! == 0 (
    echo 成功!
    ping -n 2 127.0.0.1>nul
) else (
    echo Clone failed from %%i%user%/%repo%.git
    echo 失败
    ping -n 2 127.0.0.1>nul
    exit
)
echo 结束算法服务
TASKKILL /F /IM WeaselServer.exe   >nul 2>&1
if !ERRORLEVEL! == 0 (
    echo 成功!
    ping -n 2 127.0.0.1>nul
) else (
    echo Clone failed from %%i%user%/%repo%.git
    echo 失败
    ping -n 2 127.0.0.1>nul
    exit
)
REM 获取盘符 c:
%UserDir:~0,2%
goto :eof

:first_install
echo 准备清空用户目录
(
DEL /F /A /Q "%UserDir%\*.*"
echo "延迟 2 秒" >nul
ping -n 2 127.0.0.1>nul
) & if !ERRORLEVEL! == 0 (
    echo 清空 build and lua 目录成功
    ping -n 2 127.0.0.1>nul
) else (
    echo 清空 build and lua 目录失败!
    ping -n 2 127.0.0.1>nul
)

for /f "delims=" %%a in ('dir /s /ad /b "%UserDir%" ^| sort /r') do rd /s /q "%%a" >nul
if !ERRORLEVEL! == 0 (
    echo 清空用户目录成功
    ping -n 2 127.0.0.1>nul
) else (
    echo 清空用户目录失败!
    ping -n 2 127.0.0.1>nul
)

%tables:~1,2%

echo 准备更新程序目录
ping -n 2 127.0.0.1>nul
echo 准备清空 opencc
DEL /F /A /Q "%regvalue%\data\opencc\*"
ping -n 2 127.0.0.1>nul
echo 清空 opencc 成功
ping -n 2 127.0.0.1>nul
echo 准备放入新的 opencc
xcopy /S /D "%tables%\092\opencc\*" "%regvalue%\data\opencc\"  >nul 2>&1
ping -n 2 127.0.0.1>nul
echo 放入成功
ping -n 2 127.0.0.1>nul
echo 更新程序目录成功
ping -n 2 127.0.0.1>nul

echo 准备更新用户目录
md "%UserDir%\build"
md "%UserDir%\lua"
md "%UserDir%\lua\ace"
md "%UserDir%\lua\ace\lib"

echo 准备添加092方案
(
xcopy /D /Y %tables%\092\spelling\*.bin "%UserDir%\build\"

xcopy /D /Y %tables%\092\*.yaml "%UserDir%"
xcopy /D /Y %tables%\092\*.lua "%UserDir%"
xcopy /D /Y %tables%\092\lua\ace\*.lua "%UserDir%\lua\ace"
xcopy /D /Y %tables%\092\lua\ace\lib\*.lua "%UserDir%\lua\ace\lib"

DEL /F /A /Q "%UserDir%\squirrel.custom.yaml"
)  >nul 2>&1

ping -n 1 127.0.0.1 >nul
echo 添加成功
echo 用户目录更新成功
ping -n 2 127.0.0.1>nul


if exist "%Project_DL%\Git-2.41.0-64-bit.exe" (
    DEL "%Project_DL%\Git-2.41.0-64-bit.exe"
) else (
    echo 无Git-2.41.0-64-bit.exe >nul
)

if exist "%Project_DL%\weasel-0.14.3.0-installer.exe" (
    DEL "%Project_DL%\weasel-0.14.3.0-installer.exe"
) else (
    echo 无weasel-0.14.3.0-installer >nul
)
ping -n 2 127.0.0.1>nul
echo 清理成功
ping -n 2 127.0.0.1>nul


echo 准备安装拆分字体
call :install_fonts
ping -n 2 127.0.0.1>nul
echo 拆分字体安装成功,注销或重启系统生效
ping -n 2 127.0.0.1>nul

goto :eof


REM 环境依赖
:path_UD  >nul 2>&1

reg query HKEY_CURRENT_USER\Software\Weasel /v RimeUserDir >nul 2>nul
if %errorlevel% equ 0 (
    set /p UserDir=< HKEY_CURRENT_USER\Software\Weasel\RimeUserDir
) else (
    reg add HKEY_CURRENT_USER\Software\Weasel /v RimeUserDir /t REG_SZ /d "C:\Users\%USERNAME%\AppData\Roaming\Rime" /f >nul 2>nul
    set "UserDir=C:\Users\%USERNAME%\AppData\Roaming\Rime"
)

if defined UserDir (
    echo 找到UserDir 
) else set UserDir=C:\Users\%USERNAME%\AppData\Roaming\Rime
echo 用户目录为: %UserDir%

for /f "tokens=1,2,* " %%i in ('REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Rime\Weasel /v WeaselRoot ^| find /i "WeaselRoot"') do set "regvalue=%%k" >nul 2>nul

echo 安装路径为: %regvalue%
goto :eof

:schema_file_exist
if exist "%schema_file%" (
    echo %schema_file% 存在 >nul
) else (
    echo %schema_file% 不存在
    ping -n 2 127.0.0.1>nul
    exit
)
goto :eof

:default_file_exist
if exist "%default_file%" (
    echo %default_file% 存在 >nul
) else (
    echo %default_file% 不存在
    ping -n 2 127.0.0.1>nul
    exit
)
goto :eof

:weasel_file_exist
if exist "%weasel_file%" (
    echo %weasel_file% 存在 >nul
) else (
    echo %weasel_file% 不存在
    ping -n 2 127.0.0.1>nul
    exit
)
goto :eof

:extended_file_exist
if exist "%extended_file%" (
    echo %extended_file% 存在 >nul
) else (
    echo %extended_file% 不存在
    ping -n 2 127.0.0.1>nul
    exit
)
goto :eof



:install_weasel
set success=false
for %%i in (%mirrors%) do (
    echo Trying to curl from %%i%weasel_user%/%weasel_repo%
    if "%%i"=="https://github.com/" (
        curl -o %Project_DL%\%weasel_name%.exe -L  %%i%weasel_user%/%weasel_repo%/releases/download/%version%/%weasel_name%.exe
    ) else (
	curl -o %Project_DL%\%weasel_name%.exe -L --insecure %%i%weasel_user%/%weasel_repo%/releases/download/%version%/%weasel_name%.exe
    )

    if !ERRORLEVEL! == 0 (
        echo curl success from %%i%weasel_user%/%weasel_repo%
	set success1=true
        goto end_of_script
    ) else (
        echo curl failed from %%i%weasel_user%/%weasel_repo%
    )
)

if not !success! (
    echo 所有镜像下载失败! 请检查网络.
    exit
)

goto :eof

:end_of_script
echo 下载成功!
ping -n 2 127.0.0.1 >nul
echo 正在安装
start "" "%Project_DL%\weasel-0.14.3.0-installer.exe" /S
goto :eof

:checkProcess   
set "weasel_count=0"
tasklist | find /i "WeaselDeployer.exe"  >nul 2>&1
if errorlevel 1 (
    echo WeaselDeployer.exe is not running. >nul
    ping -n 2 127.0.0.1 >nul
    set /a weasel_count+=1
    if %weasel_count% equ 10 (
        echo Failed to terminate WeaselDeployer.exe. >nul
        exit /b
    )
    goto checkProcess
) else (
    echo WeaselDeployer.exe is running. Terminating the process... >nul
    ping -n 1 127.0.0.1 >nul
    taskkill /f /t /im WeaselDeployer.exe  >nul 2>&1
    echo WeaselDeployer.exe has been terminated. >nul
    exit /b
)
goto :eof


:install_git
echo 未安装 Git, 准备执行安装 
curl -o %Project_DL%\Git-2.41.0-64-bit.exe -L "https://ghproxy.com/https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.1/Git-2.41.0-64-bit.exe"  

if not exist "%Project_DL%\Git-2.41.0-64-bit.exe" (
    echo 无Git-2.41.0-64-bit.exe >nul
    exit
)

echo 正在安装 Git, 所需时间较长, 请耐心等待...
start /wait "" %Project_DL%\Git-2.41.0-64-bit.exe /VERYSILENT
set PATH=%PATH%;C:\Program Files\Git\bin
git --version >nul 2>nul
ping 127.0.0.1 -n 2 >nul
if %errorlevel% equ 0 (
    echo GIT 安装成功!
) else (
    echo GIT 安装失败! 脚本即将退出.
    ping -n 2 127.0.0.1>nul
    exit
)
goto :eof


REM 状态
:en_zh_092
call :schema_file_exist
echo 准备设置默认『中』『英』状态
set "spelling_line=18"
copy /y "%schema_file%" "%temp_file%"  >nul 2>&1

set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %spelling_line% (
        set "line=%%a"
        if not "!line!"=="!line:1=!" (
            set "line=!line:1=0!"
        ) else if not "!line!"=="!line:0=!" (
            set "line=!line:0=1!"
        )
        echo(!line!
    ) else (
        echo(%%a
    )
)) > %schema_file%
del "%temp_file%"  >nul 2>&1
echo 切换成功
goto :eof

:vh
call :weasel_file_exist
echo 准备切换横竖排
set "vh_line=12"
ping -n 3 127.0.0.1>nul
copy /y "%weasel_file%" "%temp_file%"  >nul 2>&1

set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %vh_line% (
        set "line=%%a"
        if not "!line!"=="!line:true=!" (
            set "line=!line:true=false!"
        ) else if not "!line!"=="!line:false=!" (
            set "line=!line:false=true!"
        )
        echo(!line!
    ) else (
        echo(%%a
    )
)) > %weasel_file%
del "%temp_file%"  >nul 2>&1
echo 切换成功
goto :eof


:spelling
call :schema_file_exist
echo 准备切换显隐拆分
set "spelling_line=23"

copy /y "%schema_file%" "%temp_file%"  >nul 2>&1

set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %spelling_line% (
        set "line=%%a"
        if not "!line!"=="!line:1=!" (
            set "line=!line:1=0!"
        ) else if not "!line!"=="!line:0=!" (
            set "line=!line:0=1!"
        )
        echo(!line!
    ) else (
        echo(%%a
    )
)) > %schema_file%
del "%temp_file%"  >nul 2>&1
echo 切换成功
goto :eof


:rk
call :schema_file_exist
echo 准备切换『`』『z』反查
set "target_line=120"
copy /y "%schema_file%" "%temp_file%"  >nul 2>&1
set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %target_line% (
        set "line=%%a"
        if "!line:~0,1!"=="#" (
            set "line=!line:~1!"
        ) else (
            set "line=#%%a"
        )
        echo(!line!
    ) else (
        echo(%%a
    )
)) > %schema_file%
del "%temp_file%"  >nul 2>&1

set "spelling_line=144"
copy /y "%schema_file%" "%temp_file%"  >nul 2>&1
set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %spelling_line% (
        set "line=%%a"
        if not "!line!"=="!line:z=!" (
            set "line=!line:z=`!"
        ) else if not "!line!"=="!line:`=!" (
            set "line=!line:`=z!"
        )
        echo(!line!
    ) else (
        echo(%%a
    )
)) > %schema_file%
del "%temp_file%"  >nul 2>&1

set "target_line=174"
copy /y "%schema_file%" "%temp_file%"  >nul 2>&1
set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %target_line% (
        set "line=%%a"
        if "!line:~0,1!"=="#" (
            set "line=!line:~1!"
        ) else (
            set "line=#%%a"
        )
        echo(!line!
    ) else (
        echo(%%a
    )
)) > %schema_file%
del "%temp_file%"  >nul 2>&1

set "spelling_line=176"
copy /y "%schema_file%" "%temp_file%"  >nul 2>&1
set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %spelling_line% (
        set "line=%%a"
        if not "!line!"=="!line:^z=!" (
            set "line=!line:^z=^`!"
        ) else if not "!line!"=="!line:^`=!" (
            set "line=!line:^`=^z!"
        )
        echo(!line!
    ) else (
        echo(%%a
    )
)) > %schema_file%
del "%temp_file%"  >nul 2>&1

set "spelling_line=177"
copy /y "%schema_file%" "%temp_file%"  >nul 2>&1
set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %spelling_line% (
        set "line=%%a"
        if not "!line!"=="!line:^z=!" (
            set "line=!line:^z=^`!"
        ) else if not "!line!"=="!line:^`=!" (
            set "line=!line:^`=^z!"
        )
        echo(!line!
    ) else (
        echo(%%a
    )
)) > %schema_file%
del "%temp_file%"  >nul 2>&1
echo 切换成功
goto :eof

REM 词库
:clover
echo 准备添加 clover
xcopy /D /Y %tables%\clover\*.yaml "%UserDir%"  >nul 2>&1
ping -n 2 127.0.0.1 >nul
echo 添加 clover 成功
ping -n 2 127.0.0.1 >nul

echo 准备修改 default 中的方案 
set "target_line=10"  

call :default_file_exist
copy /y "%default_file%" "%temp_file%"  >nul 2>&1

set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %target_line% (
        set "line=%%a"
        if "!line:~0,1!"=="#" (
            set "line=!line:~1!"
        ) else (
            set "line=#%%a"
        )
        echo(!line!
    ) else (
        echo(%%a
    )
)) > %default_file%
del "%temp_file%"  >nul 2>&1
ping -n 2 127.0.0.1 >nul
echo 修改成功
goto :eof

:unclover
call :path_UD  >nul 2>&1
echo 准备移除 clover
DEL /F /Q "%UserDir%\clover*.yaml"
DEL /F /Q "%UserDir%\sogou*.yaml"
DEL /F /Q "%UserDir%\THUOCL*.yaml"
ping -n 2 127.0.0.1 >nul
echo 移除 clover 成功
ping -n 2 127.0.0.1 >nul

echo 准备修改 default 中的方案 
set "target_line=10"  

copy /y "%default_file%" "%temp_file%"  >nul 2>&1
set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %target_line% (
        set "line=%%a"
        if "!line:~0,1!"=="#" (
            set "line=!line:~1!"
        ) else (
            set "line=#%%a"
        )
        echo(!line!
    ) else (
        echo(%%a
    )
)) > %default_file%
del "%temp_file%"  >nul 2>&1
ping -n 2 127.0.0.1 >nul
echo 修改成功
goto :eof


:dictionarys
set success=false
for %%i in (%raw_mirrors%) do (
    echo Trying to curl from %%i%weasel_user%/%weasel_repo%
    if "%%i"=="https://raw.githubusercontent.com/" (
	curl -o %Project_DL%\%dict_file_name%.yaml -L  %%i/%user%/%repo%/main/%dict_dir%/%dict_file_name%.yaml
    ) else (
	curl -o %Project_DL%\%dict_file_name%.yaml -L --insecure %%i%user%/%repo%/main/%dict_dir%/%dict_file_name%.yaml
    )

    if !ERRORLEVEL! == 0 (
        echo curl success from %%i%user%/%repo%
	set success1=true
        goto end_of_script
    ) else (
        echo curl failed from %%i%user%/%repo%
    )
)

if not !success! (
    echo 所有镜像下载失败! 请检查网络.
    exit
)

goto :eof

:end_of_script
echo 词库 %dict_name% 下载成功!
ping -n 2 127.0.0.1 >nul
xcopy /D /Y %Project_DL%\%dict_file_name%.yaml "%UserDir%"  >nul 2>&1

echo 准备切换为 %dict_name% 词库
if "%dict_dir%"=="092" (
    DEL /F /A /Q "%UserDir%\*.txt"  >nul 2>&1
    call :dict_092
) else (
    DEL /F /A /Q "%UserDir%\*.txt"  >nul 2>&1
    call :dict_other
)
goto :eof

:dict_other
rem call :extended_file_exist
set "target_line=9"  
copy /y "%extended_file%" "%temp_file%"  >nul 2>&1
set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %target_line% (
        set "line=%%a"
        if "!line:~0,1!"=="#" (
            echo(!line!
        ) else (
            echo(#%%a
        )
    ) else (
        echo(%%a
    )
)) > %extended_file%
del "%temp_file%"  >nul 2>&1

set "target_line=10"  
copy /y "%extended_file%" "%temp_file%"  >nul 2>&1
set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %target_line% (
        set "line=%%a"
        if "!line:~0,1!"=="#" (
            echo(!line!
        ) else (
            echo(#%%a
        )
    ) else (
        echo(%%a
    )
)) > %extended_file%
del "%temp_file%"  >nul 2>&1
ping -n 2 127.0.0.1 >nul

set "target_line=11"  
copy /y "%extended_file%" "%temp_file%"  >nul 2>&1
set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %target_line% (
        echo   - %dict_name%
    ) else (
        echo(%%a
    )
)) > %extended_file%
del "%temp_file%"  >nul 2>&1


set "target_line=32"
copy /y "%schema_file%" "%temp_file%"  >nul 2>&1

set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %target_line% (
        set "line=%%a"
        set "line=!line:1=0!"
        echo(!line!
    ) else (
        echo(%%a
    )
)) > %schema_file%
del "%temp_file%"  >nul 2>&1
ping -n 1 127.0.0.1 >nul
del "%Project_DL%\%dict_file_name%.yaml" 
echo 词库切换成功
goto :eof


:dict_092
call :extended_file_exist
set "target_line=9"
copy /y "%extended_file%" "%temp_file%" >nul 2>&1
set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %target_line% (
        set "line=%%a"
        if "!line:~0,1!"=="#" (
            set "line=!line:~1!"
            echo(!line!
        ) else (
	    echo(!line!
        )
    ) else (
        echo(%%a
    )
)) > %extended_file%
del "%temp_file%" 
ping -n 2 127.0.0.1 >nul

set "target_line=10"
copy /y "%extended_file%" "%temp_file%" >nul 2>&1
set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %target_line% (
        set "line=%%a"
        if "!line:~0,1!"=="#" (
            set "line=!line:~1!"
            echo(!line!
        ) else (
	    echo(!line!
        )
    ) else (
        echo(%%a
    )
)) > %extended_file%
del "%temp_file%" 
ping -n 2 127.0.0.1 >nul

set "target_line=11"  
copy /y "%extended_file%" "%temp_file%"  >nul 2>&1
set count=0
(for /f "tokens=* delims=" %%a in (%temp_file%) do (
    set /a count+=1
    if !count! equ %target_line% (
        set "line=%%a"
        if "!line:~0,1!"=="#" (
            echo(!line!
        ) else (
            echo(#%%a
        )
    ) else (
        echo(%%a
    )
)) > %extended_file%
del "%temp_file%"  >nul 2>&1
ping -n 2 127.0.0.1 >nul
del "%Project_DL%\%dict_file_name%.yaml" 
echo 词库切换成功
goto :eof


:backup
call :path_UD >nul 2>&1
echo 结束算法服务
TASKKILL /F /IM WeaselServer.exe >nul 2>&1 
if not exist "C:\Users\%USERNAME%\Desktop\小狼毫备份" mkdir "C:\Users\%USERNAME%\Desktop\小狼毫备份"
if not exist "C:\Users\%USERNAME%\Desktop\小狼毫备份\opencc" mkdir "C:\Users\%USERNAME%\Desktop\小狼毫备份\opencc"
xcopy /S /D "%regvalue%\data\opencc" "%HOMEPATH%\Desktop\小狼毫备份\opencc" >nul 2>&1
xcopy /S "%UserDir%" "C:\Users\%USERNAME%\Desktop\小狼毫备份" >nul 2>&1
echo 备份完成
echo "备份目录：桌面\小狼毫备份"
goto :eof

:restore
call :path_UD  >nul 2>&1
echo 结束算法服务
TASKKILL /F /IM WeaselServer.exe  >nul 2>&1 
(
DEL /F /A /Q "%UserDir%\*"
DEL /F /A /Q "%regvalue%\data\opencc\*"
xcopy /S "C:\Users\%USERNAME%\Desktop\小狼毫备份" "%UserDir%"
xcopy /S "C:\Users\%USERNAME%\Desktop\小狼毫备份\opencc\*" "%regvalue%\data\opencc"
)  >nul 2>&1
echo 恢复完成
goto :eof

:Clear_Project_DL
echo 结束算法服务
TASKKILL /F /IM WeaselServer.exe  >nul 2>&1 
echo 准备清理
ping 127.0.0.1 -n 2 -w 1000 >nul
RD /S /Q "%Project_DL%"  >nul 2>&1
echo 清理完成
goto :eof

REM 字体
:install_fonts
REM 得文件权限
if exist "%font%\%etymon%*" (
    takeown /f "%font%\%etymon%*" /a >nul 2>&1
    icacls "%font%\%etymon%*" /grant Administrators:F >nul 2>&1
) 

REM 备份系统原生雅黑字体
if not exist "%font%\%msyhfont%.org" (
    echo 备份原生雅黑字体文件
    copy /y "%font%\%msyhfont%" "%font%\%msyhfont%.org" >nul 2>&1
)

echo 删除原备份文件
if exist "%font%\%etymon%.bak" del /f "%font%\%etymon%.bak"

if exist "%font%\%etymon%" (
    echo 文件更名
    ren "%font%\%etymon%" "%etymon%.bak" >nul 2>&1
    if errorlevel 1 goto error
)

echo 更新拆分字体
copy /y "%fontdir%\%etymon%" "%font%\%etymon%" >nul 2>&1
if errorlevel 1 goto error

echo 修改注册表
reg add "%fontkey%" /v "092 (TrueType)" /d "%etymon%" /f >nul 2>&1

reg add "%fallback%" /v "Plane16" /d "092字根专用" /f >nul 2>&1
reg add "%fallback%\Microsoft YaHei" /v "Plane16" /d "092字根专用" /f >nul 2>&1
REM 遍历 SurrogateFallback 已有的字体，为每个字体添加相应的 Planes 支持
for /f "tokens=*" %%a in ('reg query "%fallback%"') do (
	set "str=%%a"
	if /i "!str:~0,4!"=="HKEY" (
		reg query "%%a" /v "Plane16" >nul 2>&1
		if errorlevel 1 reg add "%%a" /v "Plane16" /d "092字根专用" /f >nul 2>&1
	)
)

reg query "%linkkey%" /v "092" >nul 2>&1
if errorlevel 1 reg add "%linkkey%" /v "092" /t REG_MULTI_SZ /d "MICROSS.TTF,108,122\0MICROSS.TTF\0SIMSUN.TTC,SimSun\0MSGOTHIC.TTC,MS UI Gothic" /f >nul 2>&1
echo 注册表修改成功
goto :eof

:error
echo 安装失败！
if exist "%font%\%etymon%.bak" (
	echo 恢复"%font%\%etymon%"文件
	if exist "%font%\%etymon%" del /f "%font%\%etymon%"
	ren "%font%\%etymon%.bak" "%etymon%"
)
goto :eof
