#!/usr/bin/env python3

import re, subprocess
from sys import argv, stderr, stdout, exit

args = argv[1:]
if stderr.isatty():
    diag_color_pos = None
    for i, v in enumerate(args):
        if diag_color_pos is None and v[0] == '-' and len(v) > 1:
            diag_color_pos = i
        elif v == '-fdiagnostics-color=never':
            diag_color_pos = None
            break
    if diag_color_pos is not None:
        args.insert(diag_color_pos, '-fdiagnostics-color=always')

result = subprocess.run(args, capture_output=True)

out = result.stdout.decode()
err = ''
for line in result.stderr.decode().splitlines():
    if 'implementation disabled' in line:
        err = ''
        break

    err += line + '\n'

stdout.write(out)
stderr.write(err)
exit(result.returncode)
