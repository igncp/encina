all: install-node-modules install-python-libraries
	@echo 'Done!'

clear-devel:
	@cd src/output/devel; rm -rf components css js data.json index.html

clear-pyc:
	@find . -type f -name "*.pyc" -print0 | xargs -0 rm -rf

install-node-modules:
	sudo npm install

install-python-libraries-dev:
	sudo pip install -r src/vendor/python-requirements-dev.txt

grunt:
	@grunt watch

server:
	@echo "Server running in 8081"
	@cd src/output/devel; http-server -c-1 -s

tests-travis: tests-e2e-backend tests-unit-frontend


# Tests

tests-e2e-backend:
	@nosetests test/e2e/backend

tests-e2e-frontend-visual:
	@(export ENCINA_TEST_MODE='visual' && nosetests test/e2e/frontend --nocapture)

tests-e2e-frontend-headless:
	@(export ENCINA_TEST_MODE='headless' && nosetests test/e2e/frontend --nocapture)

tests-unit-frontend:
	@node_modules/karma-cli/bin/karma start test/unit/frontend/karma.conf.coffee --single-run