test-ci:
	ponyc test -o build --debug
	build/test
