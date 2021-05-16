#!/usr/bin/env bash

PATH_TO_JDK="https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz";

FILE_NAME="OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz";

echo "Welcome $USER, to the AdoptOpenJDK installer for JDK 11"

function direcrtoryInput () {
 while [ true ]; do
   read -p "Enter path to install jdk: " PATH_FOR_INSTALLATION;
    if [ -d "${PATH_FOR_INSTALLATION}" ]; then
       break;
      else
        echo "Path does not exists!"
    fi
 done
  takeConfirmation
  if [ "$takeConfirmation_OUTPUT" = true ]; then
   getInput_OUTPUT="$PATH_FOR_INSTALLATION"; 
   else
    echo "Goodbye!"
    exit 1;
  fi
}

function takeConfirmation() {
 read -p "Continue (y/n)?" CONT
 if [ "$CONT" = "[nN][[nN][oO]" ]; then
   takeConfirmation_OUTPUT=false;
  else
   takeConfirmation_OUTPUT=true;
 fi
}

direcrtoryInput;
PATH_FOR_INSTALLATION=$getInput_OUTPUT; #Has the file dir where i need to install

function moveIntoDir () {
  cd "$1";
}

function checkAndMoveFile(){ #1 is the file name 2 is the path to the filename
  if [ -f "$1" ]; then  #if file exists
      echo "$1 already exists moving installation to archive directory"
      if [ ! -d "$2/archive" ]; then #if directory archive doesnt exists
         mkdir "archive"
      fi
      $PATH_FOR_INSTALLATION = "$2/archive";
      moveIntoDir "$2/archive"
  fi
}


function downloadWget() {
  if [ "$1"==false ]; then
     echo "Wget command is required to install this in system."
     echo "Wget command is being installed. It will be automatically removed after installation of JDK"
     sudo apt update && sudo apt upgrade
     sudo apt-get install wget
  fi
}

function wgetExists(){
 if [ $(command -v wget) ]
 then
   wgetExists_OUTPUT=true;
 else
   wgetExists_OUTPUT=false;
 fi
}

function deleteWget(){
  if [ "$1"==false ]; then
   sudo apt-get remove wget
  fi
}

function installJDK(){
  moveIntoDir "$1"
  checkAndMoveFile "$3" "$1"
  wgetExists
  WGET_EXISTS=$wgetExists_OUTPUT
  downloadWget $WGET_EXISTS
  checkAndMoveFile "jdk-11.0.11+9" "$1"
  wget $2
  tar -xf $3
  rm -f $3
  ADOPTOPENJDK_PATH="$1/jdk-11.0.11+9/bin";
  echo "export PATH=\$PATH:$ADOPTOPENJDK_PATH" >> $HOME/.bashrc
  deleteWget $WGET_EXISTS
}

installJDK $PATH_FOR_INSTALLATION $PATH_TO_JDK $FILE_NAME
