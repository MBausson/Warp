#!/bin/bash

DATA_FILE_PATH="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/warps.csv"

# Ensure the data file exists
if [[ ! -f "$DATA_FILE_PATH" ]]; then
    echo "Name,Location" > "$DATA_FILE_PATH"
fi

warp_set() {
    if [[ -z "$NAME" ]]; then
        printf "Please enter the name of your warp.\n"
        return 1
    fi
    
    if grep -q "^$NAME," "$DATA_FILE_PATH"; then
        printf "Warp '$NAME' already exists.\n"
        return 1
    fi
    
    echo "$NAME,$PWD" >> "$DATA_FILE_PATH"
    printf "✨ Added warp '$NAME' here.\n"
}

warp_remove() {
    if [[ -z "$NAME" ]]; then
        # Remove local warp
        awk -F, -v loc="$PWD" '$2 != loc' "$DATA_FILE_PATH" > "$DATA_FILE_PATH.tmp" && mv "$DATA_FILE_PATH.tmp" "$DATA_FILE_PATH"
    else
        # Remove warp by name
        awk -F, -v name="$NAME" '$1 != name' "$DATA_FILE_PATH" > "$DATA_FILE_PATH.tmp" && mv "$DATA_FILE_PATH.tmp" "$DATA_FILE_PATH"
    fi
    
    printf "✅ Removed warp\n"
}

warp_to() {
    if [[ -z "$NAME" ]]; then
        printf "Please enter the name of your warp.\n"
        return 1
    fi
    
    LOCATION=$(awk -F, -v name="$NAME" '$1 == name {print $2}' "$DATA_FILE_PATH")
    
    if [[ -z "$LOCATION" ]]; then
        printf "Could not find the warp '$NAME'\n"
        return 1
    fi
    
    if [[ ! -d "$LOCATION" ]]; then
        printf "❌ The destination associated with this warp is unreachable.\n"
        read -p "❔ Would you like to remove this warp (yes/no)? " RESPONSE
        if [[ "$RESPONSE" =~ ^(y|yes|1)$ ]]; then
            warp_remove "$NAME"
        fi
        return 1
    fi
    
    cd "$LOCATION" || return
    printf "✨ Warped to $NAME.\n"
}

warp_list() {
    printf "📖 Registered warps\n\n"
    awk -F, 'NR>1 {print "\""$1"\" ➡️ "$2}' "$DATA_FILE_PATH"
    printf "\nTotal: $(($(wc -l < "$DATA_FILE_PATH") - 1)) warps.\n"
}

if [[ -z "$1" ]]; then
    printf "Usage: $0 {set|remove|to|list} [name]\n"
    return 2
fi

ACTION="$1"
NAME="$2"

case "$ACTION" in
    "set") warp_set;;
    "remove") warp_remove;;
    "to") warp_to;;
    "list") warp_list;;
    *) printf "Invalid action '$ACTION'.\n"; return 1;;
esac

