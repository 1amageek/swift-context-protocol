//
//  AnyPrompt.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//


import Foundation
import ContextProtocol

/// A type-erased prompt that conforms to the `Prompt` protocol.
/// It accepts a generic input and produces a generic output asynchronously.
public struct AnyPrompt<Input: Codable & Sendable, Output: Codable & Sendable & CustomStringConvertible>: Prompt {
    
    /// A unique name for the prompt.
    public let name: String
    
    /// An optional description of the prompt.
    public let description: String?
    
    /// A handler that generates a prompt string based on the provided input.
    public let handler: @Sendable (Input) async throws -> Output
    
    /// Creates a new instance of `AnyPrompt`.
    /// - Parameters:
    ///   - name: A unique name for the prompt.
    ///   - description: An optional description of the prompt.
    ///   - handler: A closure that defines how to generate the prompt.
    public init(
        name: String,
        description: String? = nil,
        handler: @escaping @Sendable (Input) async throws -> Output
    ) {
        self.name = name
        self.description = description
        self.handler = handler
    }
    
    /// Executes the prompt generation with the provided input.
    /// - Parameter input: The input required by the prompt.
    /// - Returns: The generated prompt string.
    public func run(_ input: Input) async throws -> Output {
        try await handler(input)
    }
    
    /// An optional helper method to generate the prompt as a `String`.
    public func generatePrompt(_ input: Input) async throws -> String {
        let result = try await run(input)
        return "\(result)"
    }
}
