# auto-proxy

终端代理自动配置工具。检测本地代理（mihomo / Clash 等）是否可用，自动设置终端环境变量。

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/HangLark/auto-proxy/main/install.sh | bash
```

安装完成后执行：

```bash
source ~/.zshrc
```

## 工作原理

每次打开新终端时自动执行两步探测：

1. **端口检测**：检查 `127.0.0.1:7890` 是否在监听（瞬间完成）
2. **连通性验证**：通过代理请求 `google.com/generate_204`，返回 204 则确认可用

代理不可用时立即返回，不阻塞终端启动。

## 手动控制

```bash
proxy_auto    # 重新探测，自动决定开关
proxy_on      # 强制开启代理
proxy_off     # 强制关闭代理
proxy_status  # 查看当前状态（不发网络请求）
```

## 默认配置

| 参数 | 值 |
|---|---|
| 代理地址 | `127.0.0.1:7890`（混合端口） |
| 测试 URL | `https://www.google.com/generate_204` |
| 超时时间 | 2s |

如需修改，编辑 `~/.zsh/proxy.zsh` 顶部的变量。

## 兼容性

目前支持 **zsh**（macOS 默认 shell）。
