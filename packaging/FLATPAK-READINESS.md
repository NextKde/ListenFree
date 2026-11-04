# ListenFree Flatpak readiness — no binary distribution clearance claimed

Implemented locally (2026-11-04): opt-in app/desktop/icon/AppStream identity,
scoped MPRIS name and matching DesktopEntry, fixed private plugins, rejection of
inherited host SDK and sandbox portable/data-dir overrides, separate credential
schema/targets, explicit unavailable web-login message, pinned offline dependency
modules and 19 Qmmp patches with 70 explicit feature switches, mandatory dependency
license inputs, source/patch/build-manifest artifact retention, signing helper and
artifact-only workflow. Native and sandbox-identity host builds completed, followed
by actual isolated KDE 6.11 SDK dependency/app/sourcehost/sound-plugin builds,
AppStream composition, local OSTree export and an unsigned development bundle.
The SDK development build used local-dir sources and manually resumed module trees;
it does not establish that the clean immutable signing helper has completed.
Static ELF/plugin and final file inventories were recorded without launching apps.

See [the packaging guide](flatpak/README.md). This is a development manifest;
actual loader behavior, FFmpeg features, portal/audio/credentials/MPRIS/sourcehost
and lifecycle acceptance remain pending. The helper now retains a separately
signed builder-managed Sources bundle, exact app archive, patches, final metadata,
file inventory, SDK/runtime commits and a signed recursive artifact checksum list.
These new helper paths have not been run end-to-end. Global cleanup now removes
inspected build-only headers/configs/static QuickJS library and helper commands;
the previously recorded development bundle has not been regenerated for this change.
Qmmp compile-only staging now copies installed qmmp/qmmpui headers and COPYING
rather than an in-source build tree. Affected application targets were recompiled
and linked successfully inside the retained KDE SDK build with this staging;
existing warnings remain. No application execution or complete helper run occurred.
Root GPLv3 does not relicense other components. Maintainer review of applicable
GPL/AGPL/LGPL source delivery and notices is still required before publication;
source pins and host compilation are not aggregate-license approval.

No native data/credential migration, real install, signing key, Release, graphical
session or automated test was operated for this preparation. Clean immutable
source/build review, reviewed keys/runtime trust, signed Release artifacts and
manual sandbox/lifecycle acceptance remain prerequisites.
