#!/bin/bash

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

# Skapa användarna
for username in "$@"; do
    useradd -m "$username" 2>/dev/null
done

# Skapa mappar i projektets rotmapp
mkdir -p Documents Downloads Work

# Sätt rättigheter
chmod 700 Documents Downloads Work

# Skapa welcome.txt
echo "Välkommen $1" > welcome.txt

# Lista alla andra användare
awk -F: -v user="$1" '$1 != user { print $1 }' /etc/passwd >> welcome.txt

# Sätt rättigheter
chmod 600 welcome.txt