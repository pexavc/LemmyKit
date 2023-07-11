import Granite
import SwiftUI
import Foundation
import LemmyKit

extension Home {
    struct DidAppear: GraniteReducer {
        typealias Center = Home.Center
        
        @Event var updateSiteView: UpdateSiteView.Reducer
        
        func reduce(state: inout Center.State) {
            _ = Task {
                LemmyKit.baseUrl = "https://neatia.xyz"
                
                let site = await Lemmy.request(GetSite())
                let metadata = await Lemmy.request(GetSiteMetadata(url: LemmyKit.baseUrl))
                
                updateSiteView.send(UpdateSiteView.Meta(siteView: site?.site_view,
                                                        siteMetadata: metadata?.metadata))
            }
        }
    }
    
    struct UpdateSiteView: GraniteReducer {
        typealias Center = Home.Center
        
        struct Meta: GranitePayload {
            var siteView: SiteView?
            var siteMetadata: SiteMetadata?
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            state.siteView = meta?.siteView
        }
    }
}
