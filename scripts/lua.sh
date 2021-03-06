#!/bin/bash -e

. ../../path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -r _build
	make clean
	exit 0
else
	exit 255
fi

# LUA_T= and LUAC_T= disable building lua & luac
# -Dgetlocaledecpoint()=('.') fixes bionic missing decimal_point in localeconv
make CC="arm-linux-androideabi-gcc -Dgetlocaledecpoint\(\)=\(\'.\'\)" PLAT=linux LUA_T= LUAC_T= -j6

# TO_BIN=/dev/null disables installing lua & luac
make INSTALL_TOP=`pwd`/../../prefix TO_BIN=/dev/null install
mkdir -p _build/out/lib/pkgconfig

# make pc only generates a partial pkg-config file because ????
make INSTALL_TOP=`pwd`/../../prefix pc > ../../prefix/lib/pkgconfig/lua.pc
cat >>../../prefix/lib/pkgconfig/lua.pc <<'EOF'
Name: Lua
Description: 
Version: ${version}
Libs: -L${libdir} -llua
Cflags: -I${includedir}
EOF
