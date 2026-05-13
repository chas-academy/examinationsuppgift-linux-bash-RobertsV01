#!/bin/bash

# Script som skapar användare, mappar och en välkomstfil
# Endast root får köra scriptet

if [ "$EUID" -ne 0 ]; then
    echo "Fel: Detta script måste köras som root."
    exit 1
fi

if [ "$#" -eq 0 ]; then
    echo "Användning: $0 användare1 användare2"
    exit 1
fi

for username in "$@"; do

    if ! id "$username" >/dev/null 2>&1; then
        useradd -m "$username"
    fi

    home_dir=$(eval echo "~$username")

    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    chown -R "$username:$username" "$home_dir"

    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    welcome_file="$home_dir/welcome.txt"
    echo "Välkommen $username" > "$welcome_file"

    awk -F: -v user="$username" '$1 != user { print $1 }' /etc/passwd >> "$welcome_file"

    chown "$username:$username" "$welcome_file"
    chmod 600 "$welcome_file"

done