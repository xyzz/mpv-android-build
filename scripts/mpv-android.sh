#!/bin/bash -e

. ../path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf bin gen libs obj
	exit 0
else
	exit 255
fi

PREFIX=`pwd`/../mpv/_build/out NDK_TOOLCHAIN_VERSION=4.9 ndk-build
android update project -p . --target android-19 --subprojects
ant debug