

//#import "TunnelInterface.h"
#import <netinet/ip.h>
#import "ipv4/lwip/ip4.h"
#import "lwip/udp.h"
#import "lwip/ip.h"
#import <arpa/inet.h>
#import "inet_chksum.h"
#import "tun2socks/tun2socks.h"
#import <objc/runtime.h>

typedef enum : int {
    udp,
    udpv6
    tcp
    tcpv6,
    udplite,
    udplitev6,
    icmp,
    icmpv6,
    igmp,
    igmpv6
} package_protocol;

#define IP_PROTO_ICMP    1
#define IP_PROTO_IGMP    2
#define IP_PROTO_UDP     17
#define IP_PROTO_UDPLITE 136
#define IP_PROTO_TCP     6


package_protocol deal_package(uint8_t *data)
{
    
//    for (NSData *packet in packets) {
//        uint8_t *data = (uint8_t *)packet.bytes;
        struct ip_hdr *iphdr = (struct ip_hdr *)data;
        //ip_addr_p_t
        uint8_t proto = IPH_PROTO(iphdr);
        if (proto == IP_PROTO_UDP) {//not work since udp package too large
            //print ip
//            {
//                uint8_t *data = (uint8_t *)packet.bytes;
//                int data_len = (int)packet.length;
//                struct ip_hdr *iphdr = (struct ip_hdr *)data;
//                uint8_t version = IPH_V(iphdr);
//
//                switch (version) {
//                    case 4: {
//                        uint16_t iphdr_hlen = IPH_HL(iphdr) * 4;
//                        data = data + iphdr_hlen;
//                        data_len -= iphdr_hlen;
//                        struct udp_hdr *udphdr = (struct udp_hdr *)data;
//                        struct in_addr dest = { iphdr->dest.addr };
//                        struct in_addr src = { iphdr->src.addr };
//                        NSString *destHost = [NSString stringWithUTF8String:inet_ntoa(dest)];
//                        NSString *srcHost = [NSString stringWithUTF8String:inet_ntoa(src)];
//                        
//                        NSLog(@"udp:%@:%d->%@:%d",srcHost,ntohs(udphdr->src),destHost,ntohs(udphdr->dest));
//                    } break;
//                    case 6: {
//                        
//                    } break;
//                }
//            }

           [[TunnelInterface sharedInterface] handleUDPPacket:packet]; //udp采用tcp的方式发送；
       }
        else
            if (proto == IP_PROTO_UDP) {
            [[TunnelInterface sharedInterface] handleUDPPacket:packet];
        }else if (proto == IP_PROTO_TCP) {
            [[TunnelInterface sharedInterface] handleTCPPPacket:packet];
        }
//    }
}
