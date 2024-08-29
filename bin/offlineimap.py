#!/usr/bin/env python

from subprocess import check_output
import sys
import platform


def get_entry(typ, kind, account):
    if platform.uname().system == "Darwin":
        return check_output(f"security find-generic-password -w -s '{kind}-{typ}' -a '{account}'", shell=True).splitlines()[0]
    else:
        return check_output(f"secret-tool lookup {kind}-{typ} '{account}'", shell=True).splitlines()[0]

def get_pass(kind, account):
    return get_entry('pass', kind, account)

def get_user(kind, account):
    return get_entry('username', kind, account)

if __name__ == '__main__':
    print(get_pass(sys.argv[1], sys.argv[2]))
