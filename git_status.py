import os
import configparser
import subprocess

# Paths
config_file = "./repos.ini"  # Path to the repo config file
output_file = "./GitStatus.txt"  # Path to the Rainmeter-readable output file

# Parse INI file
def parse_ini_file(file_path):
    config = configparser.ConfigParser()
    config.read(file_path)
    return config

# Run Git Command
def run_git_command(path, is_wsl, command):
    try:
        if is_wsl:
            full_command = f"wsl git -C {path} {command}"
        else:
            full_command = f"git -C {path} {command}"
        
        result = subprocess.check_output(full_command, shell=True, stderr=subprocess.DEVNULL, text=True)
        return result.strip()
    except subprocess.CalledProcessError:
        return ""

# Write Output to File
def write_output(file_path, data):
    with open(file_path, "w") as f:
        f.write(data)
 
# Main Logic
if __name__ == "__main__":
    if not os.path.exists(config_file):
        print(f"Error: Config file '{config_file}' not found.")
        exit(1)

    config = parse_ini_file(config_file)
    output = "Git Repository Status:\n\n"

    for repo in config.sections():
        path = config[repo].get("Path")
        remote = config[repo].get("Remote", "")
        is_wsl = config[repo].get("WSL", "False").lower() == "true"

        if is_wsl or os.path.exists(path):
            local_changes = run_git_command(path, is_wsl, "status --porcelain")
            unpushed_commits = run_git_command(path, is_wsl, "log @{u}..")
            unpulled_commits = run_git_command(path, is_wsl, "log ..@{u}")

            output += f"{repo}:\n"
            output += f"  Local Changes: {len(local_changes.splitlines())}\n" if local_changes else "  Local Changes: 0\n"
            output += f"  Unpushed Commits: {len(unpushed_commits.splitlines())}\n" if unpushed_commits else "  Unpushed Commits: 0\n"
            output += f"  Unpulled Commits: {len(unpulled_commits.splitlines())}\n" if unpulled_commits else "  Unpulled Commits: 0\n\n"
        else:
            output += f"{repo}: Invalid Path\n\n"

    write_output(output_file, output)
    print(f"Git status written to {output_file}")
