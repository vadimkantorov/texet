### TODO
1. auto-cloning
2. Store file sha hashes in .git directory
3. Upload a file from local system
6. arg1/arg2
7. TexLive / xetex.js
8. Ctrl+V, command history
9. Figure out Terminal sizing
10. file tab auto-complete

### Links
https://stackoverflow.com/questions/61496876/how-can-i-load-a-file-from-a-html-input-into-emscriptens-memfs-file-system

https://github.com/latexjs/latexjs

https://github.com/emscripten-core/emscripten/issues/2040

https://stackoverflow.com/questions/54466870/emscripten-offer-to-download-save-a-generated-memfs-file

https://git-scm.com/docs/gitrepository-layout

https://stackoverflow.com/questions/59983250/there-is-any-standalone-version-of-the-treeview-component-of-vscode

https://stackoverflow.com/questions/32912129/providing-stdin-to-an-emscripten-html-program

https://itnext.io/build-ffmpeg-webassembly-version-ffmpeg-js-part-3-ffmpeg-js-v0-1-0-transcoding-avi-to-mp4-f729e503a397

https://medium.com/codingtown/xterm-js-terminal-2b19ccd2a52

https://jsfiddle.net/pdfjs/wagvs9Lf/

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

https://developer.github.com/v3/repos/contents/#create-or-update-file-contents
https://github.com/zrxiv/browserext/blob/master/backend.js
http://www.levibotelho.com/development/commit-a-file-with-the-github-api/

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

open https://localhost:8080
```

