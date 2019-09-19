include(InstallRequiredSystemLibraries)

#install_directory_permissions( DIRECTORY usr/${CMAKE_INSTALL_INCLUDEDIR}/eosio )

set(CPACK_PACKAGE_CONTACT "team@remme.io")
set(CPACK_OUTPUT_FILE_PREFIX ${CMAKE_BINARY_DIR}/packages)
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)
endif()

SET(CPACK_PACKAGE_DIRECTORY "${CMAKE_BINARY_DIR}/install")
set(CPACK_PACKAGE_NAME "REMME.IO")
set(CPACK_PACKAGE_VENDOR "remme.io")
set(CPACK_PACKAGE_VERSION_MAJOR "${VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${VERSION_PATCH}")
set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")
set(CPACK_PACKAGE_DESCRIPTION "Software for the REMME network")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Software for the REMME.IO network")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "REMME.IO ${CPACK_PACKAGE_VERSION}")

if(WIN32)
  set(CPACK_GENERATOR "ZIP;NSIS")
  set(CPACK_NSIS_EXECUTABLES_DIRECTORY .)
  set(CPACK_NSIS_PACKAGE_NAME "EOS.IO v${CPACK_PACKAGE_VERSION}")
  set(CPACK_NSIS_DISPLAY_NAME "${CPACK_NSIS_PACKAGE_NAME}")
  set(CPACK_NSIS_DEFINES "  !define MUI_STARTMENUPAGE_DEFAULTFOLDER \\\"REMME.IO\\\"")
  # windows zip files usually don't have a single directory inside them, unix tgz usually do
  set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY 0)
elseif(APPLE)
  set(CPACK_GENERATOR "DragNDrop")
else()
  set(CPACK_GENERATOR "DEB")
  set(CPACK_DEBIAN_PACKAGE_RELEASE 0)
  if(CMAKE_VERSION VERSION_GREATER 3.6.0) # Buggy in 3.5, behaves like VERSION_GREATER_EQUAL
    set(CPACK_DEBIAN_FILE_NAME "DEB-DEFAULT")
  else()
    string(TOLOWER ${CPACK_PACKAGE_NAME} CPACK_DEBIAN_PACKAGE_NAME)
    execute_process(COMMAND dpkg --print-architecture OUTPUT_VARIABLE CPACK_DEBIAN_PACKAGE_ARCHITECTURE OUTPUT_STRIP_TRAILING_WHITESPACE)
    SET(CPACK_PACKAGE_FILE_NAME ${CPACK_DEBIAN_PACKAGE_NAME}_${CPACK_PACKAGE_VERSION}-${CPACK_DEBIAN_PACKAGE_RELEASE}_${CPACK_DEBIAN_PACKAGE_ARCHITECTURE})
  endif()
  set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
  set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY TRUE)
  set(CPACK_DEBIAN_PACKAGE_CONTROL_STRICT_PERMISSION TRUE)
  set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://github.com/RemmeVault/remprotocol")
endif()

include(CPack)
