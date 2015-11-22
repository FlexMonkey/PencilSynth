//
//  FMOscillator.swift
//  SwiftFMOscillator
//
//  Created by Aurelius Prochazka on 7/5/14.
//  Copyright (c) 2014 Aurelius Prochazka. All rights reserved.
//

class FMOscillator: AKInstrument {
    
    // INSTRUMENT CONTROLS =====================================================
    
    var frequency            = AKInstrumentProperty(value: 440, minimum: 1.0, maximum: 880)
    var carrierMultiplier    = AKInstrumentProperty(value: 1.0, minimum: 0.0, maximum: 2.0)
    var modulatingMultiplier = AKInstrumentProperty(value: 1, minimum: 0, maximum: 2)
    var modulationIndex      = AKInstrumentProperty(value: 15,  minimum: 0,   maximum: 30)
    var amplitude            = AKInstrumentProperty(value: 0.0, minimum: 0,   maximum: 0.2)
    
    // INSTRUMENT DEFINITION ===================================================
    
    override init() {
        super.init()
        
        addProperty(frequency)
        addProperty(amplitude)
        addProperty(carrierMultiplier)
        addProperty(modulatingMultiplier)
        addProperty(modulationIndex)
        
        let fmOscillator = AKFMOscillator(
            waveform: AKTable.standardSineWave(),
            baseFrequency: frequency,
            carrierMultiplier: carrierMultiplier,
            modulatingMultiplier: modulatingMultiplier,
            modulationIndex: modulationIndex,
            amplitude: amplitude
        )
        
        setAudioOutput(fmOscillator)
    }
}