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

        let server = try await ContextClient.connectServer()
        let data = Envelop(data: "Hello, World!")
        let parameters = try JSONEncoder().encode(data)
        let toolResponse = try await server.session.callTool(
            name: "echo",
            parameters: parameters
        )
        print(toolResponse)
        
        while true {
            try await Task.sleep(for: .seconds(1_000_000))
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
    }
    
    public static func connectServer(host: String = "127.0.0.1", port: Int = 8888) async throws -> ContextClient {
        let client = try ContextClient(host: host, port: port)
        try await client.connect()
        return client
    }
}
