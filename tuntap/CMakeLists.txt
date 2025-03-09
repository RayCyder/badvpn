set(TUNTAP_ADDITIONAL_SOURCES)
if (WIN32)
    list(APPEND TUNTAP_ADDITIONAL_SOURCES tapwin32-funcs.c)
endif ()

# Enable modules and ARC
set(CMAKE_XCODE_ATTRIBUTE_CLANG_ENABLE_MODULES YES)
set(CMAKE_XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES)
set(CMAKE_XCODE_ATTRIBUTE_DEFINES_MODULE YES)

# Add framework dependencies
find_library(NETWORK_EXTENSION NetworkExtension)
find_library(FOUNDATION Foundation)

# Add interface directory to include paths
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/../interface
)

set(TUNTAP_SOURCES
    BTap.m
    ${TUNTAP_ADDITIONAL_SOURCES}
)

# Add interface as a dependency and link frameworks
badvpn_add_library(tuntap "system;flow;interface" "" "${TUNTAP_SOURCES}")
target_link_libraries(tuntap ${NETWORK_EXTENSION} ${FOUNDATION})
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/../interface/TunnelInterface.h DESTINATION ${CMAKE_INSTALL_PREFIX}/include)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/../interface/TunnelInterface.m DESTINATION ${CMAKE_INSTALL_PREFIX}/src)