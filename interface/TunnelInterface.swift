import Foundation
import NetworkExtension
import Darwin.POSIX

// Constants
private let TunnelMTU = 1500
private let kTunnelInterfaceErrorDomain = "com.oclemon.soVpn.TunnelInterface"
let kTun2SocksStoppedNotification = Notification.Name("kTun2SocksStoppedNotification")

class TunnelInterface: NSObject {
    // MARK: - Properties
    private var tunnelPacketFlow: NEPacketTunnelFlow?
    private var udpSession: [String: String] = [:]
    private var udpSocket: AnyObject?
    private var readFd: Int32 = 0
    private var writeFd: Int32 = 0
    
    // MARK: - Singleton
    static let shared = TunnelInterface()
    
    private override init() {
        super.init()
        // Runtime initialization of GCDAsyncUdpSocket
        if let socketClass = NSClassFromString("GCDAsyncUdpSocket") as? NSObject.Type {
            let queue = DispatchQueue(label: "udp")
            udpSocket = socketClass.init(delegate: self, delegateQueue: queue) as AnyObject
        }
    }
    
    // MARK: - Setup
    static func setup(with packetFlow: NEPacketTunnelFlow) -> Error? {
        guard packetFlow != nil else {
            return NSError(domain: kTunnelInterfaceErrorDomain,
                         code: 1,
                         userInfo: [NSLocalizedDescriptionKey: "PacketTunnelFlow can't be nil."])
        }
        
        shared.tunnelPacketFlow = packetFlow
        
        guard let udpSocket = shared.udpSocket else {
            return NSError(domain: kTunnelInterfaceErrorDomain,
                         code: 1,
                         userInfo: [NSLocalizedDescriptionKey: "UDP functionality not available"])
        }
        
        var error: NSError?
        if udpSocket.responds(to: #selector(bindToPort(_:error:))) {
            let _ = udpSocket.perform(#selector(bindToPort(_:error:)),
                                    with: 0,
                                    with: &error)
            if let error = error {
                return error
            }
        }
        
        var fds = [Int32](repeating: 0, count: 2)
        if pipe(&fds) < 0 {
            return NSError(domain: kTunnelInterfaceErrorDomain,
                         code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Unable to pipe."])
        }
        
        shared.readFd = fds[0]
        shared.writeFd = fds[1]
        return nil
    }
    
    // MARK: - Public Methods
    static func startTun2Socks(socksServerPort: Int, udp: Int) {
        Thread.detachNewThread {
            shared.startTun2Socks(socksServerPort: socksServerPort, udpPort: udp)
        }
    }
    
    static func stop() {
        stop_tun2socks()
    }
    
    static func writePacket(_ packet: Data) {
        DispatchQueue.main.async {
            shared.tunnelPacketFlow?.writePackets([packet], withProtocols: [NSNumber(value: AF_INET)])
        }
    }
    
    static func processPackets() {
        shared.tunnelPacketFlow?.readPackets { packets, protocols in
            for packet in packets {
                let data = packet.withUnsafeBytes { $0.bindMemory(to: UInt8.self) }
                let iphdr = data.baseAddress?.assumingMemoryBound(to: ip_hdr.self)
                let proto = IPH_PROTO(iphdr)
                
                if proto == IP_PROTO_UDP {
                    shared.handleUDPPacket(packet)
                } else if proto == IP_PROTO_TCP {
                    shared.handleTCPPacket(packet)
                }
            }
            processPackets()
        }
    }
    
    // MARK: - Private Methods
    private func startTun2Socks(socksServerPort: Int, udpPort: Int) {
        var socksServer = "127.0.0.1:\(socksServerPort)"
        var udpServer = "127.0.0.1:\(udpPort)"
        
        print("ss tcp: \(socksServer)")
        print("ss udp: \(udpServer)")
        
        #if TCP_DATA_LOG_ENABLE
        let logLevel = "debug"
        #else
        let logLevel = "none"
        #endif
        
        let argv: [String] = [
            "tun2socks",
            "--netif-ipaddr",
            "192.168.31.4",
            "--netif-netmask",
            "255.255.255.0",
            "--socks5-udp",
            "--loglevel",
            logLevel,
            "--socks-server-addr",
            socksServer
        ]
        
        // Convert argv to C-style arguments
        let cArgv = argv.map { strdup($0) }
        defer { cArgv.forEach { free($0) } }
        
        tun2socks_main(Int32(argv.count), cArgv, readFd, Int32(TunnelMTU))
        close(readFd)
        close(writeFd)
        
        NotificationCenter.default.post(name: kTun2SocksStoppedNotification, object: nil)
    }
    
    private func handleTCPPacket(_ packet: Data) {
        var message = [UInt8](repeating: 0, count: TunnelMTU + 2)
        packet.copyBytes(to: &message[2], count: packet.count)
        message[0] = UInt8(packet.count / 256)
        message[1] = UInt8(packet.count % 256)
        write(writeFd, &message, packet.count + 2)
    }
    
    private func handleUDPPacket(_ packet: Data) {
        // UDP packet handling logic here
        // This would need to be implemented based on your specific requirements
    }
    
    private func strForHost(_ host: Int, port: Int) -> String {
        return "\(host):\(port)"
    }
}

// MARK: - UDP Socket Delegate
extension TunnelInterface {
    @objc func udpSocket(_ sock: AnyObject, didReceiveData data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        // UDP receive handling logic here
        // This would need to be implemented based on your specific requirements
    }
} 