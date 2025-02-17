//
//  Envelop.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//


public struct Envelop<T: Codable & Sendable>: Codable, Sendable {
    public var data: T
    public init(data: T) {
        self.data = data
    }
}