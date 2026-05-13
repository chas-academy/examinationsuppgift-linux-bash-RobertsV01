#!/bin/bash

# Script som skapar användare, mappar och en välkomstfil
# Endast root får köra scriptet

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: Detta script måste köras som root."
    exit 1
fi

# Kontrollera att minst ett användarnamn skickats in
if [ "$#" -eq 0 ]; then
    echo "Användning: $0 användare1 användare2"
    exit 1
fi

# Loopa igenom alla användarnamn
for username in "$@"; do

    # Skapa användaren om den inte redan finns
    if ! id "$username" &>/dev/null; then
        useradd -m "$username"
    fi

    # Hemkatalog
    home_dir="/home/$username"

    # Skapa mappar
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Sätt ägare
    chown -R "$username:$username" "$home_dir"

    # Sätt rättigheter
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Skapa welcome.txt
    welcome_file="$home_dir/welcome.txt"
    echo "Välkommen $username" > "$welcome_file"

    # Lista alla andra användare
    awk -F: -v user="$username" '$1 != user { print $1 }' /etc/passwd >> "$welcome_file"

    # Sätt rättigheter för welcome.txt
    chown "$username:$username" "$welcome_file"
    chmod 600 "$welcome_file"

done
