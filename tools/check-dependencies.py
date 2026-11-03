#!/usr/bin/env python3
"""Check ListenFree's Linux build dependencies; never install system packages."""
import argparse
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
TOOLS = ('bash', 'cmake', 'ninja', 'cc', 'c++', 'pkg-config', 'curl', 'tar',
         'bzip2', 'patch', 'sha256sum', 'flock')
LIBRARIES = ('Qt6Core >= 6.10', 'Qt6Gui', 'Qt6Widgets', 'Qt6Qml', 'Qt6Quick',
             'Qt6QuickDialogs2', 'Qt6Sql', 'Qt6Network', 'Qt6Concurrent',
             'Qt6DBus', 'Qt6ShaderTools', 'libavformat', 'libavcodec', 'libavutil',
             'libswresample', 'libcurl', 'libpulse', 'libsecret-1', 'icu-uc',
             'icu-i18n', 'openssl', 'zlib')


def run(command):
    return subprocess.run(command, text=True, stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT, timeout=40)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--sdk-only', action='store_true',
                        help='check native prerequisites before fetching private dependencies')
    parser.add_argument('--video', action='store_true')
    parser.add_argument('--web-login', action='store_true')
    args = parser.parse_args()
    missing = [tool for tool in TOOLS if not shutil.which(tool)]
    if shutil.which('cmake'):
        version = run(['cmake', '--version']).stdout
        match = re.search(r'(\d+)\.(\d+)', version)
        if not match or tuple(map(int, match.groups())) < (3, 28):
            missing.append('CMake >= 3.28')
    libraries = list(LIBRARIES)
    if args.video:
        libraries.append('Qt6Multimedia')
    if args.web_login:
        libraries.append('Qt6WebEngineWidgets')
    if shutil.which('pkg-config'):
        missing += [lib for lib in libraries if run(['pkg-config', '--exists', lib]).returncode]
    if missing:
        print('Missing or incompatible ListenFree prerequisites:')
        for dependency in missing:
            print('  - ' + dependency)
        print('Install a compatible Qt >= 6.10 / KF6 toolchain and the packages listed in README.md.')
        print('No system package was installed. Ubuntu 24.04 stock Qt 6.4 is too old.')
        return 1
    temporary = ROOT / 'tmp' / 'dependencies'
    temporary.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='check-', dir=temporary) as build:
        result = run(['cmake', '-S', str(ROOT / 'cmake' / 'dependency-check'),
                      '-B', build, '-G', 'Ninja',
                      '-DLISTENFREE_BUILD_VIDEO=' + ('ON' if args.video else 'OFF'),
                      '-DLISTENFREE_BUILD_WEB_LOGIN=' + ('ON' if args.web_login else 'OFF')])
        if result.returncode:
            print(result.stdout)
            print('Native dependency discovery failed; no dependency checks were bypassed.')
            return result.returncode
    print('Native prerequisites ready (Qt ' + run(['pkg-config', '--modversion', 'Qt6Core']).stdout.strip() + ').')
    print('Private dependencies: QuickJS-ng 0.16.2, TagLib 2.3.1, patched Qmmp 2.4.1.')
    if not args.sdk_only:
        sdk = Path(os.environ.get('LISTENFREE_SDK', ROOT / '.build' / 'listenfree-sdk'))
        if not (sdk / 'prefix/lib/cmake/qjs/qjsConfig.cmake').is_file() or not (sdk / 'prefix/lib/libqmmp.so').is_file():
            print('Private SDK absent: run ./tools/prepare-listenfree-sdk.sh, or set LISTENFREE_SDK.')
            return 1
        print('Private SDK found at ' + str(sdk) + '; the application CMake configure checks its libraries and headers.')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except subprocess.TimeoutExpired as error:
        print('Dependency command exceeded 40 seconds: ' + str(error.cmd), file=sys.stderr)
        sys.exit(1)
