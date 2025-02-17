//
//  InitializeResponse.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//


public struct InitializeResponse: Codable, Sendable {
    public let protocolVersion: String
    public let serverInfo: ServerInfo
    public let capabilities: [String: CapabilityConfig]
    public let instructions: String?
    public init(
        protocolVersion: String,
        serverInfo: ServerInfo,
        capabilities: [String: CapabilityConfig],
        instructions: String? = nil
    ) {
        self.protocolVersion = protocolVersion
        self.serverInfo = serverInfo
        self.capabilities = capabilities
        self.instructions = instructions
    }
}
