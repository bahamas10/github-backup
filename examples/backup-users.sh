#!/usr/bin/env bash
#
# Backup github users that i like
#
# This script will loop through the `users` array and
# run the `github-backup.sh` script on them, and save their
# repos to `$backup_dir/$user`

backup_dir='/goliath/backups/dave/github'
users=('skyes' 'bahamas10' 'papertigers')
command='/home/dave/dev/github-backup/github-backup.sh'

for user in "${users[@]}"; do
        echo -e "\nProcessing $user\n"
        mkdir -p "$backup_dir/$user/"
        "$command" "$user" "$backup_dir/$user/"
done
