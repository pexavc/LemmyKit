//
//  Lemmy+Content.swift
//  
//
//  Created by PEXAVC on 8/23/23.
//

import Foundation

//MARK: -- Upload Image

public extension Lemmy {
    func uploadImage(_ imageData: Data,
                     auth: String?) async -> UploadImageResponse? {
        let validAuth: String? = auth ?? self.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        guard let result = try? await pictrs.request(
            UploadImage(image: imageData, auth: validAuth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func uploadImage(_ imageData: Data, auth: String? = nil) async -> UploadImageResponse? {
        guard let shared else { return nil }
        
        return await shared.uploadImage(imageData, auth: auth)
    }
    
    func deleteImage(_ imageFile: ImageFile,
                     auth: String?) async -> EmptyResponse? {
        let validAuth: String? = auth ?? self.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        guard let result = try? await pictrs.request(
            DeleteImage(file: imageFile.file,
                        deleteToken: imageFile.delete_token,
                        auth: validAuth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func deleteImage(_ imageFile: ImageFile,
                            auth: String? = nil) async -> EmptyResponse? {
        guard let shared else { return nil }
        
        return await shared.deleteImage(imageFile, auth: auth)
    }
}

public extension Lemmy {
    func captcha(auth: String? = nil) async -> GetCaptchaResponse? {
        guard let result = try? await api.request(
            GetCaptcha(auth: auth ?? self.auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func captcha(auth: String? = nil) async -> GetCaptchaResponse? {
        guard let shared else { return nil }
        
        return await shared.captcha(auth: auth)
    }
}

//MARK: -- Resolve
//WORK IN PROGRESS
public extension Lemmy {
    func resolve(_ resource: ResourceType,
                 auth: String) async -> ResourceType? {
        let q: String
        
        switch resource {
        case .post(let model):
            q = model.post.ap_id
        default:
            q = ""
        }
        
        LemmyLog(q, logLevel: .debug)
        
        guard let result = try? await api.request(
            ResolveObject(q: q, auth: auth)
        ).async() else {
            LemmyLog("failed", logLevel: .error)
            return nil
        }
        
        switch resource {
        case .post:
            guard let model = result.post else { return nil }
            LemmyLog("resolved: \(model.post.id)", logLevel: .debug)
            return .post(model)
        case .comment:
            guard let model = result.comment else { return nil }
            return .comment(model)
        case .creator:
            guard let model = result.person else { return nil }
            LemmyLog("resolved: \(model.person.id)", logLevel: .debug)
            return .creator(model)
        case .community:
            guard let model = result.community else { return nil }
            return .community(model)
        }
    }
    static func resolve(_ object: ResourceType,
                        auth: String? = nil) async -> ResourceType? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.resolve(object, auth: validAuth)
    }
    
    func resolveURL(_ q: String,
                    auth: String) async -> ResolveObject.Response? {
        
        guard let result = try? await api.request(
            ResolveObject(q: q, auth: auth)
        ).async() else {
            LemmyLog("failed", logLevel: .error)
            return nil
        }
        
        return result
    }
    static func resolveURL(_ q: String,
                           auth: String? = nil) async -> ResolveObject.Response? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.resolveURL(q, auth: validAuth)
    }
}

//MARK: Ping
public extension Lemmy {
    func ping(_ host: String? = nil) async -> (isUp: Bool, time: TimeInterval)? {
        //LemmyLog(host ?? baseURL, logLevel: .debug)
        if let url = URL(string: host ?? baseURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            
            let time = DispatchTime.now().uptimeNanoseconds
            
            let data = try? await URLSession.shared.data(for: request)
            
            let elapsed = DispatchTime.now().uptimeNanoseconds - time
            let totalTime = TimeInterval(elapsed)/1e9
            
            guard let data,
                  let response = data.1 as? HTTPURLResponse else {
                return (false, totalTime)
            }
            
            switch response.statusCode {
            case 200:
                return (true, totalTime)
            default:
                return (false, totalTime)
            }
        } else {
            return nil
        }
    }
    static func ping(_ host: String? = nil) async -> (isUp: Bool, time: CFAbsoluteTime)? {
        return await shared?.ping(host)
    }
}
