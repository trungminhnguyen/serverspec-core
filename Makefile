tarball:
	bundle install --standalone --binstubs --without=development &> bundle.log
	tar cvf sources.tar * .bundle
clean:
	rm -rf sources.tar
