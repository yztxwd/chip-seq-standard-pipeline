import shutil
import subprocess

def main():
    # concatenate config file
    with open('snakemake-pipeline-general/config.yaml') as fi, open('config.yaml', 'a') as fo:
        shutil.copyfileobj(fi, fo)
    
    # init the git
    subprocess.check_call(['git', 'init'])
    subprocess.check_call(['git', 'add', '.'])
    subprocess.check_call(['git', 'commit', '-m', '"first commit"'])

if __name__ == '__main__':
    main()
