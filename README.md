github-backup
=============

Backup (clone and update) all public repositories of a GitHub user

Usage
-----

Run the script with a user as the first argument, and optionally
the destination directory as the second argument (defaults to `$PWD`).

    ./github-backup.sh <user> [dest dir]

Example
-------

    mkdir backupdir
    ./github-backup.sh bahamas10 backupdir

Dependencies
------------

The GitHub api is easily consumed as json, so [jsontool](https://github.com/trentm/json)
is needed for this script to work.  The script will prompt you with installation
instructions if jsontool is not found.

License
-------

BSD 3 Clause License.  See LICENSE for more details.
