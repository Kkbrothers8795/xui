FROM ubuntu:24.04
WORKDIR /

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y sudo wget unzip dos2unix python-is-python3 python3-dev mariadb-server && \
    apt-get clean

RUN wget https://raw.githubusercontent.com/PabloServers/xui.one/refs/heads/main/install.sh && \
    chmod +x install.sh

# Create a wrapper script that checks for installation
RUN echo '#!/bin/bash\n\
    if [ -f "/home/xui/status" ]; then\n\
        echo "XUI already installed, starting service..."\n\
        service mariadb start\n\
        /home/xui/service start\n\
    else\n\
        echo "Starting fresh installation..."\n\
        bash install.sh \n\
    fi\n\
    tail -f /dev/null' > /wrapper.sh && \
    chmod +x /wrapper.sh


VOLUME ["/home/xui", "/var/lib/mysql"]
EXPOSE 80

ENTRYPOINT ["/wrapper.sh"]
