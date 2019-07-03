@ECHO OFF
SET CWD=%~dp0
if not exist tmp (
    mkdir tmp
)
if not exist tmp\curl (
    if not exist tmp\curl.zip (
        PowerShell -NoProfile -ExecutionPolicy Bypass -Command ^
            "& '%CWD%download.ps1' 'https://curl.haxx.se/windows/dl-7.65.1_3/curl-7.65.1_3-win32-mingw.zip' tmp\curl.zip";
    )
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command ^
        "& '%CWD%extract_zip.ps1' tmp\curl.zip tmp\curl";
    copy tmp\curl\curl-7.65.1-win32-mingw\bin\* tmp\curl
)
if not exist github (
    mkdir github
)
if not exist github\hygieia (
    if not exist tmp\hygieia-master.zip (
        tmp\curl\curl -L -o tmp\hygieia-master.zip https://github.com/Hygieia/Hygieia/archive/master.zip
    )
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command ^
        "& '%CWD%extract_zip.ps1' tmp\hygieia-master.zip github\hygieia";
)  
if not exist github\hygieia-core (
    if not exist tmp\hygieia-core-master.zip (
        tmp\curl\curl -L -o tmp\hygieia-core-master.zip https://github.com/Hygieia/hygieia-core/archive/master.zip
    )
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command ^
        "& '%CWD%extract_zip.ps1' tmp\hygieia-core-master.zip github\hygieia-core";
)
docker images livxtrm/openjdk8_maven 2>&1 | find "livxtrm/openjdk8_maven" >nul
if errorlevel 1 (
    echo "Creating build image"
    docker build -t livxtrm/openjdk8_maven dockerfiles/openjdk8_maven
)

if not exist tmp\m2repo (
    mkdir tmp\m2repo
)
if not exist built (
    mkdir built
)
if not exist "github\hygieia-core\hygieia-core-master\target\core*" (
    echo "Building hygieia core"
    docker run -it -v "%CWD%/github:/github" -v "%CWD%/tmp/m2repo:/root/.m2/repository" -v "%CWD%/build_scripts:/build" livxtrm/openjdk8_maven /bin/sh /build/build_core.sh
)
if not exist "github\hygieia\Hygieia-master\api\target\api*" (
    echo "Building hygieia"
    docker run -it -v "%CWD%/github:/github" -v "%CWD%/tmp/m2repo:/root/.m2/repository" -v "%CWD%/build_scripts:/build" livxtrm/openjdk8_maven /bin/sh /build/build_hygieia.sh
)
if not exist built/db (
    mkdir "built/db"
    copy github\hygieia\Hygieia-master\db\* "built/db"
)
if exist github\hygieia\Hygieia-master\UI\target\UI* (
    if not exist built/ui (
        mkdir "built/ui"
        mkdir "built/ui/docker"
        mkdir "built/ui/target"
        mkdir "built/ui/dist"
        copy github\hygieia\Hygieia-master\UI\target\UI* built\ui\target >nul
        copy github\hygieia\Hygieia-master\UI\docker\conf-builder.sh built\ui\docker >nul
        copy github\hygieia\Hygieia-master\UI\docker\default.conf built\ui\docker >nul
        copy github\hygieia\Hygieia-master\UI\Dockerfile built\ui >nul
        xcopy /E github\hygieia\Hygieia-master\UI\dist\* built\ui\dist
    )
)

call :copybuilt api, api, api
call :copybuilt api-audit, apiaudit, api-audit
call :copybuilt collectors\artifact\artifactory, artifactory-artifact, collector-artifactory-artifact
call :copybuilt collectors\scm\bitbucket, bitbucket-scm, collector-bitbucket-scm
call :copybuilt collectors\scm\github, github-scm, collector-github-scm
call :copybuilt collectors\scm\github-graphql, github-graphql-scm, collector-github-graphql-scm
call :copybuilt collectors\scm\gitlab, gitlab-scm, collector-gitlab-scm
call :copybuilt collectors\build\jenkins, jenkins-build, collector-jenkins-build
call :copybuilt collectors\build\jenkins-codequality, jenkins-codequality, collector-jenkins-codequality-build
call :copybuilt collectors\build\jenkins-cucumber, jenkins-cucumber, collector-jenkins-cucumber-build
call :copybuilt collectors\build\sonar, sonar-codequality, collector-sonar-codequality
call :copybuilt collectors\feature\gitlab, gitlab-feature, collector-gitlab-feature
call :copybuilt collectors\feature\jira, jira-feature, collector-jira-feature

exit /b
:copybuilt
set src=github\hygieia\Hygieia-master\%1
set name=%2
set dest=built/%3
if exist %src%\target\%name%* (
    if not exist "%dest%" (
        echo Copying built files for %3
        mkdir "%dest%"
        mkdir "%dest%/docker"
        mkdir "%dest%/target"
        copy %src%\target\%name%*.jar "%dest%/target" >nul
        copy %src%\docker\properties-builder.sh "%dest%/docker" >nul
        copy %src%\Dockerfile "%dest%" >nul
    )
)

exit /b