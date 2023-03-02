import subprocess

def main():
    # test
    subprocess.check_call(['git', 'init'])
    subprocess.check_call(['git', 'submodule', 'add', 'https://github.com/yztxwd/snakemake-pipeline-general'])
    subprocess.check_call(['cat', 'snakemake-pipeline-general/config.yaml'])

if __name__ == '__main__':
    main()