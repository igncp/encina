all: install-node-modules
	@echo 'Done!'

install-node-modules:
	@sudo npm install

server:
	@echo "Server running in 8081"
	@cd src/output/devel; http-server -c-1 -s

grunt:
	@grunt watch

clear-devel:
	@cd src/output/devel; rm -rf components css js data.json index.html