#!/usr/bin/env bash

shopt -s nullglob globstar

typeit=1
if [[ $1 == "--no-type" ]]; then
	typeit=0
	shift
fi

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | bemenu "$@")

[[ -n $password ]] || exit

if [[ $typeit -eq 0 ]]; then
	pass show -c "$password" 2>/dev/null
else
	wtype "$(pass show "$password" | head -n 1)"
	notify-send "Password typing done" -t 650
fi
