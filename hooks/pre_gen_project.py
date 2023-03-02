import subprocess
from cookiecutter.main import cookiecutter

def main():
    # test
    cookiecutter(
        'https://github.com/yztxwd/snakemake-pipeline-general.git',
        checkout='improve-integrateGeneralPipelineConfig',
        extra_context={'directory_name': 'snakemake-pipeline-general'}
    )
    

    
    

if __name__ == '__main__':
    main()