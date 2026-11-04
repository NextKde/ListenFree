# ListenFree

Independent Linux music player maintained at [NextKde/ListenFree](https://github.com/NextKde/ListenFree), exported from the NextKDE adaptation of [ListenFree-desktop](https://github.com/Tabris-Ayanami/ListenFree-desktop). Initial independent version: **0.3.8**. Qt Quick UI, local music library, online sources, lyrics and a patched Qmmp audio engine.

This repository builds from its own root. No NextKDE checkout, desktop shell, Go service or sibling source directory is required. Original component notices, patches, resources and relevant development sources are retained; see [SOURCE_PROVENANCE.md](SOURCE_PROVENANCE.md) and [licenses/THIRD-PARTY-NOTICES.txt](licenses/THIRD-PARTY-NOTICES.txt).

## Flatpak bundle preparation

See [packaging/flatpak/README.md](packaging/flatpak/README.md) for the development manifest, declared patched dependencies, sandbox identity/permissions, mandatory license inputs and artifact-only signing workflow. No signed binary Release or sandbox acceptance is claimed. Native profiles/credentials are not migrated; optional WebEngine login and video are excluded from this initial package. Applicable component/source-delivery review remains required before publication.

## Linux dependencies

- CMake **3.28+**, Ninja, a C++20 compiler, Python 3, Bash, curl, tar/bzip2, patch, SHA-256 tools and flock.
- A consistent **Qt 6.10+ / KDE Frameworks 6 WindowSystem** toolchain: Qt Core, Gui, Widgets, Qml, Quick, QuickDialogs2, Sql (SQLite driver), Network, DBus, Concurrent, ShaderTools and **LinguistTools** (required to build Qmmp), plus the Qt Quick Controls/Dialogs/Effects/Shapes QML runtime modules.
- FFmpeg development libraries (avformat, avcodec, avutil, swresample), libcurl, PulseAudio client library, OpenSSL, zlib, ICU, libsecret and utf8cpp headers.
- **QuickJS-ng 0.16.2**, **TagLib 2.3.1+**, and **Qmmp 2.4.1 with this repository's patches and matching plugins**. Unpatched system Qmmp is not compatible. `tools/prepare-listenfree-sdk.sh` downloads checksum-pinned releases and builds them privately; TagLib 2.3.1 is built by default. Set `LISTENFREE_USE_SYSTEM_TAGLIB=1` to deliberately use an installed version >= 2.3.1 instead.

Nothing in the installer or SDK preparation installs system packages. Run the checker first:

```sh
python3 tools/check-dependencies.py --sdk-only
```

Ubuntu **26.04** provides an appropriate Qt/KF6 generation. Ubuntu 24.04's stock Qt is too old; installing its packages again does not satisfy Qt >= 6.10. For a separately supplied toolchain set both `CMAKE_PREFIX_PATH` and `PKG_CONFIG_PATH`; Qt and KF6 must have compatible ABIs.

Example system dependencies (install these yourself, not through the app installer):

```sh
# Ubuntu 26.04
sudo apt install build-essential cmake ninja-build pkg-config python3 curl tar bzip2 patch util-linux \
  qt6-base-dev qt6-base-dev-tools qt6-declarative-dev qt6-declarative-dev-tools qt6-shadertools-dev qt6-tools-dev qt6-tools-dev-tools \
  libkf6windowsystem-dev libavformat-dev libavcodec-dev libavutil-dev libswresample-dev \
  libcurl4-openssl-dev libpulse-dev libssl-dev zlib1g-dev libicu-dev libsecret-1-dev libutfcpp-dev \
  libqt6sql6-sqlite qml6-module-qtcore qml6-module-qtqml qml6-module-qtqml-models \
  qml6-module-qtqml-workerscript qml6-module-qtquick qml6-module-qtquick-window \
  qml6-module-qtquick-layouts qml6-module-qtquick-controls qml6-module-qtquick-templates \
  qml6-module-qtquick-dialogs qml6-module-qtquick-effects qml6-module-qtquick-shapes
# Arch Linux
sudo pacman -S --needed base-devel cmake ninja pkgconf python curl tar bzip2 patch util-linux \
  qt6-base qt6-declarative qt6-shadertools qt6-tools kwindowsystem ffmpeg libpulse openssl zlib icu libsecret utf8cpp
```

## CLI build and direct installation

From the repository root:

```sh
./tools/prepare-listenfree-sdk.sh
cmake --preset linux-release
cmake --build --preset linux-release
cmake --install build/linux-release
~/.local/bin/listenfree
```

The SDK defaults to `.build/listenfree-sdk`, which the root CMake discovers automatically. Downloads have fixed SHA-256 checksums; the patch series is in `patches/qmmp/`. No dependency archives or SDK binaries are committed. First preparation requires network access and can take several minutes. The script reuses a fingerprinted compatible SDK.

To use a separate SDK, or install elsewhere:

```sh
export LISTENFREE_SDK=/absolute/path/to/listenfree-sdk
./tools/prepare-listenfree-sdk.sh "$LISTENFREE_SDK"
cmake -S . -B build/release -G Ninja -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTING=OFF -DLISTENFREE_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX="$HOME/.local"
cmake --build build/release --parallel 4
cmake --install build/release
```

`KOS_LISTENFREE_SDK` remains an explicit compatibility alias. Advanced packagers may instead supply `qjs_DIR`, `TagLib_DIR`, `LISTENFREE_QMMP_SOURCE_ROOT`, `LISTENFREE_QMMP_LIBRARY`, `LISTENFREE_QMMP_RUNTIME`, `LISTENFREE_QMMP_UI_LIBRARY`, `LISTENFREE_QMMP_PLUGIN_ROOT` and `LISTENFREE_LIVE_FFMPEG_ROOT`. All are dependency paths, not NextKDE source paths. A missing SDK fails configuration with preparation instructions; CMake does not fetch or silently replace dependencies.

For direct-CMake updates, rebuild and install from the new source revision into the same prefix. Direct-CMake installation is not owned by the managed installer: retain `build/release/install_manifest.txt` and remove only those recorded files yourself when uninstalling; never delete a whole shared prefix. Do not mix direct and managed ownership of the same launcher.

## Managed install, update and uninstall

The shared Python installer uses `org.nextkde.ListenFree` **only as its management ID**. It builds the independent repository root in Release mode with `BUILD_TESTING=OFF`; each release uses an immutable revision directory and the existing CMake install rules. Before using it, prepare an SDK in a **stable location outside the installer's temporary source/build folders**, then export its absolute path:

```sh
export LISTENFREE_SDK="$HOME/.local/share/listenfree-sdk"
./tools/prepare-listenfree-sdk.sh "$LISTENFREE_SDK"
./install.sh check
./install.sh install --version 0.3.8
./install.sh status
./install.sh check-update
./install.sh update
./install.sh uninstall
```

Equivalent entry point: `python3 packaging/installer.py --app listenfree ...`. The installer does not prepare the audio SDK or install system dependencies automatically; the environment above must be present again for updates. Exact revision and archive checksum metadata are supplied by `app-release.json`. `--help` describes installation paths and supported options. Uninstall concerns installer-owned program files, not ListenFree user data.

## Identity, data and desktop integration

Preserved: executable/launcher `listenfree`, desktop file **`listenfree.desktop`**, icon name `listenfree`, Qt application/organization **`ListenFree` / `ListenFree`**, existing application version string `0.3.8-nextkde.5`, and existing D-Bus/MPRIS behavior. Installer metadata starts at 0.3.8; it does not rename the application's data namespace.

The chosen prefix contains `bin/listenfree`, `share/applications/listenfree.desktop`, and `opt/listenfree` (player, source host, private audio runtime, licenses). The wrapper supplies private Qmmp/library paths. Refresh the desktop cache with `update-desktop-database PREFIX/share/applications` if your desktop needs it. Audio-file paths and URLs are forwarded to an existing instance.

**No automatic migration from `kos-music`, association takeover, settings reset or legacy-file removal is performed.** Existing ListenFree data remains where the application already stores it. Back up profiles before choosing any manual migration; installing this independent app does not run NextKDE migration tools.

## Optional features

Default builds exclude Qt Multimedia/video, Qt WebEngine login, development tools and tests. Add `-DLISTENFREE_BUILD_VIDEO=ON` for video (requires Qt Multimedia development files and QML module). Add `-DLISTENFREE_BUILD_WEB_LOGIN=ON` for the separate WebEngine helper, then install its explicit component:

```sh
cmake --install build/release --component listenfree-web-login
```

Normal installation does not include the helper. Cookie login remains available without it. The helper can also build independently from `packaging/web-login`; [instructions](packaging/web-login/install.txt). `LISTENFREE_STRIP_INSTALL=OFF` retains installed Release symbols. Windows-specific scripts and upstream notices are retained as historical inputs, not a supported Linux toolchain or a promise of Windows CI.

## CI and manual verification

The Linux build workflow uses Ubuntu 26.04's Qt/KF6 stack, checks the actual dependencies, prepares the pinned SDK, and builds/installs with tests disabled. It deliberately fails if packages, toolchain versions, downloads or builds are unavailable; no successful run is claimed merely because the workflow is checked in.

After installing, manually open ListenFree, check settings and the library, play a local track, inspect lyrics/queue and file-manager launching, then close/reopen to confirm persistence. Online sources need your own imported scripts and permissions. No personal credentials or user profiles are included in this repository.

## Independent stable releases

A maintainer publishes a reviewed `vX.Y.Z` tag matching `VERSION`. The application
workflow must build and validate successfully before its release job publishes
`app-release.json`. The manifest records the exact source commit and source
archive SHA-256. Settings checks this repository's latest stable GitHub Release
on **Check for updates**, then offers **Update**; users do not need a new NextKDE
release. Drafts and prereleases are not offered, and updates are never automatic.

The bundled installer is reviewed code, not a script fetched by a release check.
Publication permissions on this GitHub repository are the trust boundary; hashes
protect transfer integrity, not a compromised publisher. Never publish a release
for an unverified source commit. See `packaging/INSTALLATION.md` for CLI actions,
network error handling, offline removal, installation ownership and preserved data.
