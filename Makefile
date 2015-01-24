all:
	cp -al common 1.5
	$(MAKE) -C 1.5

	cp -al common 2.1
	$(MAKE) -C 2.1

	cp -al common 2.2
	$(MAKE) -C 2.2

	cp -al common 2.3.1
	$(MAKE) -C 2.3.1

	cp -al common master
	$(MAKE) -C master
