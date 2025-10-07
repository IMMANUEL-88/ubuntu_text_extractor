#!/bin/bash

# This script installs the OCR tool and all its dependencies for the current user.

echo "--- OCR Tool Installer ---"

# --- Configuration ---
# Using ~/.local/ is the modern standard for user-specific applications on Linux.
INSTALL_DIR="$HOME/.local/share/ocr-tool"
BIN_DIR="$HOME/.local/bin"
# --- End Configuration ---

# Function to check if a command is available on the system
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Step 1: Check System Dependencies ---
echo "➡️  Step 1 of 5: Checking for required system packages..."
dependencies=("gnome-screenshot" "tesseract-ocr" "xclip")
missing_deps=()

for dep in "${dependencies[@]}"; do
    if ! command_exists "$dep"; then
        missing_deps+=("$dep")
    fi
done

if [ ${#missing_deps[@]} -gt 0 ]; then
    echo "⚠️  Error: The following required system packages are missing:"
    for dep in "${missing_deps[@]}"; do
        echo "      - $dep"
    done
    echo "    Please install them with the command:"
    echo "    sudo apt update && sudo apt install ${missing_deps[*]}"
    exit 1
else
    echo "✅  All system packages are present."
fi

# --- Step 2: Set Up Directories ---
echo "➡️  Step 2 of 5: Setting up installation directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
echo "✅  Directories are ready."

# --- Step 3: Copy Files ---
echo "➡️  Step 3 of 5: Copying application files..."
# This assumes ocr_direct.py is in the same directory as this installer
cp ./ocr_direct.py "$INSTALL_DIR/"
echo "✅  Files copied."

# --- Step 4: Create Python Virtual Environment ---
echo "➡️  Step 4 of 5: Setting up Python environment (this might take a moment)..."
python3 -m venv "$INSTALL_DIR/ocr_env"
source "$INSTALL_DIR/ocr_env/bin/activate"
pip install --quiet --disable-pip-version-check pytesseract pillow
deactivate
echo "✅  Python environment is set up."

# --- Step 5: Create and Install the Launcher ---
echo "➡️  Step 5 of 5: Creating the command launcher..."
LAUNCHER_PATH="$BIN_DIR/ocr-tool"
# This creates the launcher script on-the-fly
cat > "$LAUNCHER_PATH" << EOL
#!/bin/bash
VENV_PYTHON="$INSTALL_DIR/ocr_env/bin/python"
MAIN_SCRIPT="$INSTALL_DIR/ocr_direct.py"
"\$VENV_PYTHON" "\$MAIN_SCRIPT"
EOL

# Make the launcher executable
chmod +x "$LAUNCHER_PATH"
echo "✅  Launcher created at $LAUNCHER_PATH"

# --- Final Instructions ---
echo
echo "🎉 --- Installation Complete! --- 🎉"
echo
echo "To run the tool, you must ensure '$BIN_DIR' is in your system's PATH."
echo "If this is your first time using this directory, add the following line to your ~/.bashrc file:"
echo
echo 'export PATH="$HOME/.local/bin:$PATH"'
echo
echo "After adding it, restart your terminal or run 'source ~/.bashrc'."
echo "You can then run the tool from anywhere by simply typing 'ocr-tool'."