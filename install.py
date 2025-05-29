# Input:
#   -(-sh)ell - What type of shell is used (bash, powershell)
#   -(-loc)ation - Where the files are stored at

import argparse
import os
import sys
import shutil
import subprocess

DIRECTORY = os.path.dirname(__file__)

abs_path = lambda rel_path : os.path.abspath(os.path.expanduser(rel_path))

parser = argparse.ArgumentParser(prog="WarpInstaller", description="Installer for the Warp script")
parser.add_argument("-sh", "--shell",
                    required=True,
                    choices=["bash", "zsh", "powershell"],
                    help="Type of shell used (bash, zsh, powershell)")
parser.add_argument("-loc", "--location", default="~", help="Location of the warp executable and csv file.")
args = parser.parse_args()
location = abs_path(args.location)
shell = args.shell

#   Saves the user's PATH to a local file
def path_backup():
    process = subprocess.run(["powershell", '[Environment]::GetEnvironmentVariable("PATH", "User")'], capture_output=True, text=True)

    if process.returncode != 0:
        raise RuntimeError("Could not backup the user PATH variable.")
    
    with open("path.backup", "w") as backup_file:
        backup_file.write(process.stdout)

#   Bash installation
#   1. Copy `warp.sh` to input's location
#   2. Update user's `.bashrc` to include a 'warp' function
def bash_install(location: str, shell_file: str):
    target_dir = abs_path(location)
    script_dir = os.path.dirname(abs_path(__file__))
    warp_src = os.path.join(script_dir, "warp.sh")
    warp_dst = os.path.join(target_dir, "warp.sh")

    if not os.path.exists(warp_src):
        print(f"warp.sh not found in {script_dir}")
        sys.exit(1)

    os.makedirs(target_dir, exist_ok=True)
    shutil.copy(warp_src, warp_dst)

    print(f"Copied `warp.sh` to {warp_dst}")

    bashrc_path = abs_path(f"~/{shell_file}")
    warp_function_code = f"""
# Added by warp's installer ({script_dir})
warp() {{
  source "{warp_dst}"
}}
"""

    #  Check if code is already present in .bashrc.
    with open(bashrc_path, "r") as bashrc_file:
        if warp_function_code in bashrc_file.read():
            print(f"Warp function is already present in {bashrc_path}")
            return

    with open(bashrc_path, "a") as bashrc_file:
        bashrc_file.write(warp_function_code)
        print(f"Warp function added to {bashrc_path}")

#   Powerhsell installation
#   1. Copy `warp.ps1` to input's location
#   2. Add script to user's PATH environment variable
def powershell_install(location: str):
    path_backup()

    target_dir = abs_path(location)
    script_dir = os.path.dirname(abs_path(__file__))
    warp_src = os.path.join(script_dir, "warp.ps1")
    warp_dst = os.path.join(target_dir, "warp.ps1")

    if not os.path.exists(warp_src):
        print(f"warp.ps1 not found in {script_dir}")
        sys.exit(1)

    os.makedirs(target_dir, exist_ok=True)
    shutil.copy(warp_src, warp_dst)

    print(f"Copied `warp.ps1` to {warp_dst}")

    command = f'[Environment]::SetEnvironmentVariable("PATH", [Environment]::GetEnvironmentVariable("PATH", "User") + ";{target_dir};", "User")'
    
    try:
        subprocess.run(["powershell", "-Command", command], check=True)
        print(f"Added {target_dir} to PATH. Restart your terminal to take effect.")
    except subprocess.CalledProcessError as e:
        print(f"Failed to add {target_dir} to PATH: {e}")
        sys.exit(1)

match shell:
    case "bash":
        bash_install(location, shell_file=".bashrc")
    case "zsh":
        bash_install(location, shell_file=".zshrc")
    case "powershell":
        powershell_install(location)
