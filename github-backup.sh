#!/usr/bin/env bash
#
# Backup all github repositories from a given user
#
# Author: Dave Eddy <dave@daveeddy.com>

api='https://api.github.com'

user=$1
dest=${2:-$PWD}

usage() {
	cat <<-EOF
	${0##*/} <user> [dest dir]

	Clone and update all repositories of a given user from GitHub
	EOF
}

# Check for user
if [[ -z "$user" ]]; then
	usage >&2
	exit 1
fi

# Check for jsontool
if ! json --version &>/dev/null; then
	echo 'Dependency "json" not found. Install with `npm install -g jsontool`'
	exit 2
fi

# chdir
cd "$dest" || exit 3

# get the repos
repos=$(curl -s "$api/users/$user/repos")

# Check for error
if [[ -z "$repos" || -n "$(json message <<< "$repos")" ]]; then
	echo "Error pulling repo!" >&2
	echo "$repos" >&2
	exit 4
fi

# loop and update
while read git_url; do
	# Attempt to clone, this might fail if the repo exists
	git clone "$git_url"
	# basename and extension removal for directory name
	tmp=${git_url##*/}; dir=${tmp%.git}
	# Try to cd into the dir
	if cd "$dir"; then
		# Reset any changes and pull everything
		git reset --hard HEAD &&
		git pull --all
		# Back out of the dir
		cd ..
	fi
done < <(json -a git_url <<< "$repos")
