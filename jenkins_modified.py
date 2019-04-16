import sys
import re
import os

hosts_mod_str = str(sys.argv[1])
groups_mod_str = str(sys.argv[2])

all_mod = hosts_mod_str + ',' + groups_mod_str

rm_chars = re.sub(r'\[|\]|\"|host_vars/|group_vars/|.yml', '', all_mod)
hosts_modified = re.sub(r',', ' ', rm_chars)

print hosts_modified
