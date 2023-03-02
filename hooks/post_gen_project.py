import subprocess

def main():
    # concatenate config file
    subprocess.check_call(['cat', 'snakemake-pipeline-general/config.yaml', '>>', 'config.yaml'], shell=True)
    
    # init the git
    subprocess.check_call(['git', 'init'])
    subprocess.check_call(['git', 'add', '.'])
    subprocess.check_call(['git', 'commit', '-m', '"first commit"'])

if __name__ == '__main__':
    main()
