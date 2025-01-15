import os
import sys
import shlex
import subprocess

def run_command(command):
    """Run a shell command and return its output."""
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)
    return result.stdout.strip(), result.returncode

def wsl_command(command, path):
    """Run a command in wsl in the specified path."""
    full_command = ["wsl", "cd", path, ";"] + shlex.split(command)
    result=subprocess.run(full_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)
    # print(result)
    return result.stdout.strip(), result.returncode

def get_git_status(repo_path, return_type):
    # Change the working directory to the repository path
    os.chdir(repo_path)

    # Initialize status variables
    local_changes = 0
    unpushed_commits = 0
    unpulled_commits = 0

    if return_type == "local":
        # Check for local changes (modified files)
        output, _ = run_command("git status --short | find /c /v \"\"")
        local_changes = int(output) if output.isdigit() else 0
        return local_changes
    elif return_type == "unpushed":
        # Check for unpushed commits
        output, _ = run_command("git log origin/master..HEAD --oneline | find /c /v \"\"")
        unpushed_commits = int(output) if output.isdigit() else 0
        return unpushed_commits

    elif return_type == "unpulled":
        # Check for unpulled commits
        run_command("git fetch >nul 2>&1")
        output, _ = run_command("git log HEAD..origin/master --oneline | find /c /v \"\"")
        unpulled_commits = int(output) if output.isdigit() else 0
        return unpulled_commits

def wsl_git_status(repo_path, return_type):
    # Initialize status variables
    local_changes = 0
    unpushed_commits = 0
    unpulled_commits = 0

    if return_type == "local":
        # Check for local changes (modified files)
        output, _ = wsl_command("git status --short ^| wc -l", unix_path)
        local_changes = int(output) if output.isdigit() else 0
        return local_changes
    elif return_type == "unpushed":
        # Check for unpushed commits
        output, _ = wsl_command("git log origin/master..HEAD --oneline ^| wc -l", unix_path)
        unpushed_commits = int(output) if output.isdigit() else 0
        return unpushed_commits

    elif return_type == "unpulled":
        # Check for unpulled commits
        wsl_command("git fetch >nul 2>&1", unix_path)
        output, _ = wsl_command("git log HEAD..origin/master --oneline ^| wc -l", unix_path)
        unpulled_commits = int(output) if output.isdigit() else 0
        return unpulled_commits
    

# Example usage: Provide the path to the repository as an argument
if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python check_git_status.py <path_to_git_repo> <return_type>")
        sys.exit(1)

    repo_path=sys.argv[1]
    return_type=sys.argv[2]
    if return_type not in ["local", "unpulled", "unpushed"]:
        print("Usage: python check_git_status.py <path_to_git_repo> <return_type>")
        print("       - <return_type> must be 'local', 'unpulled', or 'unpushed'")
        print(f"       - <return_type> is {return_type}")

    prefix = r'\\wsl.localhost\Ubuntu'
    if not repo_path.startswith(prefix):
        os.path.exists(repo_path)
        if os.path.exists(repo_path):
            print(get_git_status(repo_path, return_type))
        else:
            # Invalid path. Seems to activate occassionally.
            # Can't figure out why, so displays a placeholder for now.
            print("?W")
    else:
        path_wo_prefix = repo_path[len(prefix):] # Removes prefix, and trailing \
        unix_path = path_wo_prefix.replace("\\","/")
        result=subprocess.run(["wsl", "test", "-d", unix_path], capture_output=True)
        if result.returncode == 0: # If directory exists in WSL
            print(wsl_git_status(unix_path, return_type))
        else:
            # Invalid path. Seems to activate occassionally.
            # Can't figure out why, so displays a placeholder for now.
            print("?L")
            
