import subprocess

def main():
    subprocess.check_call(['git', 'init'])
    subprocess.check_call(['git', 'add', '.'])
    subprocess.check_call(['git', 'commit', '-m', '"first commit"'])

if __name__ == '__main__':
    main()
