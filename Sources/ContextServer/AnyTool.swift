//
//  AnyTool.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//

import Foundation
import ContextProtocol
import JSONSchema

public struct AnyTool<Input: Codable & Sendable, Output: Codable & Sendable & CustomStringConvertible>: Tool {

    public var id: String { name }
    
    public var name: String
    
    public var description: String
    
    public var inputSchema: JSONSchema?
    
    public var guide: String?
    
    public var handler: @Sendable (Input) async throws -> Output
    
    public init(
        name: String,
        description: String,
        inputSchema: JSONSchema?,
        guide: String? = nil,
        handler: @escaping @Sendable (Input) async throws -> Output) {
            self.name = name
            self.description = description
            self.inputSchema = inputSchema
            self.guide = guide
            self.handler = handler
        }
    
    public func run(_ input: Input) async throws -> Output {
        try await self.handler(input)
    }
}
