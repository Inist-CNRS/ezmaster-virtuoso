.PHONY: help build

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## build the docker inistcnrs/ezmaster-virtuoso:4.0.0 image locally
	@docker build -t inistcnrs/ezmaster-virtuoso:4.0.0 --build-arg http_proxy --build-arg https_proxy .
