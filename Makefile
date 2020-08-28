Gest:
	mkdir -p test

test/test.txt: test
	echo "console.log('Hello world')" > test/test.txt

test/test.pdf: test
	wget -O test/test.pdf https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf

test/test.png: test
	wget -O test/test.png https://www.google.fr/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png

test/test.svg: test
	wget -O test/test.svg https://upload.wikimedia.org/wikipedia/commons/c/c3/Flag_of_France.svg

test/test.tex: test
	echo '\documentclass{article}' > test/test.tex
	echo '\begin{document}Hello, world!\end{document}' >> test/test.tex

emscriptenfs.js: test/test.txt test/test.pdf test/test.png test/test.svg test/test.tex
	emcc emscriptenfs.c -o $@ --preload-file test@/home/web_user/test -s FORCE_FILESYSTEM=1 -s INVOKE_RUN=0 

cat.js: 
	emcc cat.c -o $@ -s INVOKE_RUN=0 -s EXPORTED_FUNCTIONS='["_main"]' -s EXPORTED_RUNTIME_METHODS='["callMain"]' -s MODULARIZE=1 -s EXPORT_NAME=cat

cowsay.js: 
	emcc cowsay.c -o $@ -s INVOKE_RUN=0 -s EXPORTED_FUNCTIONS='["_main"]' -s EXPORTED_RUNTIME_METHODS='["callMain"]' -s MODULARIZE=1 -s EXPORT_NAME=cowsay

clean:
	rm *.js *.data *.wasm

.PHONY: clean
