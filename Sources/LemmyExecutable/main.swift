//
//  main.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation
import LemmyKit

//Initializing a global Lemmy client with a baseURL
LemmyKit.baseUrl = "https://lemmy.world"

//Setting authentication with a login
//LemmyKit.auth = await Lemmy.login(username: "pexavc",
//                                  password: "...")


let time = CFAbsoluteTimeGetCurrent()
let instances = await Lemmy.getInstances()
print("\(CFAbsoluteTimeGetCurrent() - time)s to get all instances")


////Getting a specific community
//let communityView = await Lemmy.community(46)
//
//guard let communityView else {
//    fatalError("No community found")
//}
//
//let posts = await Lemmy.posts(type: .all,
//                              page: 3,
//                              sort: .active)
//
//let firstFederatedPost = posts.first(where: { $0.community.local == false })

//print("Fetching federated community from \(posts.count) posts : \(firstFederatedPost?.community)")

//Example federated community of lemmy.world has id: 13, "memes" community
let communityView = await Lemmy.community(13)

let federatedPosts = await Lemmy.posts(communityView?.community,
                                       type: .all,
                                       page: 3,
                                       sort: .active)
print("Fetched \(federatedPosts.count) federated posts from: \(communityView?.community.name)")

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
