FROM ubuntu:24.04
WORKDIR /

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y sudo wget unzip dos2unix python-is-python3 python3-dev mariadb-server && \
    apt-get clean


VOLUME ["/home/xui", "/var/lib/mysql"]
EXPOSE 80

ENTRYPOINT ["/wrapper.sh"]
