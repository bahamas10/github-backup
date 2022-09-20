github-backup
=============

Backup (clone and update) all public repositories of a GitHub user

**Now supports pagination!**

Usage
-----

Run the script with a user as the first argument, and optionally
the destination directory as the second argument (defaults to `$PWD`).

    ./github-backup <user> [dest dir]

Example
-------

    mkdir backupdir
    ./github-backup bahamas10 backupdir

Dependencies
------------

- `jq`

License
-------

BSD 3 Clause License.  See LICENSE for more details.
