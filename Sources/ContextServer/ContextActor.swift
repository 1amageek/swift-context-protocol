//
//  Greeter.swift
//  swift-context-protocol
//
//  Created by Norikazu Muramoto on 2025/02/17.
//

import Foundation
import Distributed
import WebSocketActors
import ContextProtocol
import JSONSchema


/// A simple tool that echoes the provided input.
public struct EchoTool: Tool {
    
    public typealias Input = Envelop<String>
    
    public typealias Output = String
    
    public var name: String = "echo"
    
    public var description: String = "A tool that echoes the provided input."
    
    // Here we define the JSON schema for the input.
    // In this example, we expect a string.
    public var inputSchema: JSONSchema? = .string()
    
    // Optional guide with detailed instructions on how to use this tool.
    public var guide: String? = """
    # Tool Name
    EchoTool
    
    ## Description
    This tool echoes back the input string provided to it.
    
    ## Parameters
    - `input`: The string to be echoed.
      - **Type**: `String`
      - **Description**: The input text that will be returned as output.
      - **Requirements**: Must be a valid, non-null string.
    
    ## Usage
    - Provide a valid string as input.
    - The tool will return the same string as output.
    
    ## Examples
    ### Basic Usage
    ```swift
    let input = "Hello, world!"
    // EchoTool will output: "Hello, world!"
    ```
    """
    
    /// Executes the echo operation by returning the input as the output.
    /// - Parameter input: The string to echo.
    /// - Returns: The same input string.
    public func run(_ input: Envelop<String>) async throws -> String {
        return input.data
    }
}



public distributed actor ContextActor {
    
    public typealias ActorSystem = WebSocketActorSystem
    
    private var tools: [String: any Tool] = [:]
    
    private var resources: [String: any Resource] = [:]
    
    private var prompts: [String: any Prompt] = [:]
    
    public init(actorSystem: ActorSystem, tools: [any Tool] = [], resources: [any Resource] = [], prompts: [any Prompt] = []) {
        self.actorSystem = actorSystem
        self.tools = tools.reduce(into: [:]) { $0[$1.name] = $1 }
        self.resources = resources.reduce(into: [:]) { $0[$1.name] = $1 }
        self.prompts = prompts.reduce(into: [:]) { $0[$1.name] = $1 }
    }
    
    // MARK: - Registration
    
    /// Tool を登録します。既に同じ名前の Tool が登録されている場合はエラーとします。
    public func register(tool: any Tool) {
        guard tools[tool.name] == nil else {
            fatalError("Tool '\(tool.name)' is already registered")
        }
        tools[tool.name] = tool
    }
    
    /// Resource を登録します。既に同じ名前の Resource が登録されている場合はエラーとします。
    public func register(resource: any Resource) {
        guard resources[resource.name] == nil else {
            fatalError("Resource '\(resource.name)' is already registered")
        }
        resources[resource.name] = resource
    }
    
    /// Prompt を登録します。既に同じ名前の Prompt が登録されている場合はエラーとします。
    public func register(prompt: any Prompt) {
        guard prompts[prompt.name] == nil else {
            fatalError("Prompt '\(prompt.name)' is already registered")
        }
        prompts[prompt.name] = prompt
    }
    
    // MARK: - Retrieval
    
    /// 名前から登録された Tool を取得します。
    public func tool(named name: String) -> (any Tool)? {
        return tools[name]
    }
    
    /// 名前から登録された Resource を取得します。
    public func resource(named name: String) -> (any Resource)? {
        return resources[name]
    }
    
    /// 名前から登録された Prompt を取得します。
    public func prompt(named name: String) -> (any Prompt)? {
        return prompts[name]
    }
    
    // MARK: - Listing
    
    /// 登録されている全 Tool を配列で返します。
    public var allTools: [any Tool] {
        return Array(tools.values)
    }
    
    /// 登録されている全 Resource を配列で返します。
    public var allResources: [any Resource] {
        return Array(resources.values)
    }
    
    /// 登録されている全 Prompt を配列で返します。
    public var allPrompts: [any Prompt] {
        return Array(prompts.values)
    }
}

extension ContextActor: ContextProtocol {
    
    public distributed func listTools(option: RequestOptions?) -> ListResponse<ToolResponse> {
        let tools = self.tools.map { (name, tool) in
            return ToolResponse(
                name: tool.name,
                description: tool.description,
                inputSchema: tool.inputSchema,
                guide: tool.guide
            )
        }
        return .init(results: tools)
    }
    
    public distributed func callTool(name: String, parameters: Data, options: RequestOptions?) async throws -> String {
        guard let tool = self.tools[name] else {
            return "Tool \(name) not found"
        }
        do {
            let result = try await tool.call(data: parameters)
            return result
        } catch {
            print(error)
            return "error"
        }
    }
    
    public distributed func ping(option: RequestOptions?) -> String {
        return "pong"
    }
}

