//
//  Lemmy.swift
//  
//
//  Created by PEXAVC on 5/12/23.
//

import Foundation
import Combine

public class Lemmy {
    public let id: UUID
    
    static var shared: Lemmy? = nil
    
    private var api: Network
    private var pictrs: Network
    
    public init(id: UUID? = nil,
                apiUrl: String,
                pictrsUrl: String? = nil) {
        self.id = id ?? .init()
        self.api = .init(apiUrl)
        self.pictrs = .init(pictrsUrl ?? apiUrl + "/pictrs/image")
    }
    
    public func request<R: Request>(_ request: R) async -> R.TransformedResponse? {
        return try? await api.request(
            request
        ).async()
    }
    
    public func pictrs<R: Request>(_ request: R) async -> R.TransformedResponse? {
        return try? await pictrs.request(
            request
        ).async()
    }
    
    public static func request<R: Request>(_ request: R) async -> R.TransformedResponse? {
        guard let shared else { return nil }
        
        return await shared.request(request)
    }
    
    public static func pictrs<R: Request>(_ request: R) async -> R.TransformedResponse? {
        guard let shared else { return nil }
        
        return await shared.pictrs(request)
    }
}
