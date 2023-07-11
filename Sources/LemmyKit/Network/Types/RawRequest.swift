import Foundation
import Combine

public protocol RawRequest : Encodable {
    associatedtype Response : Codable //TODO: rename to IntermediateResponse
    associatedtype TransformedResponse : Codable //TODO: rename to Response
    
    var ignoresEndpoint : Bool { get }
    var ignoresAuthHeader : Bool { get }
    var ignoresPercentEncoding : Bool { get }
    var path : String { get }
    var method : RequestMethod { get }
    var data : [String : Any] { get }
    var dateFormatter : DateFormatter { get }
    var customHeaders : [String : String] { get }
    var customQueries : [String : String] { get }

    func transform(_ publisher : AnyPublisher<Response, Error>) throws -> AnyPublisher<TransformedResponse, Error>
}

public extension RawRequest {
    
    var ignoresEndpoint : Bool {
        false
    }
    
    var ignoresAuthHeader : Bool {
        false
    }
    
    var ignoresPercentEncoding : Bool {
        false
    }
    
    var data : [String : Any] {
        let coder = DictionaryEncoder()
        return (try? coder.encode(self)) ?? [:]
    }
    
    var dateFormatter: DateFormatter {
        .init()
    }
    
    var customHeaders: [String : String] {
        [:]
    }
    
    var customQueries: [String : String] {
        [:]
    }
}

public extension RawRequest where TransformedResponse == Response {
    
    func transform(_ publisher : AnyPublisher<Response, Error>) throws -> AnyPublisher<TransformedResponse, Error> {
        publisher
    }
    
}

