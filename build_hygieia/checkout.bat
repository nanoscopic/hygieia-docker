@echo off

echo Creating c:\data\hyg folder for checked out code
mkdir c:/data
mkdir c:/data/hyg
mkdir c:/data/m2repo

echo Checking out repos
cd c:/data/hyg
git clone https://github.com/Hygieia/hygieia-core.git
git clone https://github.com/Hygieia/Hygieia.git
