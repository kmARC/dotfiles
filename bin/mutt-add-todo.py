#!/usr/bin/env python

import datetime
import email
import os
import readline
import subprocess
import sys

from dateutil.parser import parse

mail = sys.stdin.readlines()
os.close(sys.stdin.fileno())

sys.stdin = open(os.open("/dev/tty", os.O_RDONLY))

msg = email.message_from_string("".join(mail))
date = (parse(msg["Date"]) + datetime.timedelta(days=2)).strftime(r"%Y-%m-%d")
subject = msg["Subject"].replace("\n", "")

contexts = {
    "mark.korondi@k-lab.ch": "Klab",
    "mark@korondi.ch": "KCC",
}
readline.set_startup_hook(lambda: readline.insert_text(f"{subject} ({msg['From']})"))
text = input("Text? ")
readline.set_startup_hook(lambda: readline.insert_text(f"{date}"))
date = input("Due date? ")
readline.set_startup_hook(lambda: readline.insert_text(contexts[os.environ["from"]]))
context = input("Context? ")

subprocess.Popen(["todo.sh", "add", f"@{context} {text} due:{date}"])
