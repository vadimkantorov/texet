project/test.txt:
	mkdir -p project
	echo "console.log('Hello world')" > project/test.txt

project/test.pdf:
	mkdir -p project
	wget -O project/test.pdf https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf

cat.js:
	emcc cat.c --preload-file project -s INVOKE_RUN=0 -s EXPORTED_FUNCTIONS='["_main"]' -s EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' -o cat.js 

clean:
	rm *.js *.data *.wasm

.PHONY: clean
