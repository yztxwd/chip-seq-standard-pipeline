import subprocess

def main():
    # test
    subprocess.check_call(['git', 'clone', 'https://github.com/yztxwd/snakemake-pipeline-general.git'])
    subprocess.check_call(['cat', 'config.yaml'])
    subprocess.check_call(['cat', 'snakemake-pipeline-general'])

if __name__ == '__main__':
    main()