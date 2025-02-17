//
//  CapabilityConfig.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//


public struct CapabilityConfig: Codable, Sendable {
    public let settings: [String: String]
    public init(settings: [String: String]) {
        self.settings = settings
    }
}
