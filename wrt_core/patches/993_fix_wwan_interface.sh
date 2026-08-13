#!/bin/sh

# 修复 wwan 接口默认绑定
# 当检测到有 STA 模式的无线接口时，自动绑定 wwan

setup_wwan_iface() {
    # 检查是否有 STA 模式的无线接口
    local sta_iface=$(uci show wireless | grep "mode='sta'" | head -1 | cut -d. -f1-2)
    
    if [ -n "$sta_iface" ]; then
        local device=$(uci get "${sta_iface}.device")
        
        # 确保 wwan 接口存在且绑定正确
        if ! uci get network.wwan >/dev/null 2>&1; then
            uci set network.wwan=interface
            uci set network.wwan.proto='dhcp'
        fi
        
        # 绑定设备名（radio1 -> wlan1 等）
        local iface_name=$(echo "$device" | sed 's/radio/wlan/')
        uci set network.wwan.device="$iface_name"
        uci commit network
    fi
}

setup_wwan_iface
