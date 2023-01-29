//
//  OscillatorFrequency.swift
//  Magnetometer
//
//  Created by Nar der Levonian on 29.01.2023.
//

import Foundation

struct OscillatorFrequency {
    var x: Double
    var y: Double
    var z: Double
    
    init(frequency: Frequency) {
        func convert(_ frequency: Double) -> Double {
            return abs(frequency) + oscillatorFrequencyOffset
        }
        
        self.x = convert(frequency.x)
        self.y = convert(frequency.y)
        self.z = convert(frequency.z)
    }
}
