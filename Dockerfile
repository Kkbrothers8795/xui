FROM ubuntu:20.04
WORKDIR /

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y sudo wget unzip dos2unix python-is-python3 python3-dev mariadb-server cron && \
    apt-get clean
    
RUN wget http://launchpadlibrarian.net/475574732/libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
    dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
    dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    wget https://valut.iptvtools.io/xuione/installxui.sh
    
COPY . /

RUN chmod +x installxui.sh && \
    bash installxui.sh -Y

# Create a wrapper script that checks for installation
RUN echo '#!/bin/bash\n\
    if [ -f "/home/xui/status" ]; then\n\
        echo "XUI already installed, starting service..."\n\
        service mariadb start\n\
        /home/xui/service start\n\
    else\n\
        echo "Starting fresh installation..."\n\
        apt install nano cron -y && \
        bash <(wget -qO- https://valut.iptvtools.io/xuione/installxui.sh) -Y \n\
    fi\n\
    tail -f /dev/null' > /wrapper.sh && \
    chmod +x /wrapper.sh

VOLUME ["/home/xui", "/var/lib/mysql"]
EXPOSE 80

ENTRYPOINT ["/wrapper.sh"]
