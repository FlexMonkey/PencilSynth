//
//  ViewController.swift
//  PencilSynth
//
//  Created by Simon Gladman on 22/11/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController
{
    let halfPi = CGFloat(M_PI_2)
    let pi = CGFloat(M_PI)
    
    let sceneKitView = SCNView()
    let scene = SCNScene()
    let cylinderNode = SCNNode(geometry: SCNCapsule(capRadius: 0.05, height: 1))
    let plane = SCNNode(geometry: SCNPlane(width: 20, height: 20))
    
    let oscillator = FMOscillator()
    let rollingWaveformPlot = AKAudioOutputRollingWaveformPlot()
    
    let label = UILabel()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.addSubview(rollingWaveformPlot)
        view.addSubview(sceneKitView)
        
        label.numberOfLines = 4
        label.text = " \n \n \n "
        label.font = UIFont.boldSystemFontOfSize(24)
        label.textColor = UIColor.whiteColor()
        label.hidden = true
        view.addSubview(label)
        
        view.backgroundColor = UIColor.blackColor()
        
        sceneKitView.scene = scene
        sceneKitView.backgroundColor = UIColor.clearColor()
        addLights()
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        
        camera.xFov = 45
        camera.yFov = 45
        
        let cameraNode = SCNNode()
        
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
        
        cylinderNode.position = SCNVector3(0, 0, 0)
        cylinderNode.pivot = SCNMatrix4MakeTranslation(0, 0.5, 0)
        
        plane.opacity = 0.000001
        
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cylinderNode)
        scene.rootNode.addChildNode(plane)
        
        cylinderNode.opacity = 0
        
        AKOrchestra.addInstrument(oscillator)
        AKOrchestra.start()
        AKManager.addBinding(rollingWaveformPlot)
        
        oscillator.amplitude.value = oscillator.amplitude.minimum
        
        
        oscillator.amplitude.value = oscillator.amplitude.maximum
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        guard let touch = touches.first where
                touch.type == UITouchType.Stylus else
        {
            return
        }

        pencilTouchHandler(touch)
        oscillator.play()
        label.hidden = false
        
        SCNTransaction.setAnimationDuration(0.25)
        cylinderNode.opacity = 1
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        guard let touch = touches.first where
                touch.type == UITouchType.Stylus else
        {
            return
        }
        
        pencilTouchHandler(touch)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        guard touches.first?.type == UITouchType.Stylus else
        {
            return
        }
        
        oscillator.stop()
        label.hidden = false
        
        SCNTransaction.setAnimationDuration(0.25)
        cylinderNode.opacity = 0
    }
    
    func pencilTouchHandler(touch: UITouch)
    {
        guard let hitTestResult:SCNHitTestResult = sceneKitView.hitTest(touch.locationInView(view), options: nil).filter( { $0.node == plane }).first else
        {
            return
        }
        
        SCNTransaction.setAnimationDuration(0)
        
        cylinderNode.position = SCNVector3(hitTestResult.localCoordinates.x, hitTestResult.localCoordinates.y, 0)
        cylinderNode.eulerAngles = SCNVector3(touch.altitudeAngle, 0.0, 0 - touch.azimuthAngleInView(view) - halfPi)
        
        let frequency = touch.locationInView(view).x / view.bounds.width
        let modulatingMultiplier = touch.locationInView(view).y / view.bounds.height
        let carrierMultiplier = (halfPi - touch.altitudeAngle) / halfPi
        let modulationIndex = (pi + touch.azimuthAngleInView(view)) / (pi * 2)
     
        label.text = String(format: "⇔ Frequency: %d %%", Int(frequency * 100)) +
            String(format: "\n⇕ Modulating Multiplier: %d %%", Int(modulatingMultiplier * 100)) +
            String(format: "\n∢ Carrier Multiplier: %d %%", Int(carrierMultiplier * 100)) +
            String(format: "\n↻ Modulation Index: %d %%", Int(modulationIndex * 100))
        
        oscillator.frequency.value = (oscillator.frequency.maximum - oscillator.frequency.minimum) * Float(frequency)
        
        oscillator.modulatingMultiplier.value = (oscillator.modulatingMultiplier.maximum - oscillator.modulatingMultiplier.minimum) * Float(modulatingMultiplier)
        
        oscillator.carrierMultiplier.value = (oscillator.carrierMultiplier.maximum - oscillator.carrierMultiplier.minimum) * Float(carrierMultiplier)
        
        oscillator.modulationIndex.value = (oscillator.modulationIndex.maximum - oscillator.modulationIndex.minimum) * Float(modulationIndex)
        
    }
    
    func addLights()
    {
        // ambient light...
        
        let ambientLight = SCNLight()
        ambientLight.type = SCNLightTypeAmbient
        ambientLight.color = UIColor(white: 0.15, alpha: 1.0)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        
        scene.rootNode.addChildNode(ambientLightNode)
        
        // omni light...
        
        let omniLight = SCNLight()
        omniLight.type = SCNLightTypeOmni
        omniLight.color = UIColor(white: 1.0, alpha: 1.0)
        let omniLightNode = SCNNode()
        omniLightNode.light = omniLight
        omniLightNode.position = SCNVector3(x: -10, y: 10, z: 30)
        
        scene.rootNode.addChildNode(omniLightNode)
    }

    override func viewDidLayoutSubviews()
    {
        sceneKitView.frame = view.bounds
        rollingWaveformPlot.frame = view.bounds

        label.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.width, height: label.intrinsicContentSize().height)
    }

}

