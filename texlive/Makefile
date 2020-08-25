MAKEFLAGS += --no-builtin-rules # --warn-undefined-variables
.SUFFIXES:


# TODO: Using --closure 1 with -O2 or higher breaks xetex.js and xdvipdfmx.js.
# It doesn't break the xetex.worker.js nor xdvipdfmx.worker.js, though.
#
# Status | Flags
# -------|------
# OK     | -O2 --closure 1 --js-opts 0
# OK     | -O2
# OK     | -O3
# OK     | --closure 1
# BAD    | -O2 --closure 1
# BAD    | -O3 --closure 1
EM_LINK_OPT_WORKAROUND_FLAGS = -O3
EM_LINK_OPT_REGULAR_FLAGS = -O3 --closure 1
EM_LINK_FLAGS =

# Contains native builds of tools used later when compiling to JavaScript
NATIVE_BUILD_DIR = build/native/
EMSCRIPTEN_BUILD_DIR = build/js/
SOURCES_DIR = build-sources/

VERBOSE_LOG = $(abspath make.log)
$(info Standard output from configure and recursive make calls will be sent to $(VERBOSE_LOG).)

# We separately define the sizes and alignments of integer types. Otherwise,
# when setting EMCONFIGURE_JS=2, configure silently passes with an *empty*
# result. This happens because configure writes integer sizes to a file, but
# Emscripten does not come with persistent filesystem support by default. This
# is the simplest way to pass these configure checks. We need EMCONFIGURE_JS=2
# in some places to pass other configure checks that look for symbol
# definitions in Emscripten-compiled libraries.
JS_CONFIG_SITE = config.site
JS_CONFIG_SITE_ABS = $(realpath $(JS_CONFIG_SITE))
ifeq ($(JS_CONFIG_SITE_ABS),)
$(error Cannot find JS_CONFIG_SITE: $(JS_CONFIG_SITE))
endif

XETEX_BUILD_DIR = $(EMSCRIPTEN_BUILD_DIR)build-xetex/
XETEX_JS = xetex.js
XELATEX_JS = xelatex.js
XELATEX_EXE = xelatex
XETEX_WORKER_JS = xetex.worker.js

XETEX_ARCHIVE = xetex-0.9999.3.tar.bz2
XETEX_SOURCE_DIR = $(SOURCES_DIR)xetex-0.9999.3/
XETEX_ARCHIVE_URL = 'http://downloads.sourceforge.net/project/xetex/source/xetex-0.9999.3.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fxetex%2F&ts=1464938493&use_mirror=netassist'

LATEX_BASE_ARCHIVE = base.zip
LATEX_BASE_SOURCE_DIR = base/
LATEX_BASE_ARCHIVE_URL = http://mirrors.ctan.org/macros/latex/base.zip

TEXLIVE_INSTALL_TYPE = basic
INSTALL_TL_UNX_ARCHIVE = install-tl-unx.tar.gz
INSTALL_TL_UNX_ARCHIVE_URL = http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

# The Emscripten site recommends that we generate .so files over .a files...
#LIB_FREETYPE = build/lib/libfreetype.a
LIB_FREETYPE = $(XETEX_BUILD_DIR)libs/freetype2/ft-build/.libs/libfreetype.a
LIB_EXPAT = build/lib/libexpat.a
# Using libfontconfig.a mysteriously fails a configure check (and final link
# step) with:
# ```AssertionError: Failed to run LLVM optimizations:```
LIB_FONTCONFIG = build/lib/libfontconfig.a 

# Copied from xetex/build.sh.
#
# We use xetex's own freetype2 configuration. In order to do that, we build
# libs/freetype2 first before building the rest of the tree. We also explicitly
# hack in using libfontconfig.so as well as libexpat.
#
# FIXME: These flags don't seem to disable multithreading.
# Pass --disable-threads to propagate down to the ICU library.
# Pass --disable-multithreaded to propagate down the poppler library.
#
#

$(LIB_FREETYPE): build-js-xetex-configured.stamp $(NATIVE_BUILD_DIR)libs/freetype2/ft-build/apinames
	echo '>>>' Building xetex libraries...
	if ! emmake $(MAKE) -C $(XETEX_BUILD_DIR)libs >> $(VERBOSE_LOG); then \
		echo '>>>' First make attempt for xetex libraries failed. && \
		echo '>>>' Replacing freetype2 apinames binary from $(NATIVE_BUILD_DIR)... && \
		cp --preserve=mode $(NATIVE_BUILD_DIR)libs/freetype2/ft-build/apinames $(XETEX_BUILD_DIR)libs/freetype2/ft-build/apinames && \
		emmake $(MAKE) -C $(XETEX_BUILD_DIR)libs >> $(VERBOSE_LOG); \
	fi
	test -s $@ && touch $@


XETEX_CONF =										\
	--enable-compiler-warnings=yes							\
	--disable-all-pkgs								\
	--enable-xetex									\
	--enable-xdvipdfmx								\
	--disable-ptex									\
	--disable-native-texlive-build							\
	--disable-largefile								\
	--disable-ipc									\
	--disable-threads								\
	--disable-multithreaded								\
	--enable-silent-rules								\
	--enable-dump-share								\
	--with-freetype2-includes=$(abspath						\
		$(XETEX_SOURCE_DIR)source/libs/freetype2/freetype-2.4.11/include/)	\
	--with-freetype2-libdir=$(abspath $(XETEX_BUILD_DIR)libs/freetype2/)		\
	--without-system-ptexenc							\
	--without-system-kpathsea							\
	--without-mf-x-toolkit --without-x #\

#	--with-fontconfig-includes=$(abspath $(FONTCONFIG_SOURCE_DIR))			\
#	--with-fontconfig-libdir='. $(abspath $(LIB_FONTCONFIG))	-L$(abspath $(dir $(LIB_EXPAT))) -lexpat'				\

# Apparently *just* --enable-web2c doesn't work and breaks the xetex build in a
# cryptic way "Cannot find install.texi"
NATIVE_TOOLS_CONF =				\
	--enable-compiler-warnings=yes		\
	--disable-all-pkgs			\
	--enable-xetex				\
	--disable-ptex				\
	--disable-shared			\
	--disable-largefile			\
	--disable-ipc				\
	--enable-silent-rules			\
	--enable-dump-share			\
	--without-system-ptexenc		\
	--without-system-kpathsea		\
	--without-mf-x-toolkit --without-x

without_system_libs_opts =			\
	--enable-cxx-runtime-hack		\
	--without-system-poppler		\
	--without-system-freetype2		\
	--without-system-libpng			\
	--without-system-teckit			\
	--without-system-zlib			\
	--without-system-icu			\
	--without-system-graphite2		\
	--without-system-harfbuzz
NATIVE_TOOLS_CONF += $(without_system_libs_opts)
XETEX_CONF += $(without_system_libs_opts)

.PHONY: all
all: $(XETEX_JS) $(XELATEX_JS) $(XELATEX_EXE) $(XETEX_WORKER_JS) xelatex.fmt texlive.lst

.PHONY: texlive-manifest
texlive-manifest: texlive.lst

.PHONY: clean-js-artifacts-only
clean-js-artifacts-only:
	rm -f $(XETEX_JS) $(XETEX_JS).mem $(XELATEX_EXE) $(XELATEX_JS) $(XELATEX_JS).mem $(XETEX_WORKER_JS) $(XETEX_WORKER_JS).mem 

.PHONY: clean-js
clean-js: 
	rm -rf $(EMSCRIPTEN_BUILD_DIR)
	rm -rf build-native-tools.stamp build-js-xetex-configured.stamp build-js-xetex-toplevel.stamp
	rm -f $(XETEX_JS) $(XETEX_JS).mem $(XELATEX_EXE) $(XELATEX_JS) $(XELATEX_JS).mem $(XETEX_WORKER_JS) $(XETEX_WORKER_JS).mem 
	rm -f $(VERBOSE_LOG)

.PHONY: clean
clean: clean-js
	rm -rf $(LATEX_BASE_SOURCE_DIR)
	rm -rf texlive/ install-tl* texlive-basic.profile texlive-basic.stamp texlive-small.profile texlive-small.stamp texlive-full.profile texlive-full.stamp
	rm -rf xetex/
	rm -rf $(NATIVE_BUILD_DIR) $(SOURCES_DIR)

.PHONY: distclean
distclean: clean
	rm -f $(LATEX_BASE_ARCHIVE)
	rm -f $(INSTALL_TL_UNX_ARCHIVE)
	rm -f $(XETEX_ARCHIVE)


$(SOURCES_DIR):
	mkdir -p $@

$(XETEX_ARCHIVE):
	curl -L $(XETEX_ARCHIVE_URL) -o $@

NATIVE_WEB2C = $(addprefix $(NATIVE_BUILD_DIR)texk/web2c/, ctangle otangle tangle tangleboot tie)
NATIVE_WEB2C_WEB2C = $(addprefix $(NATIVE_BUILD_DIR)texk/web2c/web2c/, fixwrites makecpool splitup web2c)
NATIVE_WEB2C_TOOLS = $(NATIVE_WEB2C) $(NATIVE_WEB2C_WEB2C)
NATIVE_ICU_TOOLS = $(addprefix $(NATIVE_BUILD_DIR)libs/icu/icu-build/bin/, icupkg pkgdata)
NATIVE_TOOLS = $(NATIVE_WEB2C_TOOLS) $(NATIVE_BUILD_DIR)libs/freetype2/ft-build/apinames

.PHONY: native-tools
native-tools: $(NATIVE_TOOLS)

$(NATIVE_TOOLS): build-native-tools.stamp

build-native-tools.stamp: 
	@echo '>>>' Building native XeTeX distribution for compilation tools...
	mkdir -p $(NATIVE_BUILD_DIR)
	cd $(NATIVE_BUILD_DIR) && $$OLDPWD/$(XETEX_SOURCE_DIR)source/configure $(NATIVE_TOOLS_CONF)
	$(MAKE) -C $(NATIVE_BUILD_DIR) >> $(VERBOSE_LOG)
	$(MAKE) -C $(NATIVE_BUILD_DIR)libs/freetype2/ >> $(VERBOSE_LOG)
	$(MAKE) -C $(sort $(dir $(NATIVE_WEB2C))) $(notdir $(NATIVE_WEB2C)) >> $(VERBOSE_LOG)
	$(MAKE) -C $(sort $(dir $(NATIVE_WEB2C_WEB2C))) $(notdir $(NATIVE_WEB2C_WEB2C)) >> $(VERBOSE_LOG)
	$(MAKE) -C $(NATIVE_BUILD_DIR)libs/ >> $(VERBOSE_LOG)
	$(MAKE) -C $(NATIVE_BUILD_DIR)libs/icu/ >> $(VERBOSE_LOG)
	$(MAKE) -C $(NATIVE_BUILD_DIR)libs/icu/icu-build/ >> $(VERBOSE_LOG)
	touch $@

$(LIB_FREETYPE): build-js-xetex-configured.stamp $(NATIVE_BUILD_DIR)libs/freetype2/ft-build/apinames
	echo '>>>' Building xetex libraries...
	if ! emmake $(MAKE) -C $(XETEX_BUILD_DIR)libs >> $(VERBOSE_LOG); then \
		echo '>>>' First make attempt for xetex libraries failed. && \
		echo '>>>' Replacing freetype2 apinames binary from $(NATIVE_BUILD_DIR)... && \
		cp --preserve=mode $(NATIVE_BUILD_DIR)libs/freetype2/ft-build/apinames $(XETEX_BUILD_DIR)libs/freetype2/ft-build/apinames && \
		emmake $(MAKE) -C $(XETEX_BUILD_DIR)libs >> $(VERBOSE_LOG); \
	fi
	test -s $@ && touch $@


###############################################################################
# XeTeX and xdvipdfmx
###############################################################################

build-js-xetex-configured.stamp: $(XETEX_SOURCE_DIR)build.sh
	@echo '>>>' Configuring xetex...
	mkdir -p $(XETEX_BUILD_DIR)
	cd $(XETEX_BUILD_DIR) && CONFIG_SITE=$(JS_CONFIG_SITE_ABS) EMCONFIGURE_JS=2 emconfigure $$OLDPWD/$(XETEX_SOURCE_DIR)source/configure $(XETEX_CONF) >> $(VERBOSE_LOG)
	touch $@

# We define ELIDE_CODE to avoid duplicate symbols in kpathsea's own version of
# getopts.
build-js-xetex-toplevel.stamp: build-js-xetex-configured.stamp $(LIB_FONTCONFIG)
	@echo '>>>' Building xetex top level...
	EMCC_CFLAGS=-DELIDE_CODE CONFIG_SITE=$(JS_CONFIG_SITE_ABS) EMCONFIGURE_JS=2 emmake $(MAKE) -C $(XETEX_BUILD_DIR) >> $(VERBOSE_LOG)
	touch $@

xetex_bc = $(XETEX_BUILD_DIR)texk/web2c/xetex
xdvipdfmx_bc = $(XETEX_BUILD_DIR)texk/xdvipdfmx/src/xdvipdfmx

# "Inject" native tools used in the compilation
$(xetex_bc) $(xdvipdfmx_bc): xetex.stamp
INTERMEDIATE: xetex.stamp
xetex.stamp: build-js-xetex-toplevel.stamp $(NATIVE_TOOLS)
	@echo '>>>' Building xetex...
	if CONFIG_SITE=$(JS_CONFIG_SITE_ABS) EMCONFIGURE_JS=2 emmake $(MAKE) -k -C $(XETEX_BUILD_DIR)texk/web2c/ $(addprefix -o , $(NATIVE_WEB2C_TOOLS:$(NATIVE_BUILD_DIR)texk/web2c/%=%)) xetex >> $(VERBOSE_LOG); then \
		echo '>>>' Done!; \
	else \
		echo '>>>' First xetex make attempt failed. && \
		echo '>>>' Replacing icu binaries from $(NATIVE_BUILD_DIR)... && \
		mkdir -p $(XETEX_BUILD_DIR)libs/icu/icu-build/bin/ && \
		cp --preserve=mode $(NATIVE_ICU_TOOLS) $(XETEX_BUILD_DIR)libs/icu/icu-build/bin/ && \
		echo '>>>' Warning: Using stub data for libicudata.a because compilation of assembly section is not directly supported by emcc. && \
		cp $(NATIVE_BUILD_DIR)libs/icu/icu-build/stubdata/libicudata.a $(XETEX_BUILD_DIR)libs/icu/icu-build/lib/libicudata.a && \
		echo '>>>' Replacing web2c binaries from $(NATIVE_BUILD_DIR)... && \
		cp --preserve=mode $(NATIVE_WEB2C) $(XETEX_BUILD_DIR)texk/web2c/ && \
		cp --preserve=mode $(NATIVE_WEB2C_WEB2C) $(XETEX_BUILD_DIR)texk/web2c/web2c/ && \
		echo '>>>' Restarting XeTeX make... && \
		EMCONFIGURE_JS=2 emmake $(MAKE) -C $(XETEX_BUILD_DIR)texk/web2c/ $(addprefix -o , $(NATIVE_WEB2C_TOOLS:$(NATIVE_BUILD_DIR)texk/web2c/%=%)) xetex >> $(VERBOSE_LOG); \
	fi
	EMCONFIGURE_JS=2 emmake $(MAKE) -C $(XETEX_BUILD_DIR)texk/web2c/ $(addprefix -o , $(NATIVE_WEB2C_TOOLS:$(NATIVE_BUILD_DIR)texk/web2c/%=%)) xetex >> $(VERBOSE_LOG)
	touch $@

# Manually perform the final link step. The exact objects to use are determined
# from the last step of linking xetex. Doing it this way somehow avoids
# multiply-defined symbol problems. ¯\_(ツ)_/¯

xetex_web2c_dir = $(XETEX_BUILD_DIR)texk/web2c/
web2c_objs = $(addprefix $(xetex_web2c_dir), xetexdir/xetex-xetexextra.o synctexdir/xetex-synctex.o xetex-xetexini.o xetex-xetex0.o xetex-xetex-pool.o)
xetex_libs_dir = $(XETEX_BUILD_DIR)libs/
xetex_libs = $(addprefix $(xetex_libs_dir), harfbuzz/libharfbuzz.a graphite2/libgraphite2.a icu/icu-build/lib/libicuuc.a icu/icu-build/lib/libicudata.a teckit/libTECkit.a poppler/libpoppler.a libpng/libpng.a)
xetex_link = $(web2c_objs) $(LIB_FONTCONFIG) $(xetex_web2c_dir)libxetex.a $(xetex_libs) $(LIB_EXPAT) $(xetex_libs_dir)freetype2/libfreetype.a $(xetex_libs_dir)zlib/libz.a $(xetex_web2c_dir)lib/lib.a $(XETEX_BUILD_DIR)texk/kpathsea/.libs/libkpathsea.a -nodefaultlibs -Wl,-Bstatic -lstdc++ -Wl,-Bdynamic -lm -lgcc_eh -lgcc -lc -lgcc_eh -lgcc

$(XETEX_JS): xetex.pre.js $(xetex_bc)
	em++ $(EM_LINK_FLAGS) $(EM_LINK_OPT_WORKAROUND_FLAGS) --pre-js xetex.pre.js -o $@ $(xetex_link) -s TOTAL_MEMORY=536870912 -s EXPORTED_RUNTIME_METHODS=[] -s ERROR_ON_UNDEFINED_SYMBOLS=0 -s WASM=0

$(XELATEX_JS): $(XETEX_JS)
	ln -srf $< $@

.DELETE_ON_ERROR: $(XETEX_EXE)
$(XELATEX_EXE): $(XELATEX_JS)
	echo '#!/usr/bin/env node' > $@
	cat $< >> $@
	chmod a+x $@

$(XETEX_WORKER_JS): $(xetex_bc) xetex.pre.worker.js post.worker.js
	emcc $(EM_LINK_FLAGS) $(EM_LINK_OPT_REGULAR_FLAGS) --pre-js xetex.pre.worker.js --post-js post.worker.js -o $@ $(xetex_link) -s INVOKE_RUN=0 -s TOTAL_MEMORY=536870912 -s EXPORTED_RUNTIME_METHODS=[] -s ERROR_ON_UNDEFINED_SYMBOLS=0


###############################################################################
# xelatex.fmt
###############################################################################
$(LATEX_BASE_ARCHIVE):
	curl -L $(LATEX_BASE_ARCHIVE_URL) -o $@

$(XETEX_SOURCE_DIR)build.sh: $(XETEX_ARCHIVE) | $(SOURCES_DIR)
	tar xf $< -C $(SOURCES_DIR)
	cd $(SOURCES_DIR)
	test -s $@ && touch $@

$(LATEX_BASE_SOURCE_DIR): $(LATEX_BASE_ARCHIVE)
	unzip -o $<
	test -d $@ && touch $@

# Remember that we need to set argv[0] to xelatex when we invoke xetex.
xelatex.fmt: $(LATEX_BASE_SOURCE_DIR)latex.fmt
	cp $< $@

$(LATEX_BASE_SOURCE_DIR)latex.fmt: $(XELATEX) $(LATEX_BASE_SOURCE_DIR) texlive-$(TEXLIVE_INSTALL_TYPE).stamp
	TEXINPUTS=cwd/base/: ./$(XELATEX_EXE) -ini -etex -output-directory=cwd/base/ unpack.ins
	TEXINPUTS=cwd/base/: ./$(XELATEX_EXE) -ini -etex -output-directory=cwd/base/ latex.ltx


###############################################################################
# TeX Live
###############################################################################
$(INSTALL_TL_UNX_ARCHIVE):
	curl -L $(INSTALL_TL_UNX_ARCHIVE_URL) -o $@

# Create a manifest file for the texlive distribution. This manifest file is
# later consulted via XHR in the example to load the texlive tree for kpathsea.
# This part can be easily customized to your liking.
.DELETE_ON_ERROR: texlive.lst
texlive.lst: texlive-$(TEXLIVE_INSTALL_TYPE).stamp
	: > $@
	cd texlive-$(TEXLIVE_INSTALL_TYPE) && find * -type f -exec echo {} texlive-$(TEXLIVE_INSTALL_TYPE)/{} \; >> $$OLDPWD/$@

texlive-basic.profile texlive-small.profile texlive-full.profile: texlive-%.profile :
	mkdir -p texlive-$*/
# prepare a profile to install texlive
	echo selected_scheme scheme-$* > texlive-$*.profile
	echo TEXDIR `pwd`/texlive-$*/ >> texlive-$*.profile
	echo TEXMFLOCAL `pwd`/texlive-$*/texmf-local >> texlive-$*.profile
	echo TEXMFSYSVAR `pwd`/texlive-$*/texmf-var >> texlive-$*.profile
	echo TEXMFSYSCONFIG `pwd`/texlive-$*/texmf-config >> texlive-$*.profile
	echo TEXMFVAR `pwd`/texlive-$*/texmf-var >> texlive-$*.profile
	echo collection-fontsrecommended 1 >> texlive-$*.profile
	echo collection-langarabic 1 >> texlive-$*.profile
	echo collection-langchinese 1 >> texlive-$*.profile
	echo collection-langcjk 1 >> texlive-$*.profile
	echo collection-langcyrillic 1 >> texlive-$*.profile
	echo collection-langczechslovak 1 >> texlive-$*.profile
	echo collection-langenglish 1 >> texlive-$*.profile
	echo collection-langeuropean 1 >> texlive-$*.profile
	echo collection-langfrench 1 >> texlive-$*.profile
	echo collection-langgerman 1 >> texlive-$*.profile
	echo collection-langgreek 1 >> texlive-$*.profile
	echo collection-langitalian 1 >> texlive-$*.profile
	echo collection-langjapanese 1 >> texlive-$*.profile
	echo collection-langkorean 1 >> texlive-$*.profile
	echo collection-langother 1 >> texlive-$*.profile
	echo collection-langpolish 1 >> texlive-$*.profile
	echo collection-langportuguese 1 >> texlive-$*.profile
	echo collection-langspanish 1 >> texlive-$*.profile

texlive-basic-downloaded.stamp texlive-small-downloaded.stamp texlive-full-downloaded.stamp: texlive-%-downloaded.stamp : $(INSTALL_TL_UNX_ARCHIVE) texlive-%.profile
	tar xf $(INSTALL_TL_UNX_ARCHIVE)
	install-tl-*/install-tl -profile texlive-$*.profile
	touch $@

texlive-basic.stamp texlive-small.stamp texlive-full.stamp: texlive-%.stamp : texlive-%-downloaded.stamp
	rm -rf texlive-$*/bin/ texlive-$*/tlpkg/ texlive-$*/texmf-dist/doc/ texlive-$*/texmf-var/doc/ texlive-$*/readme-html.dir/ texlive-$*/readme-txt.dir/ texlive-$*/index.html texlive-$*/doc.html texlive-$*/install-tl.log
	find texlive-$*/ -executable -type f -exec rm {} +
	touch $@
