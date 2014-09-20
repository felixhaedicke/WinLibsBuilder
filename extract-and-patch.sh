#!/bin/bash

. versions.inc || exit $?

tar xzvf freetype-${LIB_VERSION_FREETYPE}.tar.gz || exit $?

tar xzvf libjpeg-turbo-${LIB_VERSION_LIBJPEG_TURBO}.tar.gz || exit $?
cd libjpeg-turbo-${LIB_VERSION_LIBJPEG_TURBO} || exit $?
patch -Np1 -i ../patches/libjpeg-turbo-GetTickCount64.diff || exit $?
patch -Np1 -i ../patches/libjpeg-turbo-no-env.diff || exit $?
patch -Np1 -i ../patches/libjpeg-turbo-no-static-rt.diff || exit $?
cd .. || exit $?

tar xzvf SDL-${LIB_VERSION_SDL2_SNAPSHOT}.tar.gz || exit $?
cd SDL-${LIB_VERSION_SDL2_SNAPSHOT} || exit $?
patch -Np1 -i ../patches/SDL2-vs2013-static.diff || exit $?
patch -Np1 -i ../patches/SDL2-vs2013-disable-test-compilation.diff || exit $?
patch -Np1 -i ../patches/SDL2-win32-no-xaudio2.diff || exit $?
patch -Np1 -i ../patches/SDL2-winphone81-static.diff || exit $?
patch -Np1 -i ../patches/SDL2-winrt81-static.diff || exit $?
cd .. || exit $?

tar xzvf zlib-${LIB_VERSION_ZLIB}.tar.gz || exit $?

tar xzvf libpng-${LIB_VERSION_LIBPNG}.tar.gz || exit $?

tar xzvf MSOpenTech-ANGLE-r${LIB_VERSION_MSOPENTECH_ANGLE_SVNREV}.tar.gz || exit $?
cd MSOpenTech-ANGLE-r${LIB_VERSION_MSOPENTECH_ANGLE_SVNREV} || exit $?
patch -Np1 -i ../patches/angle-vs2013.diff || exit $?
cd .. || exit $?
