ver = 2.3.1
all:
	docker build -t bro:$(ver)_builder ./
	docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) -ti --name bro_$(ver)_builder bro:$(ver)_builder
