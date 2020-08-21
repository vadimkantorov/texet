assets/test.txt:
	mkdir -p assets
	echo "Hello world" > assets/test.txt

assets/test.pdf:
	mkdir -p assets
	wget -O assets/test.pdf https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf

cat.js:
	emcc cat.c --preload-file assets -o cat.js 

clean:
	rm cat.html *.data *.wasm

.PHONY: clean
