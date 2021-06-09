vcpkg_fail_port_install(
    ON_TARGET "uwp" "osx" "freebsd"
)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO osmocom/rtl-sdr
    REF d794155ba65796a76cd0a436f9709f4601509320
    SHA512 21fe10f1dbecca651650f03d1008560930fac439d220c33b4a23acce98d78d8476ff200765eed8cfa6cddde761d45f7ba36c8b5bc3662aa85819172830ea4938
    HEAD_REF master
    PATCHES
        Compile-with-msvc.patch
        fix-version.patch
        FixLinuxStaticLibName.patch
        fix-pthread-cancel.patch
        fix-android.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/rtlsdr)
vcpkg_copy_pdbs()

file(
    INSTALL ${SOURCE_PATH}/COPYING
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/rtlsdr
    RENAME copyright
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()
