//
//  ToolResponse.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//


public struct ToolResponse: Identifiable, Codable, Sendable {
    public var name: String
    public var description: String
    public var inputSchema: JSONSchema?
    public var guide: String?
    public var id: String { name }
    
    public init(name: String, description: String, inputSchema: JSONSchema? = nil, guide: String? = nil) {
        self.name = name
        self.description = description
        self.inputSchema = inputSchema
        self.guide = guide
    }
}