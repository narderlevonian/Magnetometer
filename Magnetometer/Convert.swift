//
//  Convert.swift
//  Magnetometer
//
//  Created by Nar der Levonian on 28.01.2023.
//

import Foundation

func Convert(motion: MotionManager, divider: Double) -> Frequency {
    return Frequency(x: abs(pow(motion.x, 2.0) / divider),
                     y: abs(pow(motion.y, 2.0) / divider),
                     z: abs(pow(motion.z, 2.0) / divider))
}


