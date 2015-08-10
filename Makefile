tarball:
	scl enable ruby193 'bundle install --standalone --binstubs --without=development'
	tar cvf sources.tar * .bundle
clean:
	rm -rf sources.tar
