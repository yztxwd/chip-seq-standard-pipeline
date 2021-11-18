import subprocess

def main():
    repo = "{{cookiecutter.git_submodule}}".strip().split("/")
    repo_name = repo.split("/")[-1].replace(".git", "")

    print(repo)

    subprocess.check_call(['git', 'init'])
    subprocess.check_call(['git', 'checkout', '-b', 'main'])
    subprocess.check_call(['rm', '-rf', f'{repo_name}'])
    subprocess.check_call(['git', 'submodule', 'add', f'repo'])

if __name__ == '__main__':
    main()
