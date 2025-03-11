set(TUNTAP_ADDITIONAL_SOURCES)
set(CMAKE_XCODE_ATTRIBUTE_CLANG_ENABLE_MODULES YES)
#set(CMAKE_XCODE_ATTRIBUTE_ENABLE_SWIFT YES)
set(CMAKE_XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES)  # Ensure ARC is enabled for Objective-C
#set(CMAKE_SWIFT_VERSION 5.0)
if (WIN32)
    list(APPEND TUNTAP_ADDITIONAL_SOURCES tapwin32-funcs.c)
endif ()

set(TUNTAP_SOURCES
    BTap.m
    ${TUNTAP_ADDITIONAL_SOURCES}
)
badvpn_add_library(tuntap "system;flow" "" "${TUNTAP_SOURCES}")

target_link_libraries(tuntap
    "-framework Foundation"
    "-framework NetworkExtension"
    "-framework SystemConfiguration"
)
