//
//  Greeter.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//

import Foundation
import Distributed
import WebSocketActors
import JSONSchema

public struct RequestOptions: Codable, Sendable {
    public var timeout: TimeInterval?
    public init(timeout: TimeInterval? = nil) {
        self.timeout = timeout
    }
}

@Resolvable
public protocol ContextProtocol: DistributedActor where Self.ActorSystem == WebSocketActorSystem {
    
    distributed func ping(option: RequestOptions?) -> String
    distributed func listTools(option: RequestOptions?) -> ListResponse<ToolResponse>
    distributed func callTool(name: String, parameters: Data, options: RequestOptions?) async throws -> String
}

extension ContextProtocol {
    public distributed func ping(option: RequestOptions? = nil) -> String {
        self.ping(option: option)
    }
    public distributed func listTools(option: RequestOptions? = nil) -> ListResponse<ToolResponse> {
        self.listTools(option: option)
    }
    public distributed func callTool(name: String, parameters: Data, options: RequestOptions? = nil) async throws -> String {
        try await self.callTool(name: name, parameters: parameters, options: options)
    }
}


extension NodeIdentity {
    public static let server = NodeIdentity(id: "server")
}

extension ActorIdentity {
    public static let client = ActorIdentity(id: "client", node: .server)
}

