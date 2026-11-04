# ListenFree GitHub Flatpak bundle preparation

This is a development manifest, not a published or sandbox-accepted binary.
The recommended distribution route is a signed GitHub Release bundle; it does
not require a hosted application OSTree remote or a Flathub submission.

## Build graph

The manifest declares checksum-pinned ECM/WindowSystem, libsecret, QuickJS-ng
0.16.2, TagLib 2.3.1 (including its exact utfcpp submodule revision
819011bb01628fe1aa2f1da9f2c842a48fd5680b) and Qmmp 2.4.1. All 19 currently selected Qmmp patches are
explicit inputs. The withdrawn 0002 patch remains excluded. Every discovered
Qmmp USE_* switch is explicit; only FFmpeg/curl/PulseAudio/null/crossfade are on.
Build steps use declared sources, not prepare-listenfree-sdk.sh or an inherited
host SDK. KDE 6.11 SDK/runtime supply Qt, FFmpeg, curl, PulseAudio, OpenSSL, ICU,
zlib and the rest of their runtime graph. Those ABI/feature assumptions require
an actual SDK build and inspection; host compilation is not evidence for them.

`LISTENFREE_FLATPAK_BUILD=ON` changes only sandbox builds. Desktop/icon/AppStream
identity is org.nextkde.ListenFree. Application and sourcehost remain siblings
under /app/opt/listenfree; declared libraries live under /app/lib. The launcher
and Flatpak runtime library path resolve them. Plugins come only from the fixed
private app path. MPRIS uses org.mpris.MediaPlayer2.org.nextkde.ListenFree, with
instance suffix support. Native defaults are retained.

## Permissions and features

GUI/GPU, PulseAudio, network, scoped MPRIS ownership and secret-service access are
requested; no all-home, all-bus or host-spawn permission is requested. KDE 6.11
also inherits read-only xdg-config/kdeglobals and talk access to
com.canonical.AppMenu.Registrar, org.kde.kconfig.notify and org.kde.KGlobalSettings;
review the final metadata for the actual permission set. File/folder
choices use the desktop portal. Actual persistent access after restart must be
checked with the target portal; do not silently broaden filesystem permissions.
WebEngine login, mpv and video are excluded from this initial profile; web login
reports the unavailable feature instead of launching/installing a host helper.
Cookie login uses a separate schema and target namespace, not native credentials.
Secret-service permission is not a guarantee of per-item isolation imposed by the
service; review this permission before publication. Failure to save a credential
already prevents login completion. Normal uninstall does not delete app data or
promise credential removal; log out accounts explicitly before uninstall when
credential deletion is desired.

Portable mode and --data-dir are rejected in sandbox builds. Private Flatpak data
is used; native profiles, libraries and credentials are not automatically moved.
Any migration requires consent and a backup. Music selected through a portal is
not copied into private storage unless the app action explicitly does so.

## Source and licensing release gate

The root GPLv3 declaration is retained; it does not relicense embedded AGPL/GPL,
LGPL or permissive components. See SOURCE_PROVENANCE.md and licenses/. This is
not an aggregate-license approval. Mandatory Qmmp, QuickJS, TagLib LGPL/MPL,
utfcpp Boost and libsecret texts must exist before sandbox CMake configuration can succeed.
Dependency modules install those texts; the app retains them in its license tree.

The preparation helper retains a builder-managed Sources bundle, exact app source
archive, patches and build manifest with artifacts. The publisher must still
review complete corresponding sources, configurations and applicable notices; an
upstream URL or manifest alone is not a universal substitute for the applicable
source-delivery obligations. `/app/src` is build-only staging for app compilation:
it now retains only installed Qmmp/qmmpui headers and COPYING, not an in-source
build tree or its objects, and is removed from the runtime package. The staged
headers are not a substitute for separate corresponding-source artifacts. A
retained KDE SDK build recompiled affected application targets and linked
successfully with this header-only staging on 2026-11-04; this is not a clean
end-to-end helper run. Record actual SDK/runtime commits, FFmpeg configuration
and shipped plugin/library inventory after a real build. Review AMLL/Folia AGPL
and other component obligations with the maintainer before binary publication.
Do not advertise this preparation as legal clearance.

## Export and remaining acceptance

prepare-bundle.py requires a clean reviewed commit, pre-provisioned KDE SDK/runtime,
flatpak-builder and a separately managed signing home. It never installs or
publishes apps. The manual protected-environment workflow uploads artifacts only;
secrets, public-key review and publication remain separate maintainer operations.
One architecture is exported per invocation; merged metadata must be signed again.

On 2026-11-04, the authorized isolated KDE 6.11 SDK build completed for the
declared dependencies, app, sourcehost and app sound plugin. Staging installed
the app-ID desktop/icon/metainfo, private plugins and all mandatory dependency
notices. The build used local-dir development sources and manually resumed module
trees, not the clean immutable signing helper. AppStream composition, cleaned
local OSTree export and unsigned development bundle export completed. No app or
helper was installed into a user installation or launched.

Remaining manual acceptance: loader/plugin resolution, local and
online playback/seeking/crossfade, audio device changes, portal selections and
restart access, secret-service errors/login/logout, MPRIS, sourcehost shutdown,
visible excluded-feature messages, signed installation/update/uninstall and data
retention. Use isolated profiles, not personal credentials or music databases.


## Source artifacts and provenance

The release helper now passes `--bundle-sources` to flatpak-builder and exports
`APP_ID.Sources-VERSION-ARCH.flatpak` as a separately signed runtime bundle. This
is source delivery, not an application dependency: Settings does not install it.
Keep and publish it alongside the application, not just a GitHub source URL.
Builder-managed module sources include declared dependency inputs and patches;
the exact app Git archive and relocated patch inputs are retained separately.

`build-info.json` records user-level SDK/runtime refs and commits, tool versions,
and the Sources ref/commit. The helper rejects SDK/runtime commit changes during
construction. Provision these dependencies in the isolated **user** installation.
`flatpak-metadata.ini` and `runtime-files.txt` retain final permissions and file
inventory. `SHA256SUMS` recursively binds all retained artifacts, including nested
patches, and has its own detached publisher signature. Preserve the complete
artifacts directory and its relative paths when distributing or reviewing it.
The helper also prepares `APP_ID-VERSION-ARCH-release-materials.tar.gz` and a direct
detached signature, preserving that complete tree for GitHub's flat asset UI.
The archive contains the earlier checksums/signature, not itself; validate its
own signature before extracting. Publish the archive/signature alongside the
client-facing app bundle, `flatpak-release.json`/`.sig`, `app-release.json` and
Sources bundle. Do not upload only the runtime app and discard source material.

`app-release.json` is generated by the existing source-release preparer, fetching
and hashing GitHub's exact codeload archive for the same revision. This preserves
legacy `releases/latest` compatibility; its hash is not substituted with the local
`git archive` hash (the bytes can differ). The fixed source revision must already
be publicly available. Failure to prepare source metadata fails artifact preparation.

These are release-preparation code changes, not a completed signed helper run.
The Sources bundle does not supply the external SDK/runtime's corresponding
sources, prove relinkability or approve aggregate licensing. Maintainers still
must inspect the exported source contents, linked component configuration,
applicable licenses/notices and provider source-delivery obligations. Validate
`SHA256SUMS.sig` using an independently trusted publisher key before checking
hashes. Do not install the Sources bundle into a personal profile for inspection.
