//
//  LoggingLevel.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//


public enum LoggingLevel: String, Codable, Sendable {
    case debug
    case info
    case notice
    case warning
    case error
    case critical
    case alert
    case emergency
}
