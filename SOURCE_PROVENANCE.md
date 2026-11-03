# Source provenance

## Export origin

- Source repository: https://github.com/NextKde/NextKde (NextKDE working tree; previously published under SuceV587/NextKde).
- Exact original Git HEAD: `fe00a434b9d873d82c7ccbf51ef3aedb38db88f0`.
- Primary source path: `apps/listenfree/`, exported as this repository's **root**. Only tracked application files were copied, not the parent repository, Git history, local SDKs, archives, credentials or generated build output.
- Additional source closure: `shared/i18n/SystemLanguage.h` copied to `src/i18n/SystemLanguage.h`; root `LICENSE` copied verbatim; `tools/prepare-listenfree-sdk.sh` adapted to repository-local patches and dependency checks.
- Original ListenFree upstream: https://github.com/Tabris-Ayanami/ListenFree-desktop at `aeec83ecc9f8b80e2ea904a9a0d4bd031f1a5411`, recorded in `packaging/linux/upstream.json`.
- Independent repository: https://github.com/NextKde/ListenFree. Initial independent package version: **0.3.8**. The existing application string `0.3.8-nextkde.5` and ListenFree Qt/data identity were deliberately preserved.

## Independent export changes

CMake now uses root-local i18n headers and optional dependency SDK paths, defaults tests off, provides a Linux preset without developer-machine paths, and stages Qmmp plugins in the build tree instead of writing to the supplied SDK. The root `install.sh` delegates to the shared installer with management ID `org.nextkde.ListenFree`. Linux CMake installation keeps the `listenfree` executable, desktop ID, private-runtime layout and all notices. No NextKDE legacy migration, data move or MIME default reassignment is invoked.

The SDK preparation script fetches these exact release archives and verifies SHA-256 **before extraction**:

| Dependency | Release source | SHA-256 |
| --- | --- | --- |
| QuickJS-ng 0.16.2 | https://codeload.github.com/quickjs-ng/quickjs/tar.gz/refs/tags/v0.16.2 | `97c80625b26775a4c7ca618c004d4ea24cf99cbf867e4eba78bd927a8b23d106` |
| Qmmp 2.4.1 | https://downloads.sourceforge.net/project/qmmp-dev/qmmp/2.4/qmmp-2.4.1.tar.bz2 | `5a0a6f1efcefe9cc4b1ff3ae4038493168baec0b12989ca116af2454098825ed` |
| TagLib 2.3.1 | https://codeload.github.com/taglib/taglib/tar.gz/refs/tags/v2.3.1 | `72c3176432b065978dee670b674aaeae7d9a9f37c721ee578181e9231832bca1` |

Qmmp patch order: `patches/qmmp/2.4.1/0001`, `2.4.1/0003`, then numbered `0004` through `0020`. The revoked `0002` is not applied. Qmmp plugins and libraries must be built from that same patch set. Qt >= 6.10, compatible KF6 and native codec/security libraries are explicit external dependencies, not vendored binaries. The Linux CI operating-system toolchain is Ubuntu 26.04; distro packages receive normal distro updates, while the private source downloads above are content-pinned.

## Licensing and notices

`LICENSE` is the original NextKDE GNU GPL version 3 license text, not a new license grant or a relicensing of third-party work. Preserve all original copyright headers and the complete `licenses/` directory. Several incorporated/adapted components carry their own terms, including **AGPL-3.0** (AMLL/Folia), GPL (Qmmp/LDDC/VLC adaptations), LGPL (Qt and other runtime components), MIT, Apache-2.0, Boost and MIT-0. The original adaptation notices and references are retained verbatim in `licenses/THIRD-PARTY-NOTICES.txt`; do not treat the root GPL text as overriding those obligations.

`src/third_party/sourcehost_browser/browser.js` is an intentionally retained runtime resource, not a developer build cache. Its bundled notices and reproducible npm lockfile/generator are retained. `src/third_party/qqmusic_des` and `src/third_party/verblib` (where present) retain their original notices. Existing Windows notices/patches are retained even though Linux is the supported build here.

Source redistribution must keep these notices. Binary distributors must additionally ship the licenses/copyright files for their actual Qt, FFmpeg, Qmmp and other runtime builds, offer corresponding source as required, and review the aggregate GPL/AGPL obligations; this export does not certify a new distribution license or erase upstream obligations.
