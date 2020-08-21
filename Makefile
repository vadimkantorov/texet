assets/test.txt:
	mkdir -p assets
	echo "console.log('Hello world')" > assets/test.txt

assets/test.pdf:
	mkdir -p assets
	wget -O assets/test.pdf https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf

cat.js:
	emcc cat.c --preload-file assets -s INVOKE_RUN=0 -s EXPORTED_FUNCTIONS='["_main"]' -s EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' -o cat.js 

clean:
	rm *.js *.data *.wasm

.PHONY: clean
