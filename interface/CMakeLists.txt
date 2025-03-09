set(CMAKE_XCODE_ATTRIBUTE_CLANG_ENABLE_MODULES YES)
#set(CMAKE_XCODE_ATTRIBUTE_ENABLE_SWIFT YES)
set(CMAKE_XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES)  # Ensure ARC is enabled for Objective-C
#set(CMAKE_SWIFT_VERSION 5.0)

# Add framework search paths
#set(CMAKE_XCODE_ATTRIBUTE_FRAMEWORK_SEARCH_PATHS "$(inherited) $(SRCROOT)/../Pods/CocoaAsyncSocket")

set(INTERFACE_SOURCES
    TunnelInterface.m
    #TunnelInterface.swift
)

set(INTERFACE_HEADERS
    # Any public headers if needed
   # PacketProcessor.h
    TunnelInterface.h
)

badvpn_add_library(interface "" "" "${INTERFACE_SOURCES}")
# Create the library target
#add_library(interface STATIC ${INTERFACE_SOURCES})

# Set Swift compilation flags
set_target_properties(interface PROPERTIES
    SWIFT_VERSION 5.0
    XCODE_ATTRIBUTE_SWIFT_VERSION 5.0
    XCODE_ATTRIBUTE_CLANG_ENABLE_MODULES YES
)

# Optional: Link against CocoaAsyncSocket if available
find_library(COCOAASYNCSOCKET_FRAMEWORK CocoaAsyncSocket)
if(COCOAASYNCSOCKET_FRAMEWORK)
    target_link_libraries(interface ${COCOAASYNCSOCKET_FRAMEWORK})
endif()

# Link against required frameworks
target_link_libraries(interface
    "-framework Foundation"
    "-framework NetworkExtension"
    "-framework SystemConfiguration"
)

# Install targets
install(TARGETS interface DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
if(INTERFACE_HEADERS)
    install(FILES ${INTERFACE_HEADERS} DESTINATION ${CMAKE_INSTALL_PREFIX}/include)
endif()