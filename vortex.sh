#!/bin/bash

export VORTEX_ROOT="/tmp/.vortex_$(id -u)"
export VORTEX_SOCK="$VORTEX_ROOT/ipc.sock"
mkdir -p "$VORTEX_ROOT"

core_logic() {
    exec 3> "$VORTEX_SOCK"
    while true; do
        read -r _ _ _ _ _ _ _ _ _ < /proc/loadavg
        read -r _ tot _ free _ buff _ cach _ _ < <(grep -E 'MemTotal|MemFree|Buffers|Cached' /proc/meminfo | xargs)
        
        declare -A dev_stats
        while read -r line; do
            [[ "$line" =~ (.*):[[:space:]]+([0-9]+).*[[:space:]]+([0-9]+) ]] && \
            dev_stats["${BASH_REMATCH[1]// /}"]="${BASH_REMATCH[2]}:${BASH_REMATCH[3]}"
        done < <(tail -n +3 /proc/net/dev)

        payload=$(cat <<EOF
{
  "cpu": "$(awk '{print $1" "$2" "$3}' /proc/loadavg)",
  "mem": "$(( (tot - free - buff - cach) / 1024 ))MB/$(( tot / 1024 ))MB",
  "net": "$(for k in "${!dev_stats[@]}"; do echo -n "$k=${dev_stats[$k]} "; done)"
}
EOF
)
        echo "$payload" >&3
        sleep 0.2
    done
}

ui_engine() {
    tput civis
    tput smcup
    
    while true; do
        if read -r data < "$VORTEX_SOCK"; then
            tput cup 0 0
            printf "\e[1;35m[ VORTEX ENGINE ]\e[0m - PID: %s\n" "$$"
            echo "--------------------------------------------------"
            
            cpu_val=$(echo "$data" | grep -oP '(?<="cpu": ")[^"]*')
            mem_val=$(echo "$data" | grep -oP '(?<="mem": ")[^"]*')
            net_val=$(echo "$data" | grep -oP '(?<="net": ")[^"]*')

            printf "\e[1;32mPROCESSOR\e[0m : %s\n" "$cpu_val"
            printf "\e[1;34mMEMORY   \e[0m : %s\n" "$mem_val"
            
            echo -e "\n\e[1;33mNETWORK TOPOLOGY\e[0m"
            printf "%-10s %-12s %-12s\n" "INTERFACE" "RX_BYTES" "TX_BYTES"
            for entry in $net_val; do
                iface="${entry%=*}"
                stats="${entry#*=}"
                printf "%-10s %-12s %-12s\n" "$iface" "${stats%:*}" "${stats#*:}"
            done

            printf "\n\e[1;31mINTERRUPT VECTORS\e[0m\n"
            head -n 5 /proc/interrupts | awk '{print $1, $2, $3, $NF}' | column -t
        fi
    done
}

cleanup() {
    tput rmcup
    tput cnorm
    rm -rf "$VORTEX_ROOT"
    kill 0
}

trap cleanup EXIT

[[ -p "$VORTEX_SOCK" ]] || mkfifo "$VORTEX_SOCK"

core_logic &
ui_engine