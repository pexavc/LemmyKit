//
//  DeleteImage.swift
//  
//
//  Created by PEXAVC on 7/29/23.
//

import Foundation

public struct DeleteImage: Request {
    public typealias Response = EmptyResponse
    
    //Using pictrs network client in Lemmy.swift
    public var path: String { "/delete/\(deleteToken)/\(file)" }
    public var method: RequestMethod { .get }
    
    public let file: String
    public let deleteToken: String
    public let auth: String
    
    public init(
        file: String,
        deleteToken: String,
        auth: String
    ) {
        self.file = file
        self.deleteToken = deleteToken
        self.auth = auth
    }
    
    public var customHeaders: [String : String] {
        ["Cookie" : "jwt=\(auth)"]
    }
}

public struct DeleteImageResponse: Codable, Hashable {
    public let msg: String
    
    public init(msg: String) {
        self.msg = msg
    }
}
