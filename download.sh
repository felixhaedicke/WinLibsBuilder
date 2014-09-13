#!/bin/bash

. versions.inc || exit $?

DL_TMP_UUID=$(uuidgen)
if [ "${DL_TMP_UUID}" == "" ]
then
  exit 1
fi
DL_TMP_DIR=tmp-${DL_TMP_UUID}
mkdir ${DL_TMP_DIR} || exit $?

wget http://download.savannah.gnu.org/releases/freetype/freetype-${LIB_VERSION_FREETYPE}.tar.gz || exit $?
wget http://sourceforge.net/projects/libjpeg-turbo/files/${LIB_VERSION_LIBJPEG_TURBO}/libjpeg-turbo-${LIB_VERSION_LIBJPEG_TURBO}.tar.gz || exit $?
wget http://sourceforge.net/projects/libpng/files/zlib/${LIB_VERSION_ZLIB}/zlib-${LIB_VERSION_ZLIB}.tar.gz || exit $?
wget http://sourceforge.net/projects/libpng/files/libpng16/${LIB_VERSION_LIBPNG}/libpng-${LIB_VERSION_LIBPNG}.tar.gz || exit $?
wget http://www.libsdl.org/tmp/SDL-${LIB_VERSION_SDL2_SNAPSHOT}.tar.gz || exit $?

cd ${DL_TMP_DIR}

svn export -r ${LIB_VERSION_MSOPENTECH_ANGLE_SVNREV} https://github.com/MSOpenTech/angle/trunk MSOpenTech-ANGLE-r${LIB_VERSION_MSOPENTECH_ANGLE_SVNREV} || exit $?
tar czvf ../MSOpenTech-ANGLE-r${LIB_VERSION_MSOPENTECH_ANGLE_SVNREV}.tar.gz MSOpenTech-ANGLE-r${LIB_VERSION_MSOPENTECH_ANGLE_SVNREV} || exit $?

cd .. || exit $?
rm -rf ${DL_TMP_DIR} || exit $?
