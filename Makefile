all: $(patsubst %.Dockerfile,squash-stamp_%,$(wildcard *.Dockerfile))

build-stamp_%: %.Dockerfile
	docker build -t broplatform/bro:$(*)_fat -f $< . 
	touch $@

squash-stamp_%: build-stamp_%
	docker save broplatform/bro:$(*)_fat | sudo docker-squash -t broplatform/bro:$(*) | docker load
	touch $@

push-stamp_%: squash-stamp_%
	docker push broplatform/bro:$(*)
	touch $@

push_all: $(patsubst %.Dockerfile,push-stamp_%,$(wildcard *.Dockerfile))
