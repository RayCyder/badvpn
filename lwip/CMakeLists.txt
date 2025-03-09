set(LWIP_SOURCES
    src/core/udp.c
    src/core/memp.c
    src/core/init.c
    src/core/pbuf.c
    src/core/tcp.c
    src/core/tcp_out.c
    # src/core/sys.c
    src/core/netif.c
    src/core/def.c
    src/core/mem.c
    src/core/tcp_in.c
    src/core/stats.c
    # src/core/ip.c
    # src/core/timeouts.c
    src/core/inet_chksum.c
    src/core/ipv4/icmp.c
    src/core/ipv4/ip4.c
    src/core/ipv4/ip4_addr.c
    # src/core/ipv4/ip4_frag.c
    src/core/ipv6/ip6.c
    src/core/ipv6/nd6.c
    src/core/ipv6/icmp6.c
    src/core/ipv6/ip6_addr.c
    src/core/ipv6/ip6_frag.c
    src/core/ipv6/inet6.c
    src/core/ipv6/mld6.c
    custom/sys.c
)
badvpn_add_library(lwip "system" "" "${LWIP_SOURCES}")

target_compile_definitions(lwip PRIVATE 
    LWIP_NETIF_HWADDRHINT=1
    LWIP_DONT_PROVIDE_BYTEORDER_FUNCTIONS
    # Add these to rename the conflicting structs
    ip6_hdr=lwip_ip6_hdr
    icmp6_hdr=lwip_icmp6_hdr
)

add_definitions(
    -DLWIP_IPV6=1
    -DLWIP_IPV6_FORWARD=0
    -DLWIP_IPV6_FRAG=1
    -DLWIP_ICMP6=1
)
