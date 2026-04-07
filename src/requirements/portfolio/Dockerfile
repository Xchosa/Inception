
FROM debian:bookworm-slim


RUN apt update && apt upgrade -y && \
	rm -rf /var/lib/apt/lists/*

# copy current directory in container
COPY ./tools/ /

EXPOSE 80

CMD [ "executable", " -g", "daemoon off" ]