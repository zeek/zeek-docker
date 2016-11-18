all: $(patsubst %.Dockerfile,squash-stamp_%,$(wildcard *.Dockerfile))

build-stamp_%: %.Dockerfile
	docker build -t broplatform/bro:$(*)_fat -f $< . 
	touch $@

# https://github.com/goldmann/docker-squash/
squash-stamp_%: build-stamp_%
	docker-squash -t broplatform/bro:$(*) broplatform/bro:$(*)_fat
	touch $@

push-stamp_%: squash-stamp_%
	docker push broplatform/bro:$(*)
	touch $@

push_all: $(patsubst %.Dockerfile,push-stamp_%,$(wildcard *.Dockerfile))
