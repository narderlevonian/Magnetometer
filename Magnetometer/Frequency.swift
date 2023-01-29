//
//  Frequency.swift
//  Magnetometer
//
//  Created by Nar der Levonian on 28.01.2023.
//

import Foundation

struct Frequency {
    var x: Double
    var y: Double
    var z: Double
    
    init(motion: MotionManager) {
        self.x = motion.x
        self.y = motion.y
        self.z = motion.z
    }
}
