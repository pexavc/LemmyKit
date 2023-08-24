//
//  Lemmy+Search.swift
//  
//
//  Created by Ritesh Pakala on 8/23/23.
//

import Foundation

//MARK: -- Search

public extension Lemmy {
    @discardableResult
    func search(_ q: String,
                type_: SearchType,
                communityId: CommunityId? = nil,
                communityName: String? = nil,
                creatorId: PersonId? = nil,
                sort: SortType = .hot,
                listingType: ListingType = .all,
                page: Int?,
                limit: Int?,
                auth: String?) async -> Search.Response? {
        guard let result = try? await api.request(
            Search(q: q,
                   community_id: communityId,
                   community_name: communityName,
                   creator_id: creatorId,
                   type_: type_,
                   sort: sort,
                   listing_type: listingType,
                   page: page,
                   limit: limit,
                   auth: auth ?? self.auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    @discardableResult
    static func search(_ q: String,
                       type_: SearchType,
                       communityId: CommunityId? = nil,
                       communityName: String? = nil,
                       creatorId: PersonId? = nil,
                       sort: SortType = .hot,
                       listingType: ListingType = .all,
                       page: Int?,
                       limit: Int?,
                       auth: String? = nil) async -> Search.Response? {
        guard let shared else { return nil }
        
        return await shared.search(q,
                                   type_: type_,
                                   communityId: communityId,
                                   communityName: communityName,
                                   creatorId: creatorId,
                                   sort: sort,
                                   listingType: listingType,
                                   page: page,
                                   limit: limit,
                                   auth: auth)
    }
}
