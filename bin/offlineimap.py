#!/usr/bin/env python

from subprocess import check_output
import sys
import platform


def get_pass(kind, account):
    if platform.uname().system == "Darwin":
        return check_output(f"security find-generic-password -w -s '{kind}-pass' -a '{account}'", shell=True).splitlines()[0]
    else:
        return check_output(f"secret-tool lookup {kind}-pass '{account}'", shell=True).splitlines()[0]

if __name__ == '__main__':
    print(get_pass(sys.argv[1], sys.argv[2]))
