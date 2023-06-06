//
//  Nano2_HallelujahApp.swift
//  Nano2-Hallelujah
//
//  Created by Gabriella Christina Kandinata on 18/05/23.
//

import SwiftUI

enum Tabs : Int {
    case danger = 1
    case noDanger = 2
}

@main
struct Nano2_HallelujahApp: App {
//    @State var pages
//    let viewModel = ProgramViewModel(integrateDevices: Devices_Integration())
//    let connect = Devices_Integration()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            
            NavigationView {
                ContentView()
                    .preferredColorScheme(.dark)
                    // 
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
