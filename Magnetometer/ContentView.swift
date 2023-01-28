//
//  ContentView.swift
//  Magnetometer
//
//  Created by Nar der Levonian on thickness8.01.thickness0thickness3.
//

import SwiftUI
import SwiftUISineWaveShape
import AudioKit
import AudioToolbox
import SoundpipeAudioKit

struct ContentView: View {
    let thickness = 2.0
    let opacity = 0.64
    let divider = 5000000.0

    var engine = AudioEngine()

    var xOsc = MorphingOscillator(frequency: 440, amplitude: 0.2)
    var yOsc = MorphingOscillator(frequency: 440, amplitude: 0.2)
    var zOsc = MorphingOscillator(frequency: 440, amplitude: 0.2)
    
    @ObservedObject
    var motion: MotionManager
    
    @State
    private var phase: Angle = .zero
    let phaseShift = Animation.linear(duration: 2.0)

    var body: some View {
        let frequency = Convert(motion: self.motion, divider: divider);
        let dispatchQueue: () = DispatchQueue.main.async {
            withAnimation(phaseShift.repeatForever(autoreverses: false)) {
                phase.radians = 2.0 * .pi
                xOsc.frequency = AUValue(frequency.x * frequency.x * 1000 + 20);
                yOsc.frequency = AUValue(frequency.y * frequency.x * 1000 + 20);
                zOsc.frequency = AUValue(frequency.z * frequency.x * 1000 + 20);
                print("Frequency: \(xOsc.frequency)")
            }
        }
        
        VStack {
            Spacer()
            
            ZStack {
                SineWave(
                      phase: phase,
                      amplitudeRatio: sqrt(frequency.x),
                      frequency: frequency.x,
                      amplitudeModulation: .edges
                  )
                  .stroke(xColor, lineWidth: thickness)
                  .opacity(opacity)
                  .onAppear {
                      dispatchQueue
                  }
                
                SineWave(
                      phase: phase,
                      amplitudeRatio: sqrt(frequency.y),
                      frequency: frequency.y,
                      amplitudeModulation: .edges
                  )
                  .stroke(yColor, lineWidth: thickness)
                  .opacity(opacity)
                  .onAppear {
                      dispatchQueue
                  }
                
                SineWave(
                      phase: phase,
                      amplitudeRatio: sqrt(frequency.z),
                      frequency: frequency.z,
                      amplitudeModulation: .edges
                  )
                .stroke(zColor, lineWidth: thickness)
                .opacity(opacity)
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
            .frame(height: UIScreen.main.bounds.size.height * 0.5)

            Spacer()
            
        }.background(backgroundColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(motion: MotionManager())
    }
}
