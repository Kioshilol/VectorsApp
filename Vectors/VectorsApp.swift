import SwiftUI

@main
struct VectorsApp: App {
    
    init(){
        _ = CompositionRoot.shared
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
