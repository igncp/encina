all: install-node-modules
	@echo 'Done!'

install-node-modules:
	@sudo npm install

server:
	@echo "Server running in 8081"
	@cd src/output/devel; http-server -c-1 -s

grunt:
	@grunt watch

generate-devel-data:
	@./bin/encina.js examine . >/dev/null
	@cp encina-report/data.json src/output/devel/
	@rm -rf ./encina-report
	@echo 'Data copied to ./src/output/devel/data.json'