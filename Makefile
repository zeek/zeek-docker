all: $(patsubst %.Dockerfile,build-stamp_%,$(wildcard *.Dockerfile))

build-stamp_%: %.Dockerfile
	docker build --build-arg MAXMIND_LICENSE_KEY -t broplatform/zeek:$(*) -f $< . 
	touch $@

push-stamp_%: build-stamp_%
	docker push broplatform/bro:$(*)
	touch $@

push_all: $(patsubst %.Dockerfile,push-stamp_%,$(wildcard *.Dockerfile))
