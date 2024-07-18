/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation
import Combine

public struct GetPersonDetails: Request {
	public typealias Response = GetPersonDetailsResponse

	public var path: String { "/user" }
	public var method: RequestMethod { .get }

	public let person_id: PersonId?
	public let username: String?
	public let sort: SortType?
	public let page: Int?
	public let limit: Int?
	public let community_id: CommunityId?
	public let saved_only: Bool?
	public let auth: String?
    
    public let location: FetchType

	public init(
		person_id: PersonId? = nil,
		username: String? = nil,
		sort: SortType? = nil,
		page: Int? = nil,
		limit: Int? = nil,
		community_id: CommunityId? = nil,
		saved_only: Bool? = nil,
		auth: String? = nil,
        location: FetchType = .base
	) {
		self.person_id = person_id
		self.username = username
		self.sort = sort
		self.page = page
		self.limit = limit
		self.community_id = community_id
		self.saved_only = saved_only
		self.auth = auth
        self.location = location
	}
    
    public func transform(_ publisher: AnyPublisher<GetPersonDetailsResponse, Error>) throws -> AnyPublisher<GetPersonDetailsResponse, Error> {
        return publisher
            .map { response in
                var newPosts: [PostView] = []
                var newComments: [CommentView] = []
                
                for post in response.posts {
                    var newPost = post
                    newPost.update(location: self.location)
                    //newPost.community.ap_id = newPost.post.ap_id //TODO: ruh roh
                    newPosts.append(newPost)
                }
                
                for comment in response.comments {
                    var newComment = comment
                    newComment.update(location: location)
                    newComments.append(newComment)
                }
                
                return .init(person_view: response.person_view, comments: newComments, posts: newPosts, moderates: response.moderates)
            }.eraseToAnyPublisher()
    }
    
    enum CodingKeys: CodingKey {
        case person_id, username, sort, page, limit, community_id, saved_only, auth
    }
}

public struct GetPersonDetailsResponse: Codable, Hashable {
	public let person_view: PersonView
	public let comments: [CommentView]
	public let posts: [PostView]
	public let moderates: [CommunityModeratorView]

	public init(
		person_view: PersonView,
		comments: [CommentView],
		posts: [PostView],
		moderates: [CommunityModeratorView]
	) {
		self.person_view = person_view
		self.comments = comments
		self.posts = posts
		self.moderates = moderates
	}
}
