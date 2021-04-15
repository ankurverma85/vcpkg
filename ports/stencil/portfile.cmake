if (EXISTS ${CMAKE_CURRENT_LIST_DIR}/use_source_path)
    file(READ ${CMAKE_CURRENT_LIST_DIR}/use_source_path srcpath)
    string(STRIP ${srcpath} srcpath)
    get_filename_component(VCPKG_USE_STENCIL_SRC_DIR ${srcpath} ABSOLUTE)
    set(SOURCE_PATH ${srcpath})
elseif (EXISTS ${CMAKE_CURRENT_LIST_DIR}/use_git)
    file(READ ${CMAKE_CURRENT_LIST_DIR}/use_git gitinfo)
    string(STRIP "${gitinfo}" gitinfo)
    list(GET gitinfo 0 giturl)
    list(GET gitinfo 1 commitId)
    vcpkg_from_git(
        OUT_SOURCE_PATH SOURCE_PATH
        URL ${giturl}
        REF ${commitId}
    )
else()
    set(commitId 3620637d0207ddba1cd86825dffcc10a768af5df)
    set(sha512 6cfb3ebb0e34b1d68003cb9635f3e259d4f37507ee66b050795d0c40e1c6bd21b76d204358ef60538ae8ea05a0dd43ea746584a4483de33d5199dcadf6677ce6)
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO ankurverma85/stencil
        REF ${commitId}
        SHA512 ${sha512}
        HEAD_REF master)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DSTENCIL_INSTALL_BUILDTOOLS=ON
        -DBUILD_TESTING=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
file(RENAME "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/tools")

