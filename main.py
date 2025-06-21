import os
import subprocess
import json
import shutil
import sys

SCRIPT_DIR = "scripts"
NAMES_FILE = ".names.json"

# ANSI color codes
CYAN = "\033[96m"
YELLOW = "\033[93m"
GREEN = "\033[92m"
RED = "\033[91m"
BOLD = "\033[1m"
RESET = "\033[0m"
MAGENTA = "\033[95m"
GREY = "\033[90m"

def center_text(text, filler=" "):
    try:
        width = shutil.get_terminal_size().columns
    except OSError:
        width = 80
    return text.center(width, filler)

def print_premium_header():
    os.system('cls' if os.name == 'nt' else 'clear')
    print(f"{MAGENTA}{BOLD}{center_text('★ Premium Tool Suite ★')}{RESET}")
    print(f"{CYAN}{center_text('Your Personalized Automation Gateway')}{RESET}")
    print(f"{YELLOW}{center_text('author: zerosocialcode')}{RESET}")
    print(f"{YELLOW}{center_text('=' * 40)}{RESET}\n")

def print_footer():
    print(f"\n{YELLOW}{center_text('=' * 40)}{RESET}")

def print_error(msg):
    print(f"{RED}{BOLD}Error:{RESET} {msg}")

def print_success(msg):
    print(f"{GREEN}{BOLD}✓{RESET} {msg}")

# Load display names from hidden JSON file
try:
    with open(NAMES_FILE, "r") as f:
        metadata = json.load(f)
except FileNotFoundError:
    print_error("Hidden names file not found. Please ensure '.names.json' exists.")
    sys.exit(1)

# Filter only scripts that exist in folder and in JSON
all_scripts = [
    f for f in os.listdir(SCRIPT_DIR)
    if os.path.isfile(os.path.join(SCRIPT_DIR, f)) and f in metadata
]

if not all_scripts:
    print_error("No matching scripts found in folder.")
    sys.exit(1)

script_list = []
display_list = []
for script in all_scripts:
    display_name = metadata[script].get("name")
    if display_name:
        script_list.append(script)
        display_list.append(display_name)

def main():
    print_premium_header()

    # Display numbered menu (1-based) without descriptions
    for i, name in enumerate(display_list, start=1):
        print(f"{CYAN}[{i}] {BOLD}{name}{RESET}")

    print_footer()

    # User selection
    try:
        prompt = (f"{BOLD}Select a tool by number (1-{len(display_list)}), or 0 to exit: {RESET}")
        choice = input(prompt).strip()
        if choice == "0":
            print(f"{GREY}Exited. Thank you for using the Premium Tool Suite!{RESET}")
            sys.exit(0)
        choice = int(choice)
        if not (1 <= choice <= len(script_list)):
            raise ValueError
        selected_script = script_list[choice - 1]
    except (ValueError, IndexError):
        print_error("Invalid selection. Please restart and choose a valid option.")
        sys.exit(1)

    # Execute selected script
    script_path = os.path.join(SCRIPT_DIR, selected_script)
    print(f"\n{MAGENTA}Launching: {BOLD}{metadata[selected_script]['name']}{RESET}\n")
    try:
        if selected_script.endswith(".py"):
            subprocess.run(["python3", script_path], check=True)
        elif selected_script.endswith(".sh"):
            subprocess.run(["bash", script_path], check=True)
        else:
            print_error("Unsupported script type.")
            sys.exit(1)
        print_success("Tool executed successfully.")
    except subprocess.CalledProcessError:
        print_error("Script execution failed.")
    except KeyboardInterrupt:
        print_error("Operation cancelled by user.")

    print(f"\n{GREY}{center_text('— Powered by Premium Tool Suite —')}{RESET}")

if __name__ == "__main__":
    main()
