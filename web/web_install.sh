#!/bin/bash

set -e  # Terminating a script on error
set -u  # Completion when using undeclared variables

# Variables
USERNAME="test123"
APP_DIR="/home/$USERNAME/dns_resolver_app"
SERVICE_FILE="/etc/systemd/system/dns_resolver.service"
NGINX_CONF="/etc/nginx/sites-available/dns_resolver"
EMAIL_ADR="email@example.com"
DOMAIN_NAME="your-domain.com"

# Checking user existence
if ! id "$USERNAME" &>/dev/null; then
    echo "The user $USERNAME does not exist."
    read -p "Want to create a user? (y/n):" CREATE_USER
    if [[ "$CREATE_USER" =~ ^[Yy]$ ]]; then
        sudo useradd -m -s /bin/bash "$USERNAME"
        echo "The user $USERNAME was created successfully."
    else
        echo "The script terminated because the user does not exist."
        exit 1
    fi
fi

# Make sure that user $USERNAME and www-data have the same group
sudo usermod -aG www-data "$USERNAME"

# Updating the system and installing dependencies
echo "We update the system and install dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install python3 python3-pip python3-venv gunicorn nginx certbot python3-certbot-nginx -y

# Creating an application directory
if [[ ! -d "$APP_DIR" ]]; then
    echo "Create an application directory..."
    sudo mkdir -p "$APP_DIR"
    sudo chown -R "$USERNAME:www-data" "$APP_DIR"
    sudo chmod -R 750 "$APP_DIR"
else
    echo "The application directory already exists. Let's skip it."
fi

# Creating a virtual environment on behalf of www-data
if [[ ! -d "$APP_DIR/venv" ]]; then
    echo "Creating a virtual environment..."
    sudo -u www-data python3 -m venv "$APP_DIR/venv"
    sudo chown -R "$USERNAME:www-data" "$APP_DIR/venv"
    sudo chmod -R 750 "$APP_DIR/venv"
else
    echo "The virtual environment already exists. Let's skip it."
fi

# Loading the requirements.txt file
REQUIREMENTS_URL="https://raw.githubusercontent.com/Ground-Zerro/DomainMapper/refs/heads/main/requirements.txt"
if curl --head --fail "$REQUIREMENTS_URL" &>/dev/null; then
    curl -o "$APP_DIR/requirements.txt" "$REQUIREMENTS_URL"
    echo "The requirements.txt file has been successfully downloaded."
else
    echo "Error: The requirements.txt file is not available."
    exit 1
fi

# Installing Python dependencies as www-data
echo "Installing Python dependencies..."
sudo -u www-data bash -c "source $APP_DIR/venv/bin/activate && pip install -r $APP_DIR/requirements.txt fastapi uvicorn pydantic gunicorn"

# Uploading Application Files
FILES=("index.html" "app.py" "main.py")
for FILE in "${FILES[@]}"; do
    URL="https://raw.githubusercontent.com/Ground-Zerro/DomainMapper/refs/heads/main/web/$FILE"
    if curl --head --fail "$URL" &>/dev/null; then
        curl -o "$APP_DIR/$FILE" "$URL"
        echo "The $FILE file was successfully loaded."
        sudo chown "$USERNAME:www-data" "$APP_DIR/$FILE"
        sudo chmod 640 "$APP_DIR/$FILE"
    else
        echo "Error: File $FILE is not available."
    fi
done

# Checking access rights
sudo chown -R "$USERNAME:www-data" "$APP_DIR"
sudo chmod -R 750 "$APP_DIR"

# Creating a system service
echo "We are creating a system service..."
sudo bash -c "cat <<EOF > $SERVICE_FILE
[Unit]
Description=DNS Resolver Web App
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=$APP_DIR
ExecStart=$APP_DIR/venv/bin/gunicorn -w 4 -k uvicorn.workers.UvicornWorker --bind 127.0.0.1:5000 app:app

[Install]
WantedBy=multi-user.target
EOF"

sudo systemctl daemon-reload
sudo systemctl enable --now dns_resolver

# Setting up Nginx
if [[ ! -f "$NGINX_CONF" ]]; then
    echo "Setting up Nginx..."
    sudo bash -c "cat <<EOF > $NGINX_CONF
server {
    listen 80;
    server_name $DOMAIN_NAME;

    root $APP_DIR;
    index index.html;

    location / {
        try_files \$uri /index.html;
    }

    location /run {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    error_page 404 /index.html;
}
EOF"

    sudo ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/
    sudo nginx -t && sudo systemctl restart nginx
else
    echo "The Nginx configuration already exists. Let's skip it."
fi

# Setting up HTTPS
echo "I'm setting up HTTPS..."
sudo certbot --nginx -n --agree-tos --email "$EMAIL_ADR" -d "$DOMAIN_NAME"

echo "The script executed successfully. The application is available at https://$DOMAIN_NAME"
