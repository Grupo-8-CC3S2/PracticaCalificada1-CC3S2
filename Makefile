OBJETIVO ?=example.com
SERVIDOR ?=8.8.8.8

.PHONY: run 
run :
	@sudo TARGET=$(OBJETIVO) DNS_SERVER=$(SERVIDOR) bash src/dns_check.sh

