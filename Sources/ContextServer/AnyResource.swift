//
//  AnyResource.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//


import Foundation
import ContextProtocol
import JSONSchema

/// A type-erased resource that conforms to the `Resource` protocol.
/// It accepts a generic input and produces a generic output asynchronously.
public struct AnyResource<Input: Codable & Sendable, Output: Codable & Sendable & CustomStringConvertible>: Resource {
    
    /// A unique name for the resource.
    public let name: String
    
    /// The URI that identifies the resource.
    public let uri: URL
    
    /// An optional description of the resource.
    public let description: String?
    
    /// A handler that performs the resource’s operation.
    public let handler: @Sendable (Input) async throws -> Output
    
    /// Creates a new instance of `AnyResource`.
    /// - Parameters:
    ///   - name: A unique name for the resource.
    ///   - uri: The URI that identifies the resource.
    ///   - description: An optional description of the resource.
    ///   - handler: A closure that defines the resource's behavior.
    public init(
        name: String,
        uri: URL,
        description: String? = nil,
        handler: @escaping @Sendable (Input) async throws -> Output
    ) {
        self.name = name
        self.uri = uri
        self.description = description
        self.handler = handler
    }
    
    /// Executes the resource operation with the provided input.
    /// - Parameter input: The input required by the resource.
    /// - Returns: The output produced by the resource.
    public func run(_ input: Input) async throws -> Output {
        try await handler(input)
    }
    
    /// An optional helper method to read the resource.
    /// This can be used as a convenience wrapper around `run`.
    public func read(_ input: Input) async throws -> String {
        let result = try await run(input)
        return "\(result)"
    }
}
