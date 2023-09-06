CORES = 1

build-all:
	cd web-server && SCRIPT='' docker build -t hs-test-server . &
	cd grpc-server && SCRIPT='' docker build -t rs-test-server-http -f docker-files/Dockerfile . &
	cd grpc-server && SCRIPT='' docker build -t rs-test-server-grpc -f docker-files/Dockerfile2 . &

http-rust:
	export CORES=$(CORES); \
	SCRIPT='' docker compose --profile http-rs up -d
	echo "http://localhost:3000/d/k6/k6-load-testing-results?orgId=1&refresh=5s"


http-haskell:
	export CORES=$(CORES); \
	SCRIPT='' docker compose --profile http-hs up -d
	echo "http://localhost:3000/d/k6/k6-load-testing-results?orgId=1&refresh=5s"

grpc-rust:
	export CORES=$(CORES); \
	SCRIPT='' docker compose --profile grpc up -d
	echo "http://localhost:3000/d/k6/k6-load-testing-results?orgId=1&refresh=5s"

down:
	export CORES=$(CORES); \
	SCRIPT='' docker compose down
	export CORES=$(CORES); \
	SCRIPT='' docker compose down --remove-orphans

down-server:
	export CORES=$(CORES); \
	docker stop protocol-testing-rust_http_server-1 &
	export CORES=$(CORES); \
	docker stop protocol-testing-haskell_http_server-1 &
	export CORES=$(CORES); \
	docker stop protocol-testing-rust_grpc_server-1 &

http-rust-test:
	export CORES=$(CORES); \
	SCRIPT=http-rs.js docker compose up k6


http-haskell-test:
	export CORES=$(CORES); \
	SCRIPT=http-hs.js docker compose up k6

grpc-rust-test:
	export CORES=$(CORES); \
	SCRIPT=grpc.js docker compose up k6

help:
	echo build-all: for building images
	echo http-rust: run the rust http server
	echo http-haskell: run the haskell http server
	echo grpc-rust: run the rust grpc server
	echo 
	echo 
	echo test-http-rs: run the load test for http rust
	echo test-http-hs: run the load test for http haskell
	echo test-grpc-rs: run the load test for grpc rust
