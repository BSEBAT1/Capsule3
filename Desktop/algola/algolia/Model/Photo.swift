import Foundation

public struct Photo: Codable, Equatable {

    public let url: String

    public init(url: String) {
        self.url = url
    }
}
