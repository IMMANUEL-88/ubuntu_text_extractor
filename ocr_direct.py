#!/usr/bin/env python3
import subprocess
import tempfile
import os
from PIL import Image
import pytesseract

def run_command(command):
    """Runs a command and returns its output, handling errors."""
    try:
        # Using Popen to pipe the text to xclip's stdin
        process = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        return process
    except FileNotFoundError:
        return None
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

def main():
    """
    Main function to capture a screen area, OCR it, and copy to clipboard.
    """
    # 1. Use a temporary file to store the screenshot
    with tempfile.NamedTemporaryFile(suffix=".png", delete=False) as tmp_file:
        screenshot_path = tmp_file.name

    try:
        # 2. Call gnome-screenshot to let the user select an area.
        # This command pauses the script until the selection is made or canceled.
        subprocess.run(["/usr/bin/gnome-screenshot", "-a", "-f", screenshot_path], check=True)

        # 3. Check if the user actually created a screenshot (didn't press Esc)
        if not os.path.exists(screenshot_path) or os.path.getsize(screenshot_path) == 0:
            print("Screenshot canceled.")
            return

        # 4. Open the captured image and run Tesseract OCR
        image = Image.open(screenshot_path)
        extracted_text = pytesseract.image_to_string(image)

        # 5. Check if any text was actually found
        if extracted_text and extracted_text.strip():
            # 6. Copy the text to the clipboard using xclip
            copy_process = run_command(["xclip", "-selection", "clipboard"])
            if copy_process:
                copy_process.communicate(input=extracted_text)
                print("✅ Text extracted and copied to clipboard!")
            else:
                print("Error: 'xclip' is not installed. Please run 'sudo apt install xclip'.")
        else:
            print("ℹ️ No text found in the selected area.")

    except (subprocess.CalledProcessError, FileNotFoundError):
        # This handles cases where gnome-screenshot is not installed or fails
        print("Error: Could not run gnome-screenshot. Is it installed?")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    finally:
        # 7. Always clean up the temporary screenshot file
        if os.path.exists(screenshot_path):
            os.remove(screenshot_path)

if __name__ == "__main__":
    main()