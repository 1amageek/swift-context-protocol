//
//  ResourceResponse.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//


public struct ResourceResponse: Identifiable, Codable, Sendable {
    public var uri: String
    public var name: String
    public var description: String
    public var mimeType: String?
    public var id: String { "\(name):\(uri)" }
    
    public init(uri: String, name: String, description: String, mimeType: String? = nil) {
        self.uri = uri
        self.name = name
        self.description = description
        self.mimeType = mimeType
    }
}