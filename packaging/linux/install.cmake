# Preserve the established launcher, desktop ID and private-runtime layout.
set(_listenfree_install_dir opt/listenfree)
set_target_properties(listenfree listenfree-sourcehost PROPERTIES INSTALL_RPATH "$ORIGIN/lib")
install(TARGETS listenfree listenfree-sourcehost RUNTIME DESTINATION ${_listenfree_install_dir})
if(NOT LISTENFREE_FLATPAK_BUILD)
get_filename_component(_listenfree_library_dir "${LISTENFREE_QMMP_LIBRARY}" DIRECTORY)
file(GLOB _listenfree_private_libraries
    "${_listenfree_library_dir}/libqmmp.so*"
    "${_listenfree_library_dir}/libtag.so*" "${_listenfree_library_dir}/libopusfile.so*")
get_filename_component(_listenfree_ui_library_dir "${LISTENFREE_QMMP_UI_LIBRARY}" DIRECTORY)
file(GLOB _listenfree_ui_libraries "${_listenfree_ui_library_dir}/libqmmpui.so*")
install(FILES ${_listenfree_ui_libraries} ${_listenfree_private_libraries} DESTINATION ${_listenfree_install_dir}/lib)
endif()
install(DIRECTORY "${LISTENFREE_QMMP_PLUGIN_ROOT}/" DESTINATION ${_listenfree_install_dir}/qmmp)
# install(FILES/DIRECTORY) does not honor --strip; handle copied SDK libraries
# after staging, leaving the developer's SDK and build artifacts untouched.
configure_file(packaging/linux/strip-runtime.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/strip-runtime.cmake" @ONLY)
install(SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/strip-runtime.cmake")
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE" DESTINATION ${_listenfree_install_dir}/licenses RENAME ListenFree-GPL-3.0.txt)
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/licenses/" DESTINATION ${_listenfree_install_dir}/licenses)
if(LISTENFREE_FLATPAK_BUILD)
    set(LISTENFREE_DEPENDENCY_LICENSE_DIR "${CMAKE_INSTALL_PREFIX}/share/licenses/listenfree-dependencies"
        CACHE PATH "Mandatory license texts installed by declared dependency modules")
    foreach(_component Qmmp QuickJS TagLib-LGPL TagLib-MPL UTF8CPP Libsecret)
        set(_license "${LISTENFREE_DEPENDENCY_LICENSE_DIR}/${_component}.txt")
        if(NOT EXISTS "${_license}")
            message(FATAL_ERROR "Required sandbox dependency license is missing: ${_license}")
        endif()
        install(FILES "${_license}" DESTINATION ${_listenfree_install_dir}/licenses)
    endforeach()
else()
foreach(_license
    "${LISTENFREE_QMMP_SOURCE_ROOT}/COPYING"
    "${LISTENFREE_SDK}/vendor/taglib-2.3.1/COPYING.LGPL"
    "${LISTENFREE_SDK}/vendor/quickjs-0.16.2/LICENSE")
    if(EXISTS "${_license}")
        get_filename_component(_license_dir "${_license}" DIRECTORY)
        get_filename_component(_license_name "${_license_dir}" NAME)
        install(FILES "${_license}" DESTINATION ${_listenfree_install_dir}/licenses RENAME "${_license_name}-LICENSE.txt")
    endif()
endforeach()
endif()
configure_file(packaging/linux/listenfree.in "${CMAKE_CURRENT_BINARY_DIR}/listenfree-launcher" @ONLY)
configure_file(packaging/linux/listenfree.desktop.in "${CMAKE_CURRENT_BINARY_DIR}/listenfree.desktop" @ONLY)
install(PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/listenfree-launcher" DESTINATION bin RENAME listenfree)
if(LISTENFREE_FLATPAK_BUILD)
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/listenfree.desktop" _desktop)
    string(REPLACE "${CMAKE_INSTALL_PREFIX}/bin/listenfree" "listenfree" _desktop "${_desktop}")
    string(REPLACE "Icon=listenfree" "Icon=${KOS_FLATPAK_APP_ID}" _desktop "${_desktop}")
    string(REPLACE "StartupWMClass=listenfree" "StartupWMClass=${KOS_FLATPAK_APP_ID}" _desktop "${_desktop}")
    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${KOS_FLATPAK_APP_ID}.desktop" "${_desktop}")
    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${KOS_FLATPAK_APP_ID}.desktop" DESTINATION share/applications)
    install(FILES music_player_desktop/assets/icons/nextkde-music.svg
        DESTINATION share/icons/hicolor/scalable/apps RENAME "${KOS_FLATPAK_APP_ID}.svg")
    configure_file(packaging/flatpak/metainfo.xml.in
        "${CMAKE_CURRENT_BINARY_DIR}/${KOS_FLATPAK_APP_ID}.metainfo.xml" @ONLY)
    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${KOS_FLATPAK_APP_ID}.metainfo.xml" DESTINATION share/metainfo)
else()
    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/listenfree.desktop" DESTINATION share/applications)
    install(FILES music_player_desktop/assets/icons/nextkde-music.svg
        DESTINATION share/icons/hicolor/scalable/apps RENAME listenfree.svg)
endif()

install(FILES "${LISTENFREE_SDK}/deps/usr/share/doc/libopusfile0/copyright"
    DESTINATION ${_listenfree_install_dir}/licenses RENAME Opusfile-copyright.txt OPTIONAL)

install(FILES packaging/web-login/install.txt DESTINATION ${_listenfree_install_dir} RENAME web-login-install.txt)
