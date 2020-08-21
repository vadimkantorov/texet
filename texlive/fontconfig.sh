BASE_DIR=$PWD/
DIST_DIR=${BASE_DIR}build
GLOBAL_CFLAGS=-O3
mkdir -p $DIST_DIR

pushd fontconfig
git reset --hard
for file in ${BASE_DIR}patches/fontconfig/*.patch; do
    patch -d "${BASE_DIR}fontconfig" -Np1 -i ${file}
done
NOCONFIGURE=1 ./autogen.sh
EM_PKG_CONFIG_PATH=${DIST_DIR}/lib/pkgconfig emconfigure ./configure \
    CFLAGS=" \
    -s USE_PTHREADS=0 \
    -DEMSCRIPTEN \
    ${GLOBAL_CFLAGS} \
    -s NO_EXIT_RUNTIME=1 \
    --llvm-lto 1 \
    -s MODULARIZE=1 \
    " \
    --prefix="${DIST_DIR}" \
    --host=x86-none-linux \
    --build=x86_64 \
    --disable-shared \
    --enable-static \
    --disable-docs \
    --with-default-fonts=/fonts

emmake make -j8 
emmake make install
popd

#EMCONFIGURE_JS=2 CONFIG_SITE=$(JS_CONFIG_SITE_ABS) emconfigure $$OLDPWD/$(FONTCONFIG_SOURCE_DIR)configure --enable-static --with-expat-includes=$$OLDPWD/$(EXPAT_SOURCE_DIR)lib/ FREETYPE_CFLAGS="-g -O3 -I$$OLDPWD/$(XETEX_BUILD_DIR)libs/freetype2/ -I$$OLDPWD/$(XETEX_BUILD_DIR)libs/freetype2/freetype2/" FREETYPE_LIBS=$$OLDPWD/$(LIB_FREETYPE) LDFLAGS=-L$$OLDPWD/$(EXPAT_BUILD_DIR).libs/ >> $(VERBOSE_LOG)
