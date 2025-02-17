//
//  PromptResponse.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//


public struct PromptResponse: Identifiable, Codable, Sendable {
    public var name: String
    public var description: String
    public var parameters: JSONSchema?
    public var guide: String?
    public var id: String { name }
    
    public init(name: String, description: String, parameters: JSONSchema? = nil, guide: String? = nil) {
        self.name = name
        self.description = description
        self.parameters = parameters
        self.guide = guide
    }
}