# script for installation configs in linux desktop
# under devlopment 

# Define variables
REPO_URL="https://raw.githubusercontent.com/Chintanpatel24/fastfetch-collection/main/configs"
CONFIG_DIR="$HOME/.config/fastfetch"
TARGET_FILE="$CONFIG_DIR/config.jsonc"
TEMP_DIR=$(mktemp -d)

# Function to clean up temporary files on exit
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Check if curl or wget is available
if command -v curl &> /dev/null; then
    DOWNLOADER="curl -sL"
elif command -v wget &> /dev/null; then
    DOWNLOADER="wget -qO-"
else
    echo "Error: Neither curl nor wget is installed. Please install one of them."
    exit 1
fi

# Display menu
echo "Select a Fastfetch configuration to install (1-7):"
echo "1. 1.jsonc"
echo "2. 2.jsonc"
echo "3. 3.jsonc"
echo "4. 4.jsonc"
echo "5. 5.jsonc"
echo "6. 6.jsonc"
echo "7. 7.jsonc"
echo -n "Enter your choice [1-7]: "
read -r choice

# Validate input
if ! [[ "$choice" =~ ^[1-7]$ ]]; then
    echo "Error: Invalid selection. Please run the script again and choose a number between 1 and 7."
    exit 1
fi

# Construct filename and URL
FILE_NAME="${choice}.jsonc"
DOWNLOAD_URL="${REPO_URL}/${FILE_NAME}"

echo "Downloading ${FILE_NAME}..."

# Download the file
if ! $DOWNLOADER "$DOWNLOAD_URL" > "$TEMP_DIR/$FILE_NAME"; then
    echo "Error: Failed to download the configuration file."
    echo "Please check your internet connection or the repository URL."
    exit 1
fi

# Check if the downloaded file is empty or invalid
if [ ! -s "$TEMP_DIR/$FILE_NAME" ]; then
    echo "Error: The downloaded file is empty. The file '${FILE_NAME}' may not exist in the repository."
    exit 1
fi

# Create the config directory if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
    echo "Created configuration directory: $CONFIG_DIR"
fi

# Backup existing config if it exists
if [ -f "$TARGET_FILE" ]; then
    BACKUP_FILE="${TARGET_FILE}.bak.$(date +%F_%T)"
    mv "$TARGET_FILE" "$BACKUP_FILE"
    echo "Existing config backed up to: $BACKUP_FILE"
fi

# Move the new config to the target location
mv "$TEMP_DIR/$FILE_NAME" "$TARGET_FILE"

echo "Successfully installed ${FILE_NAME} to ${TARGET_FILE}"
echo "Run 'fastfetch' to see your new configuration."   
