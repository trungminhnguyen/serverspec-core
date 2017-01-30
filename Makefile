bundle = bundle install --standalone --binstubs --without=development
release := $(shell lsb_release -rs)
tarball:
	if [[ "$(release)" =~ 6\..* ]]; then    \
		scl enable ruby193 "$(bundle)"; \
	else                                    \
		$(bundle);                      \
	fi &> bundle.log
	tar cvf sources.tar $(shell git ls-tree  --name-only HEAD) .bundle
clean:
	rm -rf sources.tar
