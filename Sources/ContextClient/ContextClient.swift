//
//  Client.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//


import Distributed
import WebSocketActors
import ContextProtocol
import Foundation

@main
struct Boot {
    
    static func main() async throws {

        do {
            let server = try await ContextClient.connectServer()
            let data = Envelop(data: "Hello, World!")
            let parameters = try JSONEncoder().encode(data)
            let toolResponse = try await server.session.callTool(
                name: "echo",
                parameters: parameters
            )
            print(toolResponse) // "Hello, World!"
        } catch {
            print("Error: \(error)")
        }
    }
}

public final class ContextClient: @unchecked Sendable {
    
    let address: ServerAddress
    
    var session: (any ContextProtocol)!
    
    public init(host: String = "127.0.0.1", port: Int = 8888) throws {
        self.address = ServerAddress(
            scheme: .insecure,
            host: host,
            port: port
        )
    }
    
    public func connect() async throws {
        let system = WebSocketActorSystem()
        try await system.connectClient(to: address)
        self.session = try $ContextProtocol.resolve(id: .client, using: system)
        
        let clientInfo = ClientInfo(name: "Context Client", version: "1.0")
        let capabilities: [String: CapabilityConfig] = [:]
        let initResponse = try await session.initialize(clientInfo: clientInfo,
                                                        capabilities: capabilities)
        print("""
            ══════════════════════════════════════════════════

             ✨ Server Connected ✨ 
             Server: \(initResponse.serverInfo.name) [\(initResponse.serverInfo.version)]     
             Instructions: \(initResponse.instructions ?? "None")  

            ══════════════════════════════════════════════════
            """)
    }
    
    public static func connectServer(host: String = "127.0.0.1", port: Int = 8888) async throws -> ContextClient {
        let client = try ContextClient(host: host, port: port)
        try await client.connect()
        return client
    }
}
