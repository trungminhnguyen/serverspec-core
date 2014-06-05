BUNDLE   ?= bundle
RAKE    ?= rake

bootstrap:
	$(BUNDLE) install --standalone

serverspec:
	$(BUNDLE) exec $(RAKE)

.PHONY: bootstrap serverspec
