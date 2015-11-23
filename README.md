# PencilSynth
##### An Audiokit Synthesiser Controller by Apple Pencil

##### _Companion project to this blog post: http://flexmonkey.blogspot.co.uk/2015/11/pencilsynth-apple-pencil-controlled.html_

Here's another Apple Pencil experiment, PencilSynth is an AudioKit powered synthesiser (mis)using the Pencil as a joystick controller. It's based on AudioKit's TouchRegions demonstration and works like this:

* Given:
        
        let touch: UITouch
* The Pencil's horizontal position on the screen defines the output frequency:
        
        let frequency = touch.locationInView(view).x / view.bounds.width
* The Pencil's vertical position on the screen defines the output modulating multiplier:
        
        let modulatingMultiplier = touch.locationInView(view).y / view.bounds.height
* The Pencil's altitude angle defines the output carrier multiplier:
        
        let carrierMultiplier = (halfPi - touch.altitudeAngle) / halfPi
* The Pencil's azimuth angle defines the output modulation index:
        
        let modulationIndex = (pi + touch.azimuthAngleInView(view)) / (pi * 2)

Those four normalised values are plugged into an instance of FMOscillator (which is taken directly from the TouchRegions demo):

    oscillator.frequency.value = (oscillator.frequency.maximum - oscillator.frequency.minimum) * Float(frequency)
    
    oscillator.modulatingMultiplier.value = (oscillator.modulatingMultiplier.maximum - oscillator.modulatingMultiplier.minimum) * Float(modulatingMultiplier)
    
    oscillator.carrierMultiplier.value = (oscillator.carrierMultiplier.maximum - oscillator.carrierMultiplier.minimum) * Float(carrierMultiplier)
    
    oscillator.modulationIndex.value = (oscillator.modulationIndex.maximum - oscillator.modulationIndex.minimum) * Float(modulationIndex)

The orientation and rendering of the "virtual pencil" is taken straight from my PencilController demo.

The GitHub repository contains the AudioKit source, but all my code exists in the view controller class.

In conclusion, the Apple Pencil opens up a world of new interaction design paradigms (despite what Jony Ive may tell us!). PencilSynth and my Pencil based image processing app are, I think, demonstrations that the Pencil is an excellent input device for controlling continuous values across multiple dimensions.

As always, the source code for this project is available at my GitHub repository here. Enjoy!
