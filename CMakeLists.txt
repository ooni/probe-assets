cmake_minimum_required(VERSION 3.1.0)
project(generic-assets LANGUAGES C)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules")
include(MkUtils)
MkDownloadMMDBDatabases()
MkDownloadCABundle()
set(VERSION 20181203)
execute_process(
  COMMAND ${CMAKE_COMMAND} -E tar cvzf "generic-assets-${VERSION}.tar.gz"
  "README.md" "asn.mmdb" "ca-bundle.pem" "country.mmdb"
  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  RESULT_VARIABLE TAR_FAILURE)
if("${TAR_FAILURE}")
  message(FATAL_ERROR "Cannot create generic assets archive")
endif()
