import Foundation

struct ErrorResponse: Codable {
    var correlationId: String
    var statusCode: Int
    var message: String
}
