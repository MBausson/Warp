#!/bin/bash

ACTIONS=("set" "remove" "to" "list")
SCRIPT_LOCATION=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DATA_LOCATION="$SCRIPT_LOCATION/warps.csv"

Action=$1
Name=$2

function validate_enum {
    local -n enum=$1
    local action=$2
    
    if [ -z $action ]; then
        return 1
    fi
    
    for value in "${enum[@]}"; do
        if [ $value == ${action,,} ]; then
            return 0
        fi
    done
    
    return 1
}

# Ensures the action option contains valid actions
if ! validate_enum ACTIONS "$1"; then
    echo "Error"
fi

# Ensures that the data file exists
if [ ! -f $DATA_LOCATION ]; then
    echo "Name,Location" > $DATA_LOCATION
fi

function warp_set {
    if [ -z $Name ]; then
        echo "Please enter the name of your warp"
        exit 1
    fi
    
    #   TODO: Check if warp already exists
    
    Location=$(pwd)
    
    echo "$Name,$Location" > $DATA_LOCATION
    echo "✨ Added warp '$Name' here."
}

if [ "$Action" == "set" ]; then
    warp_set
fi