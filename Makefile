build:
	docker build . -t symfony-docs
	docker run --rm --name symfony-docs -p 8080:80 symfony-docs
