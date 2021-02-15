FROM rust:1.50-alpine3.12

ENV deny_version=0.8.5

RUN set -eux; \
    apk update; \
    apk add bash curl git; \
    curl --silent -L https://github.com/EmbarkStudios/cargo-deny/releases/download/$deny_version/cargo-deny-$deny_version-x86_64-unknown-linux-musl.tar.gz | tar -xzv -C /usr/bin --strip-components=1;

# Ensure rustup is up to date.
RUN bash -c "sh <(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) -y"

# Pin rust to the version of our base image, regardless of any settings
# in the repo itself
RUN mkdir -p /github/workspace && rustup override set --path /github/workspace 1.50.0

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
