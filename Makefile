all: $(patsubst %.Dockerfile,build-stamp_%,$(wildcard *.Dockerfile))

push-stamp_%: build-stamp_%
	docker push broplatform/bro:$(*)
	touch $@

push_all: $(patsubst %.Dockerfile,push-stamp_%,$(wildcard *.Dockerfile))

# For older versions from 1.5 to 2.x.x, we will use the old Dockerfile
build-stamp_1.%: 1.%.Dockerfile
	docker build --build-arg MAXMIND_LICENSE_KEY -t broplatform/bro:1.$(*) -f $< . 
	touch $@

build-stamp_2.%: 2.%.Dockerfile
	docker build --build-arg MAXMIND_LICENSE_KEY -t broplatform/bro:2.$(*) -f $< . 
	touch $@

# Starting from 3.0.0, we will use a single Dockerfile by passing more build-args
build-stamp_%: 
	docker build --build-arg MAXMIND_LICENSE_KEY --build-arg ZEEK_VER=$(*) --build-arg BUILD_TYPE=$(BUILD_TYPE) -t broplatform/bro:$(*) -f Dockerfile . 
	touch $@
