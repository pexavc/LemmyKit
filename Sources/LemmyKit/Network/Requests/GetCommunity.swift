/* auto transpiled from lemmy-js-client (https://github.com/LemmyNet/lemmy-js-client) */

import Foundation
import Combine

public struct GetCommunity: Request {
	public typealias Response = GetCommunityResponse

	public var path: String { "/community" }
	public var method: RequestMethod { .get }

	public let id: CommunityId?
	public let name: String?
	public let auth: String?
    
    public var location: FetchType
    
	public init(
		id: CommunityId? = nil,
		name: String? = nil,
		auth: String? = nil,
        location: FetchType = .base
	) {
		self.id = id
		self.name = name
		self.auth = auth
        self.location = location
	}
    
    public func transform(_ publisher: AnyPublisher<GetCommunityResponse, Error>) throws -> AnyPublisher<GetCommunityResponse, Error> {
        guard location != .base else {
            return publisher
        }
        
        return publisher
            .map { response in
                var mutable = response.community_view
                mutable.community?.location = location
                return GetCommunityResponse(community_view: mutable, moderators: response.moderators, discussion_languages: response.discussion_languages)
            }.eraseToAnyPublisher()
    }
    
    enum CodingKeys: CodingKey {
        case id, name, auth
    }
}

public struct GetCommunityResponse: Codable, Hashable {
	public var community_view: CommunityView
	public let site: Site?
	public let moderators: [CommunityModeratorView]
	public let discussion_languages: [LanguageId]

	public init(
		community_view: CommunityView,
		site: Site? = nil,
		moderators: [CommunityModeratorView],
		discussion_languages: [LanguageId]
	) {
		self.community_view = community_view
		self.site = site
		self.moderators = moderators
		self.discussion_languages = discussion_languages
	}
}
