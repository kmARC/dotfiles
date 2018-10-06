from subprocess import check_output

def get_pass(kind, account):
    return check_output("secret-tool lookup %s-pass '%s'" %(kind ,account), shell=True).splitlines()[0]
