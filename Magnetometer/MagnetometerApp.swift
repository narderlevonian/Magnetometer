//
//  MagnetometerApp.swift
//  Magnetometer
//
//  Created by Nar der Levonian on 28.01.2023.
//

import SwiftUI

@main
struct MagnetometerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(motion: MotionManager())
        }
    }
}
