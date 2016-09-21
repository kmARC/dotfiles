from subprocess import check_output

def get_pass(account):
    return check_output("secret-tool lookup username " + account, shell=True).splitlines()[0]
