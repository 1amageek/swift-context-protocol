//
//  ResourceContentData.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//

import Foundation

public enum ResourceContentData: Codable, Sendable, CustomStringConvertible {
    case text(String)
    case binary(Data)
    
    private enum CodingKeys: String, CodingKey {
        case type, value
    }
    
    private enum ContentType: String, Codable {
        case text
        case binary
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ContentType.self, forKey: .type)
        switch type {
        case .text:
            let value = try container.decode(String.self, forKey: .value)
            self = .text(value)
        case .binary:
            let value = try container.decode(Data.self, forKey: .value)
            self = .binary(value)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let text):
            try container.encode(ContentType.text, forKey: .type)
            try container.encode(text, forKey: .value)
        case .binary(let data):
            try container.encode(ContentType.binary, forKey: .type)
            try container.encode(data, forKey: .value)
        }
    }
}

extension ResourceContentData {
    public var description: String {
        switch self {
        case .text(let text):
            return text
        case .binary(let data):
            return data.base64EncodedString()
        }
    }
}
