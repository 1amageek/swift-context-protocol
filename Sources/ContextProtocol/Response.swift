//
//  Response.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//

import Foundation


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

public struct ListResponse<T: Identifiable & Codable & Sendable>: Codable, Sendable where T.ID: Sendable & Codable {
    public var results: [T]
    public var next: T.ID?
    
    public init(results: [T], next: T.ID? = nil) {
        self.results = results
        self.next = next
    }
}

extension ListResponse: CustomStringConvertible {
    public var description: String {
        return results.map { "\($0.id)" }.joined(separator: ", ")
    }
}

public struct Envelop<T: Codable & Sendable>: Codable, Sendable {
    public var data: T
    public init(data: T) {
        self.data = data
    }
}
