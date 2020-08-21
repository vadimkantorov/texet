
BASE_DIR=$PWD/
DIST_DIR=${BASE_DIR}build
GLOBAL_CFLAGS=-O3
mkdir -p $DIST_DIR

pushd expat/expat
mkdir -p build
cd build 
emcmake cmake \
    -DCMAKE_C_FLAGS=" \
    -s USE_PTHREADS=0 \
    ${GLOBAL_CFLAGS} \
    -s NO_FILESYSTEM=1 \
    -s NO_EXIT_RUNTIME=1 \
    --llvm-lto 1 \
    -s MODULARIZE=1 \
    " \
    -DCMAKE_INSTALL_PREFIX=${DIST_DIR} \
    -DEXPAT_BUILD_DOCS=off \
    -DEXPAT_SHARED_LIBS=off \
    -DEXPAT_BUILD_EXAMPLES=off \
    -DEXPAT_BUILD_FUZZERS=off \
    -DEXPAT_BUILD_TESTS=off \
    -DEXPAT_BUILD_TOOLS=off \
    .. 
emmake make -j8 
emmake make install
popd
