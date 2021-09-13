#!/bin/bash/

# $1 - targetPlatform (ios/andoird)
# $2 - scheme (prod/staging)
# $3 - buildType (apk/bundle)

targetPlatform=$1
scheme=$2
buildType=$3

$platform
$confirmResult

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  platform="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  platform="mac"
elif [[ "$OSTYPE" == "cygwin" ]]; then
  platform="win"
  # POSIX compatibility layer and Linux environment emulation for Windows
elif [[ "$OSTYPE" == "msys" ]]; then
  platform="win"
  # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
elif [[ "$OSTYPE" == "win32" ]]; then
  platform="unknown"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
  platform="unknown"
else
  platform="unknown"
fi

function linuxPrompt() {
  zenity --question --text="Build $targetPlatform $buildType on $scheme!?"
}

function macPrompt() {
  osascript <<EOT
    tell app "System Events"
     button returned of (display dialog "Build $targetPlatform $buildType on $scheme!?" with icon caution buttons {"No", "Yes"})
    end tell
EOT
}

if [ "$platform" == "linux" ]; then
  value="$(linuxPrompt)"
  if [ $? -eq 0 ]; then
    confirmResult="Yes"
  else
    confirmResult="No"
  fi
elif [ "$platform" == "mac" ]; then
  confirmResult="$(macPrompt)"
else
  echo Other plaforms
  read -p "Do you wish to install this program?" yn
  case $yn in
  [Yy]*) confirmResult="Yes" break ;;
  [Nn]*) exit ;;
  *) echo "Please answer yes or no." ;;
  esac
fi

if [ $confirmResult == "Yes" ]; then
  if [[ $targetPlatform == "android" ]]; then
    echo "build Android $buildType on $scheme"
    bash buildAndroid.sh $buildType $scheme
  elif [[ $targetPlatform == "ios" ]]; then
    echo "build IOS on $scheme"
    bash buildIOS.sh $scheme
  fi
elif
  [ $confirmResult == "No" ]
then
  exit
else
  echo "result in undefined"
  exit
fi
