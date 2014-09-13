WinLibsBuilder
==============

Scripts for building a set of Open Source Libraries (particularly for XCSoar Win32/WinRT/WinPhone)

Requirements:
* Cygwin
* Visual Studio 2013
* CMake (>= 3.0.20140911-g09063)
* NASM (for Windows), and its installation directory needs to be in your PATH variable

Before building, you might need to adjust env.inc.

./download.sh - Download the library source tarballs
./extract-and-patch.sh - Extract and patch the downloaded tarballs
./build - Build the libraries for one target
./buildall - Build the libraries for all targets
