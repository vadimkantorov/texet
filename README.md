https://itnext.io/build-ffmpeg-webassembly-version-ffmpeg-js-part-3-ffmpeg-js-v0-1-0-transcoding-avi-to-mp4-f729e503a397

https://stackoverflow.com/questions/32912129/providing-stdin-to-an-emscripten-html-program

https://mozilla.github.io/pdf.js/examples/index.html#interactive-examples

https://github.com/AREA44/vscode-LaTeX-support

https://registry.npmjs.org/monaco-editor/-/monaco-editor-0.20.0.tgz

https://github.com/lyze/xetex-js

https://tug.org/svn/texlive/trunk/Build/source/

https://github.com/TeX-Live/texlive-source

https://github.com/TeX-Live/xetex

https://github.com/kisonecat/web2js

https://github.com/kisonecat/dvi2html

https://people.math.osu.edu/fowler.291/latex/

https://github.com/manuels/texlive.js/

https://microsoft.github.io/monaco-editor/

https://browsix.org/latex-demo-sync/

https://github.com/tbfleming/em-shell

### Install Emscripten
```shell
# https://emscripten.org/docs/getting_started/downloads.html#installation-instructions 
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
```

### Activate Emscripten
```shell
source ./emsdk_env.sh
```

### Build
```shell
make assets/test.txt assets/test.pdf
make cat.html
```

### Run
```shell
python3 serve.py
```

