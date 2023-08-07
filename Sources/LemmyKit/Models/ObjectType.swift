//
//  File.swift
//  
//
//  Created by Ritesh Pakala on 8/7/23.
//

import Foundation

public enum ResourceType: CustomStringConvertible {
    case post(PostView)
    case comment(CommentView)
    case creator(PersonView)
    case community(CommunityView)
    
    public var description: String {
        switch self {
        case .post: return "post"
        case .comment: return "comment"
        case .creator(_): return "creator"
        case .community(_): return "community"
        }
    }
}
