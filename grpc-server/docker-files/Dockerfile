FROM rust:slim-bookworm as builder

WORKDIR /app

COPY . .

RUN cargo build --bin http --features http --release

FROM debian:bookworm-slim

COPY --from=builder /app /app

WORKDIR /app

CMD [ "/app/target/release/http" ]
