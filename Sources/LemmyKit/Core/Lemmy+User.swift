//
//  Lemmy+User.swift
//  
//
//  Created by Ritesh Pakala on 8/23/23.
//

import Foundation

//MARK: -- User info

public extension Lemmy {
    func user(_ person_id: PersonId? = nil,
              username: String? = nil,
              sort: SortType? = nil,
              auth: String? = nil) async -> GetPersonDetailsResponse? {
        guard let result = try? await api.request(
            GetPersonDetails(person_id: person_id,
                             username: username,
                             sort: sort,
                             auth: auth ?? self.auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func user(_ person_id: PersonId? = nil,
                     username: String? = nil,
                     sort: SortType? = nil,
                     auth: String? = nil) async -> GetPersonDetailsResponse? {
        
        return await shared?.user(person_id,
                                  username: username,
                                  sort: sort,
                                  auth: auth)
    }
}

//MARK: -- User

public extension Lemmy {
    
    func saveUserSettings(show_nsfw: Bool? = nil,
                          show_scores: Bool? = nil,
                          theme: String? = nil,
                          default_sort_type: SortType? = nil,
                          default_listing_type: ListingType? = nil,
                          interface_language: String? = nil,
                          avatar: String? = nil,
                          banner: String? = nil,
                          display_name: String? = nil,
                          email: String? = nil,
                          bio: String? = nil,
                          matrix_user_id: String? = nil,
                          show_avatars: Bool? = nil,
                          send_notifications_to_email: Bool? = nil,
                          bot_account: Bool? = nil,
                          show_bot_accounts: Bool? = nil,
                          show_read_posts: Bool? = nil,
                          show_new_post_notifs: Bool? = nil,
                          discussion_languages: [LanguageId]? = nil,
                          generate_totp_2fa: Bool? = nil,
                          auth: String,
                          open_links_in_new_tab: Bool? = nil
    ) async -> LoginResponse? {
        guard let result = try? await api.request(
            SaveUserSettings(show_nsfw: show_nsfw,
                             show_scores: show_scores,
                             theme: theme,
                             default_sort_type: default_sort_type,
                             default_listing_type: default_listing_type,
                             interface_language: interface_language,
                             avatar: avatar,
                             banner: banner,
                             display_name: display_name,
                             email: email,
                             bio: bio,
                             matrix_user_id: matrix_user_id,
                             show_avatars: show_avatars,
                             send_notifications_to_email: send_notifications_to_email,
                             bot_account: bot_account,
                             show_bot_accounts: show_bot_accounts,
                             show_read_posts: show_read_posts,
                             show_new_post_notifs: show_new_post_notifs,
                             discussion_languages: discussion_languages,
                             generate_totp_2fa: generate_totp_2fa,
                             auth: auth,
                             open_links_in_new_tab: open_links_in_new_tab)
        ).async() else {
            return nil
        }
        
        if isBaseInstance {
            LemmyKit.auth = result.jwt
            
            //Update user info
            _ = await Lemmy.site(auth: result.jwt)
        }
        
        return result
    }
    static func saveUserSettings(show_nsfw: Bool? = nil,
                                 show_scores: Bool? = nil,
                                 theme: String? = nil,
                                 default_sort_type: SortType? = nil,
                                 default_listing_type: ListingType? = nil,
                                 interface_language: String? = nil,
                                 avatar: String? = nil,
                                 banner: String? = nil,
                                 display_name: String? = nil,
                                 email: String? = nil,
                                 bio: String? = nil,
                                 matrix_user_id: String? = nil,
                                 show_avatars: Bool? = nil,
                                 send_notifications_to_email: Bool? = nil,
                                 bot_account: Bool? = nil,
                                 show_bot_accounts: Bool? = nil,
                                 show_read_posts: Bool? = nil,
                                 show_new_post_notifs: Bool? = nil,
                                 discussion_languages: [LanguageId]? = nil,
                                 generate_totp_2fa: Bool? = nil,
                                 auth: String? = nil,
                                 open_links_in_new_tab: Bool? = nil
    ) async -> LoginResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.saveUserSettings(show_nsfw: show_nsfw,
                                             show_scores: show_scores,
                                             theme: theme,
                                             default_sort_type: default_sort_type,
                                             default_listing_type: default_listing_type,
                                             interface_language: interface_language,
                                             avatar: avatar,
                                             banner: banner,
                                             display_name: display_name,
                                             email: email,
                                             bio: bio,
                                             matrix_user_id: matrix_user_id,
                                             show_avatars: show_avatars,
                                             send_notifications_to_email: send_notifications_to_email,
                                             bot_account: bot_account,
                                             show_bot_accounts: show_bot_accounts,
                                             show_read_posts: show_read_posts,
                                             show_new_post_notifs: show_new_post_notifs,
                                             discussion_languages: discussion_languages,
                                             generate_totp_2fa: generate_totp_2fa,
                                             auth: validAuth,
                                             open_links_in_new_tab: open_links_in_new_tab)
    }
    
    func details(_ person_id: PersonId? = nil,
                 sort: SortType? = nil,
                 page: Int? = nil,
                 limit: Int? = nil,
                 community_id: CommunityId? = nil,
                 saved_only: Bool? = nil,
                 auth: String? = nil,
                 location: FetchType = .base) async -> GetPersonDetailsResponse? {
        guard let result = try? await api.request(
            GetPersonDetails(person_id: person_id,
                             sort: sort,
                             page: page,
                             limit: limit,
                             community_id: community_id,
                             saved_only: saved_only,
                             auth: auth ?? self.auth,
                             location: location)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func details(_ person: Person? = nil,
                        sort: SortType? = nil,
                        page: Int? = nil,
                        limit: Int? = nil,
                        community: Community? = nil,
                        saved_only: Bool? = nil,
                        auth: String? = nil,
                        location: FetchType = .base) async -> GetPersonDetailsResponse? {
        guard let shared else { return nil }
        
        let useBase: Bool
        let actor_id: String?
        switch location {
        case .base:
            useBase = true
            actor_id = nil
        case .source:
            useBase = false
            actor_id = person?.actor_id
        case .peer(let host):
            useBase = false
            actor_id = host
            
        }
        
        if useBase == false,
           let person,
           let actor_id,
           let domain = LemmyKit.sanitize(actor_id).host { //getInstancedDomain(community: community) {
            let instancedLemmy: Lemmy = .init(apiUrl: domain)
            
            return await instancedLemmy.details(person.id,
                                                sort: sort,
                                                page: page,
                                                limit: limit,
                                                community_id: community?.id,
                                                saved_only: saved_only,
                                                auth: auth,
                                                location: location)
            //Fetch local community
        } else {
            
            return await shared.details(person?.id,
                                        sort: sort,
                                        page: page,
                                        limit: limit,
                                        community_id: community?.id,
                                        saved_only: saved_only,
                                        auth: auth,
                                        location: location)
        }
    }
}

//MARK: Mention/Replies/unreadcount

public extension Lemmy {
    func mentions(sort: CommentSortType? = nil,
                  page: Int? = nil,
                  limit: Int? = nil,
                  unreadOnly: Bool? = nil,
                  auth: String) async -> GetPersonMentionsResponse? {
        guard let result = try? await api.request(
            GetPersonMentions(sort: sort,
                              page: page,
                              limit: limit,
                              unread_only: unreadOnly,
                              auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func mentions(sort: CommentSortType? = nil,
                         page: Int? = nil,
                         limit: Int? = nil,
                         unreadOnly: Bool? = nil,
                         auth: String? = nil) async -> GetPersonMentionsResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.mentions(sort: sort,
                                     page: page,
                                     limit: limit,
                                     unreadOnly: unreadOnly,
                                     auth: validAuth)
    }
    
    func replies(sort: CommentSortType? = nil,
                 page: Int? = nil,
                 limit: Int? = nil,
                 unreadOnly: Bool? = nil,
                 auth: String) async -> GetRepliesResponse? {
        guard let result = try? await api.request(
            GetReplies(sort: sort,
                       page: page,
                       limit: limit,
                       unread_only: unreadOnly,
                       auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func replies(sort: CommentSortType? = nil,
                        page: Int? = nil,
                        limit: Int? = nil,
                        unreadOnly: Bool? = nil,
                        auth: String? = nil) async -> GetRepliesResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.replies(sort: sort,
                                    page: page,
                                    limit: limit,
                                    unreadOnly: unreadOnly,
                                    auth: validAuth)
    }
    
    func unreadCount(auth: String) async -> GetUnreadCountResponse? {
        guard let result = try? await api.request(
            GetUnreadCount(auth: auth)
        ).async() else {
            return nil
        }
        
        return result
    }
    static func unreadCount(auth: String? = nil) async -> GetUnreadCountResponse? {
        guard let shared else { return nil }
        
        let validAuth: String? = auth ?? shared.auth
        
        guard let validAuth else {
            LemmyLog("Authentication required")
            return nil
        }
        
        return await shared.unreadCount(auth: validAuth)
    }
}
