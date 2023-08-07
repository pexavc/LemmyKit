/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation
import Combine

public struct GetComments: Request {
	public typealias Response = GetCommentsResponse

	public var path: String { "/comment/list" }
	public var method: RequestMethod { .get }

	public let type_: ListingType?
	public let sort: CommentSortType?
	public let max_depth: Int?
	public let page: Int?
	public let limit: Int?
	public let community_id: CommunityId?
	public let community_name: String?
	public let post_id: PostId?
	public let parent_id: CommentId?
	public let saved_only: Bool?
	public let auth: String?
    
    public let location: FetchType

	public init(
		type_: ListingType? = nil,
		sort: CommentSortType? = nil,
		max_depth: Int? = nil,
		page: Int? = nil,
		limit: Int? = nil,
		community_id: CommunityId? = nil,
		community_name: String? = nil,
		post_id: PostId? = nil,
		parent_id: CommentId? = nil,
		saved_only: Bool? = nil,
		auth: String? = nil,
        location: FetchType = .base
	) {
		self.type_ = type_
		self.sort = sort
		self.max_depth = max_depth
		self.page = page
		self.limit = limit
		self.community_id = community_id
		self.community_name = community_name
		self.post_id = post_id
		self.parent_id = parent_id
		self.saved_only = saved_only
		self.auth = auth
        self.location = location
	}
    
    public func transform(_ publisher: AnyPublisher<GetCommentsResponse, Error>) throws -> AnyPublisher<GetCommentsResponse, Error> {
        guard location != .base else {
            return publisher
        }
        
        return publisher
            .map { response in
                var newComments: [CommentView] = []
                for comment in response.comments {
                    var newComment = comment
                    newComment.update(location: location)
                    newComments.append(newComment)
                }
                return GetCommentsResponse(comments: newComments)
            }.eraseToAnyPublisher()
    }
    
    enum CodingKeys: CodingKey {
        case type_, sort, max_depth, page, limit, community_id, community_name, post_id, parent_id, saved_only, auth
    }
}

public struct GetCommentsResponse: Codable, Hashable {
	public let comments: [CommentView]

	public init(
		comments: [CommentView]
	) {
		self.comments = comments
	}
}
