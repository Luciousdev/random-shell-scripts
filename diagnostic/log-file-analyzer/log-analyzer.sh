#!/bin/bash

# Set some colors
CNT="[\033[1;36mNOTE\033[0m]"
COK="[\033[1;32mOK\033[0m]"
CER="[\033[1;31mERROR\033[0m]"
CAT="[\033[1;37mATTENTION\033[0m]"
CWR="[\033[1;35mWARNING\033[0m]"
CAC="[\033[1;33mACTION\033[0m]"
CIN="[\033[1;34mINPUT\033[0m]"
CDE="[\033[1;37mDEBUG\033[0m]"
CPR="[\033[1;37mPROGRESS\033[0m]"

current_time=$(date +"%Y-%m-%d %H:%M:%S")

log() {
    local log_file="$current_time-log_analysis.log"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] - $1" >> "$log_file"
}

analyze_logs() {
    local log_dir="$1"
    local search_patterns=("$@")

    # Iterate over each log file in the directory
    for logfile in "$log_dir"/*; do
        if [[ -f "$logfile" ]]; then
            log "Analyzing $logfile..."

            # Iterate over each search pattern
            for pattern in "${search_patterns[@]}"; do
                matching_lines=$(grep -i "$pattern" "$logfile")

                # Check if any matches are found
                if [[ -n "$matching_lines" ]]; then

                    # For a couple patterns create colors
                    if [[ "$pattern" == "ERROR" ]]; then
                        echo -e "$CER - Found '$pattern' in $logfile:"
                        echo "$matching_lines"
                        log "Found '$pattern' in $logfile"
                    elif [[ "$pattern" == "WARNING" ]]; then
                        echo -e "$CWR - Found '$pattern' in $logfile:"
                        echo "$matching_lines"
                        log "Found '$pattern' in $logfile"
                    else 
                        echo -e "$CNT - Found '$pattern' in $logfile:"
                        echo "$matching_lines"
                        log "Found '$pattern' in $logfile"
                    fi
                else
                    echo -e "$COK - No '$pattern' found in $logfile"
                    log "No '$pattern' found in $logfile"
                fi
            done

            echo "------------------------"
        elif [[ -d "$logfile" ]]; then
            analyze_logs "$logfile" "${search_patterns[@]}"
        fi
    done
}

# Main script execution
log "Program started."

log_directory="/var/log"
search_patterns=("ERROR" "WARNING")

# Check if command-line arguments are provided and use them if available
if [[ -n "$1" ]]; then
    log_directory="$1"
fi

if [[ -n "$2" ]]; then
    search_patterns=("$@")
fi

# Check if log directory exists
if [[ ! -d "$log_directory" ]]; then
    echo -e "$CER - Log directory '$log_directory' not found."
    log "Log directory '$log_directory' not found. Exiting."
    exit 1
fi

# Execute the log analyzer
analyze_logs "$log_directory" "${search_patterns[@]}"

# Exit the script
echo -e "$CPR - Program ran successfully. Exiting with code 0"
log "Program completed."
exit 0
