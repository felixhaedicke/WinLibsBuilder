#!/bin/bash

if [ $# -ne 2 ]
then
  echo "Usage: <installation prefix> <target descriptor>" >&2
  echo "Available target descriptors:" >&2
  for target_descriptor in target-descriptors/*
  do
    echo "  `basename ${target_descriptor}`" >&2
  done
  exit 1
fi

INSTALL_PREFIX_UNIX="$1"
TARGET_DESC=$2

. "target-descriptors/${TARGET_DESC}" || exit $?
. versions.inc || exit $?
. env.inc || exit $?
. env.inc || exit $?

PATH=`cygpath "${MSBUILD_DIR}\bin"`:$PATH
PATH=`cygpath "${CMAKE_DIR}\bin"`:$PATH

INSTALL_PREFIX_WIN=`cygpath -w "${INSTALL_PREFIX_UNIX}"`

CMAKE_DEFAULT_ARGS="-DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX_WIN}"
if [ "${TARGET_CMAKE_SYSTEM_NAME}" != "" ]
then
  CMAKE_DEFAULT_ARGS="${CMAKE_DEFAULT_ARGS} -DCMAKE_SYSTEM_NAME=${TARGET_CMAKE_SYSTEM_NAME}"
fi
if [ "${TARGET_CMAKE_SYSTEM_VERSION}" != "" ]
then
  CMAKE_DEFAULT_ARGS="${CMAKE_DEFAULT_ARGS} -DCMAKE_SYSTEM_VERSION=${TARGET_CMAKE_SYSTEM_VERSION}"
fi

mkdir freetype-build-${TARGET_DESC} || exit $?
cd freetype-build-${TARGET_DESC} || exit $?
cmake ../freetype-${LIB_VERSION_FREETYPE} -G "${TARGET_CMAKE_GENERATOR}" ${CMAKE_DEFAULT_ARGS} "-DCMAKE_C_FLAGS=${TARGET_CFLAGS}" || exit $?
MSBuild.exe freetype.sln /property:Configuration=Release || exit $?
MSBuild.exe install.vcxproj /property:Configuration=Release || exit $?
cd .. || exit $?

mkdir libjpeg-turbo-build-${TARGET_DESC} || exit $?
cd libjpeg-turbo-build-${TARGET_DESC} || exit $?
LIBJPEG_CFLAGS="${TARGET_CFLAGS}"
if [ "${TARGET_NO_PUTENV_GETENV}" == "1" ]
then
  LIBJPEG_CFLAGS="${LIBJPEG_CFLAGS} -DNO_GETENV=1 -DNO_PUTENV=1"
fi
LIBJPEG_CMAKE_ARGS="${CMAKE_DEFAULT_ARGS}"
if [ "${TARGET_LIBJPEG_TURBO_NO_SIMD}" == "1" ]
then
  LIBJPEG_CMAKE_ARGS="${LIBJPEG_CMAKE_ARGS} -DWITH_SIMD=0"
fi
cmake ../libjpeg-turbo-${LIB_VERSION_LIBJPEG_TURBO} ${LIBJPEG_CMAKE_ARGS} "-DCMAKE_C_FLAGS=${LIBJPEG_CFLAGS}" || exit $?
MSBuild.exe libjpeg-turbo.sln /property:Configuration=Release || exit $?
MSBuild.exe install.vcxproj /property:Configuration=Release || exit $?
rm "${INSTALL_PREFIX_UNIX}/lib/jpeg.lib" || exit $?
rm "${INSTALL_PREFIX_UNIX}/lib/turbojpeg.lib" || exit $?
rm "${INSTALL_PREFIX_UNIX}/lib/turbojpeg-static.lib" || exit $?
mv "${INSTALL_PREFIX_UNIX}/lib/jpeg-static.lib" "${INSTALL_PREFIX_UNIX}/lib/jpeg.lib" || exit $?
cd .. || exit $?

mkdir zlib-build-${TARGET_DESC} || exit $?
cd zlib-build-${TARGET_DESC} || exit $?
cmake ../zlib-${LIB_VERSION_ZLIB} -G "${TARGET_CMAKE_GENERATOR}" ${CMAKE_DEFAULT_ARGS} "-DCMAKE_C_FLAGS=${TARGET_CFLAGS}" || exit $?
MSBuild.exe zlib.sln /property:Configuration=Release || exit $?
MSBuild.exe install.vcxproj /property:Configuration=Release || exit $?
rm "${INSTALL_PREFIX_UNIX}/lib/zlib.lib" || exit $?
mv "${INSTALL_PREFIX_UNIX}/lib/zlibstatic.lib" "${INSTALL_PREFIX_UNIX}/lib/zlib.lib" || exit $?
cd .. || exit $?

mkdir libpng-build-${TARGET_DESC} || exit $?
cd libpng-build-${TARGET_DESC} || exit $?
cmake ../libpng-${LIB_VERSION_LIBPNG} -G "${TARGET_CMAKE_GENERATOR}" ${CMAKE_DEFAULT_ARGS} "-DCMAKE_C_FLAGS=${TARGET_CFLAGS}" || exit $?
MSBuild.exe libpng.sln /property:Configuration=Release || exit $?
MSBuild.exe install.vcxproj /property:Configuration=Release || exit $?
rm -rf "${INSTALL_PREFIX_UNIX}/lib/libpng" || exit $?
rm "${INSTALL_PREFIX_UNIX}/lib/libpng16.lib" || exit $?
mv "${INSTALL_PREFIX_UNIX}/lib/libpng16_static.lib" "${INSTALL_PREFIX_UNIX}/lib/libpng.lib" || exit $?
mv "${INSTALL_PREFIX_UNIX}/include/libpng16" "${INSTALL_PREFIX_UNIX}/include/libpng" || exit $?
cd .. || exit $?

if [ "${TARGET_BUILD_MSOPENTECH_ANGLE}" == "1" ]
then
  cd MSOpenTech-ANGLE-r${LIB_VERSION_MSOPENTECH_ANGLE_SVNREV} || exit $?
  MSBuild.exe ${TARGET_MSOPENTECH_ANGLE_PRJ_REL_PATH} /property:Configuration=Release /property:Platform=${TARGET_PLATFORM} || exit $?
  cp -r include/* ${INSTALL_PREFIX_UNIX}/include || exit $?
  find ${TARGET_MSOPENTECH_ANGLE_LIB_REL_PATH} -name \*.lib -exec cp {} "${INSTALL_PREFIX_UNIX}/lib" \; || exit $?
  cd .. || exit $?
fi

cd SDL-${LIB_VERSION_SDL2_SNAPSHOT} || exit $?
MSBuild.exe ${TARGET_SDL2_PRJ_REL_PATH} /property:Configuration=Release /property:Platform=${TARGET_PLATFORM} || exit $?
mkdir -p ${INSTALL_PREFIX_UNIX}/include/SDL2 || exit $?
cp -r include/*.h ${INSTALL_PREFIX_UNIX}/include/SDL2 || exit $?
find ${TARGET_SDL2_LIB_REL_PATH} -name \*.lib -exec cp {} "${INSTALL_PREFIX_UNIX}/lib" \; || exit $?
cd .. || exit $?

rm -rf "${INSTALL_PREFIX_UNIX}/bin" || exit $?
rm -rf "${INSTALL_PREFIX_UNIX}/doc" || exit $?
rm -rf "${INSTALL_PREFIX_UNIX}/share" || exit $?
