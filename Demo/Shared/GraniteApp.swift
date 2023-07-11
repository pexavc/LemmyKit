import SwiftUI

@main
struct GraniteApp: App {
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #elseif os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            Home()
                .preferredColorScheme(.dark)
            
            #elseif os(macOS)
            Home()
                .preferredColorScheme(.dark)
                .frame(minWidth: 750, minHeight: 420)
            #endif
        }
    }
}
