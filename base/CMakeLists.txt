set(BASE_ADDITIONAL_SOURCES)
set(CMAKE_XCODE_ATTRIBUTE_CLANG_ENABLE_MODULES YES)
#set(CMAKE_XCODE_ATTRIBUTE_ENABLE_SWIFT YES)
set(CMAKE_XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES)  # Ensure ARC is enabled for Objective-C
#set(CMAKE_SWIFT_VERSION 5.0)
if (HAVE_SYSLOG_H)
    list(APPEND BASE_ADDITIONAL_SOURCES BLog_syslog.c)
endif ()

set(BASE_SOURCES
    DebugObject.c
    BLog.m
    BPending.c
    ${BASE_ADDITIONAL_SOURCES}
)
badvpn_add_library(base "" "" "${BASE_SOURCES}")
target_link_libraries(base
    "-framework Foundation"
)
