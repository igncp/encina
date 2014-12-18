all: install-node-modules
	@echo 'Done!'

before-commit: copy-output-devel-data-json copy-and-rm-output-devel-index

copy-output-devel-data-json:
	@cp src/output/devel/fakeDataFiles/before-commit.json src/output/devel/data.json

copy-and-rm-output-devel-index:
	@cp src/output/devel/index.html src/output/index.html
	@rm src/output/devel/index.html

copy-output-index-to-devel:
	@cp src/output/index.html src/output/devel/index.html

install-node-modules:
	@sudo npm install

output-server:
	@echo "Server running in 8081"
	@cd src/output/devel; http-server -c-1 -s