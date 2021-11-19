# Specify the version of Go to use
FROM alpine:3.9.6

# Copy all the files from the host into the container
WORKDIR /src
COPY . .

RUN chmod +x /src/scripts/gen-forks-file.sh

# Specify the container's entrypoint as the action
ENTRYPOINT ["/src/scripts/gen-forks-file.sh"]