all: install-node-modules install-python-libraries
	@echo 'Done!'

clear-devel:
	@cd src/output/devel; rm -rf components css js data.json index.html

install-node-modules:
	sudo npm install

install-python-libraries-dev:
	sudo pip install -r src/vendor/python-requirements-dev.txt

grunt:
	@grunt watch

server:
	@echo "Server running in 8081"
	@cd src/output/devel; http-server -c-1 -s

tests-e2e-frontend-visual:
	@(export ENCINA_TEST_MODE='visual' && nosetests test/e2e/frontend)