grunt:
	@grunt watch

server:
	@echo "Server running in 8081"
	@http-server -c-1 -s

copy-docs: copy-docs-groc

copy-docs-groc:
	@rm -rf groc-docs
	@mv untracked-docs groc-docs