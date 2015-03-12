all: $(patsubst %.Dockerfile,squash-stamp_%,$(wildcard *.Dockerfile))

build-stamp_%: %.Dockerfile
	docker build -t broplatform/bro:$(*)_fat -f $< . 
	touch $@

squash-stamp_%: build-stamp_%
	docker save broplatform/bro:$(*)_fat | sudo docker-squash -t broplatform/bro:$(*) | docker load
	touch $@
