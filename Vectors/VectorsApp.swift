//
//  VectorsApp.swift
//  Vectors
//
//  Created by paintmethecolorofchaos on 14.03.25.
//

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
