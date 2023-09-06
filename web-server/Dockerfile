FROM haskell:latest as builder

WORKDIR /app

COPY . .

EXPOSE 8080

RUN cabal update

RUN cabal build

RUN cabal install --installdir=.

FROM debian:bookworm-slim

COPY --from=builder /app /app

WORKDIR /app

CMD [ "/app/dist-newstyle/build/aarch64-linux/ghc-9.6.2/web-server-0.1.0.0/x/web-server/build/web-server/web-server" ]
