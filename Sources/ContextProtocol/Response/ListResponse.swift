//
//  ListResponse.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//


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