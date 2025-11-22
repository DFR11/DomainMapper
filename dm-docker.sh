#!/bin/bash

# Function to check for Docker presence
check_docker() {
    if command -v docker >/dev/null 2>&1; then
        echo "Docker is already installed. Version: $(docker --version)"
        return 0  # Docker installed
    else
        echo "Docker not found. Installing Docker..."
        return 1  # Docker is not installed
    fi
}

# Check and install Docker if it is not there
if ! check_docker; then
    echo "We update the list of packages and install the necessary components..."
    apt update && apt install -y git curl

    curl -fsSL https://get.docker.com -o get-docker.sh
    sh ./get-docker.sh
    rm get-docker.sh  # Delete the installation script after installation
fi

# Clone the repository if it doesn't exist
if [ ! -d "./DomainMapper" ]; then
    echo "Clone the DomainMapper repository..."
    git clone https://github.com/Ground-Zerro/DomainMapper.git
else
    echo "The DomainMapper repository has already been cloned."
fi

# Checking the presence of a Docker image
if ! docker image inspect domainmapper >/dev/null 2>&1; then
    echo "Docker image not found. Putting together a new look..."

    echo "We install only the components necessary for operation..."
    apt update && apt install -y software-properties-common wget build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
        liblzma-dev tzdata && \
        rm -rf /var/lib/apt/lists/*

    # Creating a Dockerfile with fixes
    echo "Creating a Dockerfile..."
    cat > Dockerfile <<EOL
FROM ubuntu:jammy

# Installing the necessary packages to build Python
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get update && \
    apt-get install -y wget build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev tzdata && \
    ln -fs /usr/share/zoneinfo/\$TZ /etc/localtime && \
    echo \$TZ > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/*

# Download and install Python 3.12
RUN wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz && \
    tar -xvf Python-3.12.0.tgz && \
    cd Python-3.12.0 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    cd .. && \
    rm -rf Python-3.12.0 Python-3.12.0.tgz

# Install pip for Python 3.12
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12

WORKDIR /app
ADD ./DomainMapper /app

# Install project dependencies, if specified
RUN if [ -f "requirements.txt" ]; then \
        python3.12 -m pip install --upgrade pip && \
        python3.12 -m pip install -r requirements.txt; \
    fi

CMD ["python3.12", "main.py"]
EOL

    # Create a file domain-ip-resolve.txt if it does not exist
    if [ ! -f "./domain-ip-resolve.txt" ]; then
        echo "Create a phone domain-ip-reolve.txt..."
        touch domain-ip-resolve.txt
        echo "The domain-ip-resolve.txt file has been created."
    else
        echo "The file domain-ip-resolve.txt already exists."
    fi

    # Building a Docker image
    echo "Building a Docker image..."
    docker build -t domainmapper .

    # Clearing the Docker cache after building
    echo "Clearing build cache Docker..."
    docker builder prune -f
else
    echo "The domainmapper Docker image already exists."
fi

# Check for the presence of a container and run main.py from the existing container
if docker ps -a | grep -q domainmapper_container; then
    echo "The container already exists. Run main.py..."
    docker start -i domainmapper_container
else
    echo "Create and launch a new container..."
    docker run --name domainmapper_container -v "$(pwd)/domain-ip-resolve.txt:/app/domain-ip-resolve.txt" -it domainmapper
fi

# We inform the user about the location of the file
echo "The container has completed its operation. The file domain-ip-resolve.txt is located in $(pwd)/domain-ip-resolve.txt"

# Delete the script after execution
echo "The script is complete."
rm -- "$0"
