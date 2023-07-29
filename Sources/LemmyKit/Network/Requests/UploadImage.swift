//
//  UploadImage.swift
//  
//
//  Created by PEXAVC on 7/29/23.
//

import Foundation

public struct UploadImage: Request {
    public typealias Response = UploadImageResponse
    
    //Using pictrs network client in Lemmy.swift
    public var path: String { "" }
    public var method: RequestMethod { .post }
    
    public let mpForm: MultipartFormDataRequest.Model
    
    public let auth: String
    
    public init(
        image: Data,
        auth: String
    ) {
        self.mpForm = .init(mimeType: "image/png",//TODO: detect
                            fileName: "test.png",//not important
                            fileExtension: "png",//not important
                            fileData: image,//important
                            fieldName: "images[]",//important
                            auth: auth)
        self.auth = auth
    }
    
    public var multipartData: MultipartFormDataRequest.Model? {
        mpForm
    }
    
    public var customHeaders: [String : String] {
        ["Cookie" : "jwt=\(auth)"]
    }
}

public struct UploadImageResponse: Codable, Hashable {
    /**
     * Is "ok" if the upload was successful; is something else otherwise.
     */
    public let msg: String
    public let files: [ImageFile]
    //{pictrsURL}/ImageFile.file
    public let url: String?
    ///delete/${deleteToken}/${hash}
    //{pictrsURL}/delete/ImageFile.delete_token/ImageFile.file
    public let delete_url: String?
    
    public init(msg: String, files: [ImageFile], url: String?, delete_url: String?) {
        self.msg = msg
        self.files = files
        self.url = url
        self.delete_url = delete_url
    }
}

public struct ImageFile: Codable, Hashable {
    public let file: String
    public let delete_token: String
    
    public init(file: String, delete_token: String) {
        self.file = file
        self.delete_token = delete_token
    }
}
