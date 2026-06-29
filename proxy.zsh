# 终端代理自动配置 - zsh
# mihomo 混合端口（HTTP + SOCKS5 共用 7890）
# 函数：proxy_on / proxy_off / proxy_auto / proxy_status

_PROXY_HOST="127.0.0.1"
_PROXY_PORT="7890"
_PROXY_HTTP="http://${_PROXY_HOST}:${_PROXY_PORT}"
_PROXY_SOCKS="socks5://${_PROXY_HOST}:${_PROXY_PORT}"
_PROXY_TEST_URL="https://www.google.com/generate_204"
_PROXY_TIMEOUT=2
_NO_PROXY="localhost,127.0.0.1,::1"

proxy_on() {
    export http_proxy="${_PROXY_HTTP}"
    export HTTP_PROXY="${_PROXY_HTTP}"
    export https_proxy="${_PROXY_HTTP}"
    export HTTPS_PROXY="${_PROXY_HTTP}"
    export all_proxy="${_PROXY_SOCKS}"
    export ALL_PROXY="${_PROXY_SOCKS}"
    export no_proxy="${_NO_PROXY}"
    export NO_PROXY="${_NO_PROXY}"
    echo "✅ Proxy active (${_PROXY_HOST}:${_PROXY_PORT})"
}

proxy_off() {
    unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY
    unset all_proxy ALL_PROXY no_proxy NO_PROXY
    echo "⬛ Proxy inactive"
}

proxy_status() {
    if [[ -n "${http_proxy}" ]]; then
        echo "✅ Proxy active → ${http_proxy}"
    else
        echo "⬛ Proxy inactive"
    fi
}

proxy_auto() {
    # 第一步：端口探测（本地操作，瞬间）
    if ! nc -z "${_PROXY_HOST}" "${_PROXY_PORT}" 2>/dev/null; then
        proxy_off
        return
    fi

    # 第二步：连通性验证（最多等 _PROXY_TIMEOUT 秒）
    local code
    code=$(curl \
        --proxy "${_PROXY_HTTP}" \
        --max-time "${_PROXY_TIMEOUT}" \
        --silent \
        --output /dev/null \
        --write-out "%{http_code}" \
        "${_PROXY_TEST_URL}" 2>/dev/null)

    if [[ "${code}" == "204" ]]; then
        proxy_on
    else
        proxy_off
    fi
}

# shell 启动时自动探测一次
proxy_auto
