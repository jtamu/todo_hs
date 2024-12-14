FROM haskell:9.6

ARG APP_DIR="/opt/app"

RUN mkdir -p "${APP_DIR}/.ghcup/bin"
RUN curl -LJ "https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup" -o "${APP_DIR}/.ghcup/bin/ghcup"
RUN chmod +x "${APP_DIR}/.ghcup/bin/ghcup"

ENV PATH="${APP_DIR}/.cabal/bin:${APP_DIR}/.ghcup/bin:$PATH"

RUN ghcup install cabal recommended --set
RUN ghcup install hls recommended --set
RUN cabal update

WORKDIR ${APP_DIR}/src
COPY ./src/ .

ENTRYPOINT ["/bin/bash"]
