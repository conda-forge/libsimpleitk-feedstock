#!/bin/bash

# On ppc64le, -mlongcall avoids R_PPC64_REL24 relocation overflow
# when linking large static libraries (±32MB branch limit).
if [[ "${target_platform}" == linux-ppc64le ]]; then
    CXXFLAGS="${CXXFLAGS} -mlongcall"
    CFLAGS="${CFLAGS} -mlongcall"
fi

BUILD_DIR=${SRC_DIR}/build
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}

cmake \
    -G Ninja \
    ${CMAKE_ARGS} \
    -D "CMAKE_CXX_FLAGS:STRING=-fvisibility=hidden ${CXXFLAGS}" \
    -D "CMAKE_C_FLAGS:STRING=-fvisibility=hidden ${CFLAGS}" \
    -D CMAKE_BUILD_TYPE:STRING=Release \
    -D "CMAKE_FIND_ROOT_PATH_MODE_INCLUDE:STRING=ONLY" \
    -D "CMAKE_FIND_ROOT_PATH_MODE_LIBRARY:STRING=ONLY" \
    -D "CMAKE_FIND_ROOT_PATH_MODE_PROGRAM:STRING=NEVER" \
    -D "CMAKE_FIND_ROOT_PATH_MODE_PACKAGE:STRING=ONLY" \
    -D "CMAKE_FIND_FRAMEWORK:STRING=NEVER" \
    -D "CMAKE_FIND_APPBUNDLE:STRING=NEVER" \
    -D SimpleITK_BUILD_DISTRIBUTE:BOOL=ON \
    -D SimpleITK_EXPLICIT_INSTANTIATION:BOOL=ON \
    -D CMAKE_BUILD_TYPE:STRING=RELEASE \
    -D BUILD_SHARED_LIBS:BOOL=OFF \
    -D BUILD_TESTING:BOOL=OFF \
    -D BUILD_EXAMPLES:BOOL=OFF \
    -D WRAP_DEFAULT:BOOL=OFF \
    "${SRC_DIR}"

cmake --build  . --config Release -- -j 2
cmake \
    -D CMAKE_INSTALL_PREFIX=$PREFIX \
    -P ${BUILD_DIR}/cmake_install.cmake

