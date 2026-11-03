# ListenFree Linux packaging

This is the independent NextKde/ListenFree repository. Build from its root (`cmake -S .`), not `apps/listenfree`, and use [the root README](../../README.md) for dependency preparation, CLI build, install, update and uninstall instructions.

The CMake project requires Qt >= 6.10, TagLib >= 2.3.1, QuickJS-ng 0.16.2 and the matching patched Qmmp 2.4.1 runtime. `tools/prepare-listenfree-sdk.sh` prepares pinned private sources/libraries without installing system packages. `LISTENFREE_SDK` supplies an external SDK; `.build/listenfree-sdk` in this checkout is discovered automatically. `KOS_LISTENFREE_SDK` remains a compatibility alias. The independent installer requires an explicit stable SDK environment for its downloaded source builds; it does not prepare one automatically.

The established CMake install layout is preserved:

- `bin/listenfree`: launcher supplying private library/plugin paths.
- `share/applications/listenfree.desktop`: existing desktop ID and file/URL arguments.
- `share/icons/hicolor/scalable/apps/listenfree.svg`: existing icon name.
- `opt/listenfree/`: player, source host, private Qmmp runtime, plugins and licenses.

No NextKDE checkout, shell service, Go service, `kosctl` or migration tool is invoked. Existing ListenFree Qt identity, profile and MPRIS behavior remain unchanged. Installing does not remove `kos-music`, migrate its data, or change the user's default audio associations.

Video and the separate WebEngine login helper remain optional and disabled by default. Build the latter from `packaging/web-login` or enable `LISTENFREE_BUILD_WEB_LOGIN`; install only with component `listenfree-web-login`. The ordinary player install does not pull in the helper. See [helper instructions](../web-login/install.txt).
