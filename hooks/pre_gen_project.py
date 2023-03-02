import subprocess
from cookiecutter.main import cookiecutter

def main():
    # test
    cookiecutter(
        'https://github.com/yztxwd/snakemake-pipeline-general.git',
    )
    

    
    

if __name__ == '__main__':
    main()