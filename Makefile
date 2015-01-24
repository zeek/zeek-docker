all:
	$(MAKE) -C build

	cp -al common 2.3.1
	$(MAKE) -C 2.3.1
