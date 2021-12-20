import subprocess

def main():
    repo = "{{cookiecutter.git_submodule}}"
    repo_name = repo.strip().split("/")[-1].replace(".git", "")
    
    # merge config
    f = open('config.yaml', 'a')
    subprocess.check_call(['cat', f'{repo_name}/config.yaml'], stdout=f)
    f.close()
    
if __name__ == '__main__':
    main()
