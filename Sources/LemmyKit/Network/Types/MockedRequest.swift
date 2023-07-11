import Foundation

protocol AnyMockedRequest {
    
    var rawMockedResponse : Any { get }
    
}

protocol MockedRequest : Request {
    var mockedResponse : TransformedResponse { get }
}

extension MockedRequest {
    
    var rawMockedResponse : Any {
        mockedResponse
    }
    
}
