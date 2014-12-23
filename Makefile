all: install-node-modules
	@echo 'Done!'

before-commit: copy-output-devel-data-json clean-devel

copy-output-devel-data-json:
	@cp src/output/devel/fakeDataFiles/before-commit.json src/output/devel/data.json

install-node-modules:
	@sudo npm install

output-server:
	@echo "Server running in 8081"
	@cd src/output/devel; http-server -c-1 -s

clean-devel:
	@rm -rf src/output/devel/js
	@rm -rf src/output/devel/css
	@rm -rf src/output/devel/index.html
	@rm -rf src/output/devel/components
