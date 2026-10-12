#!/bin/bash
# ~/.config/waybar/scripts/gpu.sh
# Detects AMD (via /sys), Intel (via /sys), or NVIDIA (via nvidia-smi)
# Outputs JSON for waybar custom module

get_amd() {
    local gpu_path
    gpu_path=$(ls /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | head -1)
    if [[ -f "$gpu_path" ]]; then
        local usage
        usage=$(cat "$gpu_path")
        # Try to get VRAM (not always available)
        local vram_used vram_total vram_str=""
        local vram_used_path
        vram_used_path=$(dirname "$gpu_path")/mem_info_vram_used
        local vram_total_path
        vram_total_path=$(dirname "$gpu_path")/mem_info_vram_total
        if [[ -f "$vram_used_path" && -f "$vram_total_path" ]]; then
            vram_used=$(( $(cat "$vram_used_path") / 1024 / 1024 ))
            vram_total=$(( $(cat "$vram_total_path") / 1024 / 1024 ))
            vram_str=" | VRAM ${vram_used}/${vram_total}M"
        fi
        echo "{\"text\": \"󰢮 ${usage}%\", \"tooltip\": \"AMD GPU: ${usage}%${vram_str}\", \"class\": \"gpu-amd\"}"
        return 0
    fi
    return 1
}

get_nvidia() {
    if command -v nvidia-smi &>/dev/null; then
        local data
        data=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | head -1)
        if [[ -n "$data" ]]; then
            local usage mem_used mem_total
            usage=$(echo "$data" | awk -F', ' '{print $1}' | tr -d ' ')
            mem_used=$(echo "$data" | awk -F', ' '{print $2}' | tr -d ' ')
            mem_total=$(echo "$data" | awk -F', ' '{print $3}' | tr -d ' ')
            echo "{\"text\": \"󰢮 ${usage}%\", \"tooltip\": \"NVIDIA GPU: ${usage}% | VRAM ${mem_used}/${mem_total}MiB\", \"class\": \"gpu-nvidia\"}"
            return 0
        fi
    fi
    return 1
}

get_intel() {
    # Intel integrated: intel_gpu_top (needs root or cap) — fallback to /sys
    local gt_path
    gt_path=$(ls /sys/class/drm/card*/gt_cur_freq_mhz 2>/dev/null | head -1)
    if [[ -f "$gt_path" ]]; then
        local freq gt_max_path max_freq pct
        freq=$(cat "$gt_path")
        gt_max_path=$(dirname "$gt_path")/gt_max_freq_mhz
        max_freq=$(cat "$gt_max_path" 2>/dev/null || echo 1)
        pct=$(( freq * 100 / max_freq ))
        echo "{\"text\": \"󰢮 ${pct}%\", \"tooltip\": \"Intel GPU: ${freq}/${max_freq}MHz (~${pct}% freq)\", \"class\": \"gpu-intel\"}"
        return 0
    fi
    return 1
}

# Detection order: NVIDIA → AMD → Intel → fallback
if get_nvidia; then exit 0; fi
if get_amd;    then exit 0; fi
if get_intel;  then exit 0; fi

echo '{"text": "󰢮 N/A", "tooltip": "GPU data unavailable", "class": "gpu-none"}'
