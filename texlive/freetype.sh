
BASE_DIR=$PWD/
DIST_DIR=${BASE_DIR}build
GLOBAL_CFLAGS=-O3
mkdir -p $DIST_DIR

pushd freetype
git reset --hard
for file in ${BASE_DIR}patches/freetype/*.patch; do
    patch -d "${BASE_DIR}freetype" -Np1 -i ${file}
done
NOCONFIGURE=1 ./autogen.sh 
mkdir -p build
cd build
EM_PKG_CONFIG_PATH=${DIST_DIR}/lib/pkgconfig emconfigure ../configure \
    CFLAGS=" \
    -s USE_PTHREADS=0 \
    ${GLOBAL_CFLAGS} \
    -s NO_FILESYSTEM=1 \
    -s NO_EXIT_RUNTIME=1 \
    --llvm-lto 1 \
    -s MODULARIZE=1 \
    " \
    --prefix="${DIST_DIR}" \
    --host=x86-none-linux \
    --build=x86_64 \
    --enable-static \
    --disable-shared \
    --without-brotli \
    --without-zlib \
    --without-bzip2 \
    --without-png \
    --without-harfbuzz 

emmake make -j8 
emmake make install
popd
