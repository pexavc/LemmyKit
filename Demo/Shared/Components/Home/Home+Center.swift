import Granite
import GraniteUI
import SwiftUI
import Combine
import LemmyKit

extension Home {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            var siteView: SiteView? = nil
        }

        @Event(.onAppear) var onAppear: Home.DidAppear.Reducer
        
        @Store public var state: Center.State
    }
}
