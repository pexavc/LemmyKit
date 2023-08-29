//
//  Lemmy+Auth.swift
//  
//
//  Created by PEXAVC on 8/23/23.
//

import Foundation

//MARK: -- Auth/Registration

public extension Lemmy {
    func login(username: String, password: String, token2FA: String? = nil) async -> String? {
        guard let result = try? await api.request(
            Login(username_or_email: username,
                  password: password,
                  totp_2fa_token: token2FA)
        ).async() else {
            return nil
        }
        
        if isBaseInstance {
            LemmyKit.auth = result.jwt
            
            //Update user info
            _ = await Lemmy.site(auth: result.jwt)
        } else {
            self.auth = result.jwt
            await site(auth: result.jwt)
        }
        
        return result.jwt
    }
    static func login(username: String, password: String, token2FA: String? = nil) async -> String? {
        guard let shared else { return nil }
        
        return await shared.login(username: username, password: password, token2FA: token2FA)
    }
    
    func register(username: String,
                  password: String,
                  password_verify: String,
                  show_nsfw: Bool,
                  email: String? = nil,
                  captcha_uuid: String? = nil,
                  captcha_answer: String? = nil,
                  honeypot: String? = nil,
                  answer: String? = nil
    ) async -> String? {
        guard let result = try? await api.request(
            Register(username: username,
                     password: password,
                     password_verify: password_verify,
                     show_nsfw: show_nsfw,
                     email: email,
                     captcha_uuid: captcha_uuid,
                     captcha_answer: captcha_answer,
                     honeypot: honeypot,
                     answer: answer
                    )
        ).async() else {
            return nil
        }
        
        if isBaseInstance {
            LemmyKit.auth = result.jwt
            
            //Update user info
            _ = await Lemmy.site(auth: result.jwt)
        } else {
            self.auth = result.jwt
            await site(auth: result.jwt)
        }
        
        return result.jwt
    }
    static func register(username: String,
                         password: String,
                         password_verify: String,
                         show_nsfw: Bool,
                         email: String? = nil,
                         captcha_uuid: String? = nil,
                         captcha_answer: String? = nil,
                         honeypot: String? = nil,
                         answer: String? = nil
    ) async -> String? {
        guard let shared else { return nil }
        
        return await shared.register(username: username,
                                     password: password,
                                     password_verify: password_verify,
                                     show_nsfw: show_nsfw,
                                     email: email,
                                     captcha_uuid: captcha_uuid,
                                     captcha_answer: captcha_answer,
                                     honeypot: honeypot,
                                     answer: answer)
    }
}
