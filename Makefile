all: install-node-modules install-python-libraries-dev
	@echo 'Done!'

clear-devel:
	@cd src/display/devel; rm -rf components css js data.json index.html

clear-pyc:
	@find . -type f -name "*.pyc" -print0 | xargs -0 rm -rf

install-node-modules:
	sudo npm install

install-python-libraries-dev:
	sudo pip install -r src/vendor/python-requirements-dev.txt

grunt:
	@grunt watch

generate-sphinx-docs:
	@sphinx-apidoc -o untracked-docs/sphinx src/data-analysis

release: generate-sphinx-docs
	@grunt release

server:
	@cd src/display/devel; \
		../../../node_modules/supervisor/lib/cli-wrapper.js -e coffee,txt \
		-w ../../../src/cli/run-server.coffee,../../../src/display/devel/changeme.txt -- ../../../bin/encina.js server

tests-travis: tests-unit-frontend
set-test-bin-executable:
	@chmod +x test/bin/*
	@echo "The bin files in the test directory are now executables"

# Tests

tests-e2e-backend:
	@nosetests test/e2e/backend

tests-e2e-frontend-visual:
	@sh test/bin/e2e-frontend visual

tests-e2e-frontend-headless:
	@sh test/bin/e2e-frontend headless

tests-unit-frontend:
	@node_modules/karma-cli/bin/karma start test/unit/frontend/karma.conf.coffee --single-run

tests-unit-backend:
	@sh test/bin/unit-backend