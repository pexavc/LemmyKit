//
//  main.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation
import LemmyKit

//Initializing a global Lemmy client with a baseURL
LemmyKit.baseUrl = "https://neatia.xyz"

//Setting authentication with a login
LemmyKit.auth = await Lemmy.login(username: "pexavc",
                                  password: "...")

//Getting a specific community
let community = await Lemmy.community(name: "debug")


////Posting to a community
//let post = await Lemmy.createPost("[DEBUG] From LemmyKit",
//                                  content: "Hello World",
//                                  community: debugCommunity)
//
//guard let post else {
//    fatalError("Failed to post")
//}
//
////Commenting on a post
//let comment = await Lemmy.createComment("Test comment", post: post)
//
//guard let comment else {
//    fatalError("Failed to comment")
//}
//
////Replying to a comment
//await Lemmy.createComment("Reply to a comment",
//                          post: post,
//                          parent: comment)
