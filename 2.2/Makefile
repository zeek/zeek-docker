ver = 2.2
all:
	docker build -t bro:$(ver)_fat ./
	docker save bro:$(ver)_fat | sudo docker-squash -t bro:$(ver) | docker load
