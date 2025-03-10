add_library(badvpn-tun2socks STATIC
    tun2socks.c
    SocksUdpGwClient.c
)
target_link_libraries(badvpn-tun2socks system flow tuntap lwip socksclient udpgw_client socks_udp_client)

install(
    TARGETS badvpn-tun2socks
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(
    FILES badvpn-tun2socks.8
    DESTINATION ${CMAKE_INSTALL_MANDIR}/man8
)
