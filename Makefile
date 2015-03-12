all: $(patsubst %.Dockerfile,squash-stamp_%,$(wildcard *.Dockerfile))

build-stamp_%: %.Dockerfile
	docker build -t bro:$(*)_fat -f $<
	touch $@

squash-stamp_%: build-stamp_%
	docker save bro:$(*)_fat | sudo docker-squash -t bro:$(*) | docker load
	touch $@
