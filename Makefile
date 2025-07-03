.PHONY: debug release stop clean

debug:
	docker compose up --build --detach

release:
	docker compose -f docker-compose.yml -f docker-compose.postgres.yml up --build -d

stop:
	docker compose down

clean:
	docker compose down --volumes --rmi all
