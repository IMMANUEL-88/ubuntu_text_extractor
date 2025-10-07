# OCR Screenshot to Clipboard

A Python script that allows you to select a screen area, extract text using OCR, and automatically copy it to your clipboard.

## Features

- 📸 Interactive area selection using `gnome-screenshot`
- 🔤 Text extraction using Tesseract OCR
- 📋 Automatic clipboard copying
- 🗑️ Automatic cleanup of temporary files
- ✅ User-friendly feedback messages

## Requirements

- Ubuntu or other Debian-based Linux distributions
- GNOME desktop environment (for `gnome-screenshot`)

## Installation

Run the automated installation script:

```bash
git clone https://github.com/IMMANUEL-88/ubuntu_text_extractor
cd ubuntu_text_extractor
chmod +x install.sh
./install.sh
