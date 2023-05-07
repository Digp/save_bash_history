define PRINT_HELP_SCRIPT
while read line; do
    if [[ $$line =~ ^([a-zA-Z_-]+):.*?##\ (.*)$$ ]]; then
        target=$${BASH_REMATCH[1]}
        help=$${BASH_REMATCH[2]}
        printf "%-20s %s\n" "$$target" "$$help"
    fi
done < $(MAKEFILE_LIST)
endef
export PRINT_HELP_SCRIPT

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@/bin/bash -c "$$PRINT_HELP_SCRIPT" -- $(MAKEFILE_LIST)

clean: ## Remove build artifacts
	rm -fr build/

install: clean ## Install
	cp -r source build
	@/bin/bash -c build/install.sh

status: ## Get service status
	sudo systemctl status save_history.service

logs: ## Get service logs
	sudo journalctl -u save_history.service

uninstall: ## Uninstall
	@/bin/bash -c source/uninstall.sh