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

//Getting all Local Communities
let communities = await Lemmy.communities(.local)

var debugCommunity: Community?
for community in communities {
    print("Community found: \(community.name)")
    if community.name == "debug" {
        debugCommunity = community
    }
}

guard let debugCommunity else {
    fatalError("Debug community not found")
}

//Getting posts for a specific community
let posts = await Lemmy.posts(debugCommunity)

for post in posts {
    print("Post found: \(post.name)")
}

//Getting comments from a post
let comments = await Lemmy.comments(posts.first)

for comment in comments {
    print("Comment found: \(comment.content)")
}
