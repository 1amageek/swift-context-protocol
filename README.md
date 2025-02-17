# swift-context-protocol

[![Swift Version](https://img.shields.io/badge/Swift-5.5%2B-blue.svg)](https://swift.org)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

_A distributed context protocol implementation for Swift._

swift-context-protocol provides a standardized distributed actor interface for working with tools, resources, and prompts in a distributed environment. Using Swift's distributed actor model and a WebSocket-based actor system, this package enables you to define and register various processing components—such as tools that perform operations, resources that can be read, and prompts that generate templated outputs—in a type-safe and scalable manner.

## Features

- **Distributed Context Protocol**  
  Define a common interface (`ContextProtocol`) for operations like ping, initialize, complete, set logging level, resource reading, tool calling, and prompt execution.
  
- **Tool, Resource, and Prompt Protocols**  
  Provide standardized protocols for:
  - **Tool**: Executes a specific operation using JSON schema validated inputs.
  - **Resource**: Represents a resource identified by a URI, supporting asynchronous read operations.
  - **Prompt**: Generates prompt templates or responses based on input parameters.

- **JSON Schema Support**  
  Input and output formats can be validated and described using JSONSchema.

- **Distributed Actors**  
  Leverages Swift’s new distributed actor model (with `WebSocketActorSystem`) to allow remote invocation of protocol methods.

- **Capability Negotiation & Initialization**  
  Exchange client and server information along with supported capabilities during the initialization handshake.

## Installation

Add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/1amageek/swift-context-protocol.git", from: "1.0.0")
]
```

Then add `"swift-context-protocol"` to your target dependencies.

## Usage

### Creating a Custom Tool

Implement the `Tool` protocol to create a custom tool. For example, here's a simple echo tool that returns the input string:

```swift
import Foundation
import JSONSchema
import ContextProtocol

/// A simple tool that echoes the provided input.
public struct EchoTool: Tool {
    
    public typealias Input = Envelop<String>
    public typealias Output = String
    
    public var name: String = "echo"
    public var description: String = "A tool that echoes the provided input."
    public var inputSchema: JSONSchema? = .string()
    
    public var guide: String? = """
    # Tool Name
    EchoTool
    
    ## Description
    This tool echoes back the input string provided to it.
    
    ## Parameters
    - `input`: The string to be echoed.
      - **Type**: `String`
      - **Description**: The input text that will be returned as output.
    
    ## Usage
    Provide a valid string as input.
    
    ## Example
    ```swift
    let input = "Hello, world!"
    // EchoTool returns: "Hello, world!"
    ```
    """
    
    public func run(_ input: Envelop<String>) async throws -> String {
        return input.data
    }
}
```

### Registering Components and Starting the Server

Create a distributed actor (e.g., `ContextActor`) that implements the `ContextProtocol` and registers your tools, resources, and prompts.

```swift
import Foundation
import Distributed
import WebSocketActors
import ContextProtocol

@main
struct Boot {
    
    static func main() async throws {
        let server = ContextServer()
        server.setTools([ EchoTool() ])
        try await server.start()
    }
}
```

### Connecting a Client

You can connect to the server using a client wrapper like `ContextClient`:

```swift
import Foundation
import Distributed
import ContextProtocol

@main
struct ClientBoot {
    static func main() async throws {
        let client = try await ContextClient.connectServer()
        let data = Envelop(data: "Hello, World!")
        let parameters = try JSONEncoder().encode(data)
        let toolResponse = try await client.session.callTool(
            name: "echo",
            parameters: parameters
        )
        print(toolResponse)
    }
}
```

During connection, the client performs an initialization handshake where it sends its information and capabilities and receives server details and instructions. A cool connection banner is printed on success.

## API Overview

### ContextProtocol

The distributed actor protocol defines methods for:

- **initialize**: Handshake with client info and capabilities.
- **ping**: Simple connectivity check.
- **complete**: Trigger completion logic.
- **setLoggingLevel**: Adjust logging level.
- **getPrompt**: Request a prompt.
- **listPrompts**: List available prompt templates.
- **listResources**: Retrieve a list of resources.
- **readResource**: Read resource content (returns a `ResourceContentData` enum).
- **subscribeResource / unsubscribeResource**: Manage resource subscriptions.
- **callTool**: Call a tool and receive its output as a `ResourceContentData` enum.
- **listTools**: Retrieve a list of tools.
- **sendRootsListChanged**: Notify changes in the root resource list.

### Domain Types

- **ServerInfo / ClientInfo**: Exchange basic identity and versioning information.
- **CapabilityConfig**: Key-value settings indicating supported capabilities.
- **ResourceContentData**: An enum (e.g., `.text(String)` or `.binary(Data)`) to represent resource contents.
- **ToolResponse / PromptResponse / ResourceResponse**: DTOs used to list available tools, prompts, and resources.
- **ListResponse\<T\>**: A generic wrapper for lists.

## Contributing

Contributions are welcome! Please open issues or pull requests on GitHub.

## License

This project is licensed under the MIT License.

