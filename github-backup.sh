#!/usr/bin/env bash
#
# Backup all github repositories from a given user
#
# Author: Dave Eddy <dave@daveeddy.com>

api='https://api.github.com'

user=$1
dest=${2:-$PWD}
per_page=100

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

# Handle Pagination
repos=''
i=1
while true; do
	# get the repos
	_repos=$(curl -sS "$api/users/$user/repos?per_page=$per_page&page=$i")
	echo "$api/users/$user/repos?per_page=$per_page&page=$i"

	# Check for error
	if [[ -z "$_repos" || -n "$(json message <<< "$_repos")" ]]; then
		echo "Error pulling repo!" >&2
		echo "$_repos" >&2
		exit 4
	fi

	# get the field we care about
	_repos=$(json -a git_url <<< "$_repos")

	# Append the fields
	repos=$repos$_repos$'\n'

	# Check to see if we hit the end
	(( $(wc -l <<< "$_repos") < per_page)) && break

	((i++))
done

# loop and update
while read git_url; do
	[[ -z "$git_url" ]] && continue
	# Attempt to clone, this will fail if the repo exists
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
done <<< "$repos"
