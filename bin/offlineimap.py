#!/usr/bin/env python

from subprocess import check_output
import sys

def get_pass(kind, account):
    return check_output("secret-tool lookup %s-pass '%s'" %(kind ,account), shell=True).splitlines()[0]

if __name__ == '__main__':
    print(get_pass(sys.argv[1], sys.argv[2]))
