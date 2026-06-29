#!/usr/bin/env bash
# auto-proxy installer
# Usage: curl -fsSL https://raw.githubusercontent.com/HangLark/auto-proxy/main/install.sh | bash

set -e

REPO="HangLark/auto-proxy"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

PROXY_DIR="${HOME}/.zsh"
PROXY_FILE="${PROXY_DIR}/proxy.zsh"
ZSHRC="${HOME}/.zshrc"
SOURCE_MARK="# auto-proxy"
SOURCE_LINE="source ~/.zsh/proxy.zsh"

echo "→ Installing auto-proxy..."

# 创建目录
mkdir -p "${PROXY_DIR}"

# 下载 proxy.zsh
echo "→ Downloading proxy.zsh..."
curl -fsSL "${RAW_BASE}/proxy.zsh" -o "${PROXY_FILE}"
echo "   Saved to ${PROXY_FILE}"

# 写入 .zshrc（幂等：已有则跳过）
if grep -qF "${SOURCE_LINE}" "${ZSHRC}" 2>/dev/null; then
    echo "→ .zshrc already configured, skipping"
else
    printf '\n%s\n%s\n' "${SOURCE_MARK}" "${SOURCE_LINE}" >> "${ZSHRC}"
    echo "→ Added source line to ${ZSHRC}"
fi

echo ""
echo "✅ Done! To activate now, run:"
echo "   source ~/.zshrc"
