import subprocess

def main():
    # test
    subprocess.check_call(['git', 'submodule', 'add', 'https://github.com/yztxwd/snakemake-pipeline-general.git'])
    subprocess.check_call(['cat', 'snakemake-pipeline-general'])

if __name__ == '__main__':
    main()