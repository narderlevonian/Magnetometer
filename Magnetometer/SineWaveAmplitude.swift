//
//  SineWaveAmplitude.swift
//  Magnetometer
//
//  Created by Nar der Levonian on 29.01.2023.
//

import Foundation

struct SineWaveAmplitude {
    var x: Double
    var y: Double
    var z: Double
    
    init(frequency: Frequency) {
        func convert(_ frequency: Double) -> Double {
            let divider = sineWaveAmplitudeDivider
            return pow(abs(frequency)/divider, 1/exp)
        }
        
        self.x = convert(frequency.x)
        self.y = convert(frequency.y)
        self.z = convert(frequency.z)
    }

}
