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
    set(commitId 54d8a70627096f0562077d6136a950bd4591faa7)
    set(sha512 680d750813fde850dd45f8845354bd0252965cbf337803264f3bca4574d055e51ee9071fd4bb025c4b64785b80c9d7671fe6cfb5b028c33ffc9c0edaae288e0e)
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
    OPTIONS -DSTENCIL_INSTALL_BUILDTOOLS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
file(RENAME "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/tools")

