# add_executable(badvpn-tun2socks
#     tun2socks.c
#     SocksUdpGwClient.c
# )
# target_link_libraries(badvpn-tun2socks system flow tuntap lwip socksclient udpgw_client)

# install(
#     TARGETS badvpn-tun2socks
#     RUNTIME DESTINATION bin
#     BUNDLE DESTINATION Applications
# )

# install(
#     FILES badvpn-tun2socks.8
#     DESTINATION share/man/man8
# )

add_library(badvpn-tun2socks STATIC
    tun2socks.c
    SocksUdpGwClient.c
)
target_link_libraries(badvpn-tun2socks system flow tuntap lwip socksclient udpgw_client socks_udp_client)

install(
    TARGETS badvpn-tun2socks
    RUNTIME DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
install(
    FILES tun2socks.h
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/tun2socks
)