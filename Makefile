TEST_DIR = test/common test/unit test/local test/saucelabs

DEFAULT:
	@echo
	@echo '  make test -> run the unit and  local tests (start selenium with chromedriver first).'
	@echo '  make test_unit -> run the unit tests'
	@echo '  make test_local -> run the local tests (start selenium with chromedriver first).'
	@echo '  make test_saucelabs -> run the saucelabs tests (configure username/access_key first).'
	@echo '  make test_coverage -> generate test coverage (install jscoverage first).'
	@echo '  make compile2js -> compile coffee files to js.'
	@echo '  make compile2js_watch -> compile coffee files to js, watch for changes.'
	@echo '  make cleanGenJs -> clean js files generated from coffeescript.'
	@echo '  build_mapping -> build the mapping (implemented only).'  
	@echo '  build_full_mapping -> build the mapping (full).'  
	@echo

# run unit and local tests, start selenium server first
test:
	./node_modules/.bin/mocha \
	test/unit/*-test.coffee \
	test/local/*-test.coffee

# run unit tests
test_unit:
	./node_modules/.bin/mocha test/unit/*-test.coffee

# run local tests, start selenium server first
test_local:
	./node_modules/.bin/mocha test/local/*-test.coffee

# run saucelabs test, configure username/key first
test_saucelabs:
	./node_modules/.bin/mocha test/saucelabs/*-test.coffee

# run test coverage, install jscoverage first
test_coverage:
	rm -rf lib-cov
	jscoverage --no-highlight lib lib-cov --exclude=bin.js
	WD_COV=1 ./node_modules/.bin/mocha --reporter html-cov \
	test/unit/*-test.coffee \
	test/local/*-test.coffee \
	test/saucelabs/*-test.coffee \
  > coverage.html

# remove all the generated js
cleanGenJs:
	@rm -f test/common/*.js test/local/*.js test/unit/*.js test/saucelabs/*.js

# compile once
compile2js:
	@./node_modules/.bin/coffee --compile $(TEST_DIR)
# compile, and then watch for changes
compile2js_watch:
	./node_modules/.bin/coffee --compile --watch $(TEST_DIR)

_dox:
	@mkdir -p tmp
	@./node_modules/.bin/dox -r < lib/webdriver.js > tmp/webdriver-dox.json
	@./node_modules/.bin/dox -r < lib/element.js > tmp/element-dox.json

# build the mapping (implemented only)
build_mapping: _dox
	@./node_modules/.bin/coffee doc/mapping-builder.coffee

# build the mapping (full)
build_full_mapping: _dox
	@./node_modules/.bin/coffee doc/mapping-builder.coffee full

.PHONY: \
	test \
	test_unit \
	test_local \
	test_saucelabs \
	test_coverage \
	compile2js \
	compile2js_watch \
	cleanGenJs DEFAULT \
  build_mapping \
  build_full_mapping \
	_dox