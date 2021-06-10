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
    set(commitId 4f2b3e40b4d1d75e82fbe718fbabda7cf242aaac)
    set(sha512 985d61cc4ffa530311c4c45c94182f0bcd47d72970f82bcba68bea029895a157636fc8774475eb5575d6fdb4ce03406eddfd49bc5f57c10523a9ce4a926c25f1)
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

