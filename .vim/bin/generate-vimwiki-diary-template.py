#!/usr/bin/python3
# http://frostyx.cz/posts/vimwiki-diary-template
import sys
import datetime

template = """# {date}"""

if len(sys.argv) < 2:
    # Not given a filename, let's just use today's date.
    date = datetime.date.today()
else:
    arg = sys.argv[1]
    filename = arg.split("/")[-1]
    date = filename.rsplit(".", 1)[0]

print(template.format(date=date))
