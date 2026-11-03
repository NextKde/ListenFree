# ListenFree Linux 独立构建

此仓库是独立的 NextKde/ListenFree，使用仓库根 `cmake -S .`，不再依赖 NextKDE 源码树。依赖准备、命令行构建、安装、升级和卸载命令见[根 README](../../README.md)。

需要 Qt >= 6.10 与匹配的 KF6 WindowSystem、TagLib >= 2.3.1、QuickJS-ng 0.16.2、带本仓库补丁的 Qmmp 2.4.1 及其配套插件，以及 FFmpeg/OpenSSL/libsecret/ICU 等开发包。Ubuntu 24.04 自带 Qt 不满足要求；使用 Ubuntu 26.04 或完整兼容工具链。`tools/check-dependencies.py --sdk-only` 报告实际缺失依赖，不会自动安装系统软件包。

`tools/prepare-listenfree-sdk.sh` 校验固定 SHA-256 后，在私有目录构建音频与 JS 依赖。默认目录为根 `.build/listenfree-sdk`；外部目录通过 `LISTENFREE_SDK` 指定，旧 `KOS_LISTENFREE_SDK` 保留为显式兼容别名。共享安装器不会自动准备 SDK，使用它之前必须先在稳定目录准备并导出 `LISTENFREE_SDK`。

保留 `bin/listenfree`、`share/applications/listenfree.desktop`、`opt/listenfree` 私有运行库布局以及应用自身原有 Qt/资料/MPRIS 身份。安装不会调用 kosctl 或迁移工具，不删除 kos-music，不自动迁移其资料，不接管默认音频关联。安装器的管理 ID `org.nextkde.ListenFree` 不改变应用资料目录。

视频和 Qt WebEngine 登录组件默认不编译。普通安装不包含可选登录组件；须显式安装 `listenfree-web-login` component，或从 `packaging/web-login` 单独构建，详见[说明](../web-login/install.txt)。
