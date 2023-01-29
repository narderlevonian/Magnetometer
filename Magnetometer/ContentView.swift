//
//  ContentView.swift
//  Magnetometer
//
//  Created by Nar der Levonian on 28.01.2023.
//

import SwiftUI
import SwiftUISineWaveShape
import AudioKit
import AudioToolbox
import SoundpipeAudioKit

struct ContentView: View {
    var engine = AudioEngine()

    var xOsc = MorphingOscillator()
    var yOsc = MorphingOscillator()
    var zOsc = MorphingOscillator()
    
    @ObservedObject
    var motion: MotionManager
    
    @State
    private var phase: Angle = .zero
    let phaseShift = Animation.linear(duration: phaseShiftAnimationDuration)
    
    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()

    var body: some View {
        let frequency = Frequency(motion: self.motion)
        let oscillatorFrequency = OscillatorFrequency(frequency: frequency)
        let sineWaveFrequency = SineWaveFrequency(frequency: frequency)
        let sineWaveAmplitude = SineWaveAmplitude(frequency: frequency)
        
        let dispatchQueue: () = DispatchQueue.main.async {
            withAnimation(phaseShift.repeatForever(autoreverses: false)) {
                phase.radians = 2.0 * .pi
            }
        }
        
        VStack {
            Spacer()
            
            ZStack {
                SineWave(
                      phase: phase,
                      amplitudeRatio: sineWaveAmplitude.x,
                      frequency: sineWaveFrequency.x,
                      amplitudeModulation: sineWaveAmplitudeModulationType
                  )
                  .stroke(xSineWaveColor, lineWidth: sineWaveThickness)
                  .opacity(sineWaveOpacity)
                  .onAppear {
                      dispatchQueue
                  }
                
                SineWave(
                      phase: phase,
                      amplitudeRatio:  sineWaveAmplitude.y,
                      frequency: sineWaveFrequency.y,
                      amplitudeModulation: sineWaveAmplitudeModulationType
                  )
                  .stroke(ySineWaveColor, lineWidth: sineWaveThickness)
                  .opacity(sineWaveOpacity)
                  .onAppear {
                      dispatchQueue
                  }
                
                SineWave(
                      phase: phase,
                      amplitudeRatio: sineWaveAmplitude.z,
                      frequency: sineWaveFrequency.z,
                      amplitudeModulation: sineWaveAmplitudeModulationType
                  )

                .stroke(zSineWaveColor, lineWidth: sineWaveThickness)
                .opacity(sineWaveOpacity)
                .onAppear {
                    dispatchQueue
                }

            }
            .onAppear {
                xOsc.start()
                yOsc.start()
                zOsc.start()
                
                engine.output = Mixer(xOsc, yOsc, zOsc)

                do {
                    try engine.start()
                } catch {
                    print ("AudioKit.start() failed!")
                }
            }
            .padding()
            .frame(height: UIScreen.main.bounds.size.height)

            Spacer()

        }
        .background(contentViewBckgroundColor)
        .onReceive(timer) { _ in
            xOsc.frequency = AUValue(oscillatorFrequency.x)
            yOsc.frequency = AUValue(oscillatorFrequency.y)
            zOsc.frequency = AUValue(oscillatorFrequency.z)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(motion: MotionManager())
    }
}
