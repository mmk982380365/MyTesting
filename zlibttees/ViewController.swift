//
//  ViewController.swift
//  metalTest
//
//  Created by MaMingkun on 2017/3/15.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

import UIKit
import Metal

class MySceneViewController: MetalViewController, MetalViewControllerDelegate {
    
    var worldModelMatrix: Matrix4!
    var objectToDraw: Cube!
    
    let panSensivity:Float = 5.0
    var lastPanLocation: CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        worldModelMatrix = Matrix4()
        worldModelMatrix.translate(0.0, y: 0.0, z: -4.0)
        worldModelMatrix.rotateAroundX(Matrix4.degrees(toRad: 25.0), y: 0.0, z: 0.0)
        
        objectToDraw = Cube.init(device: device, commandQ: commandQueue)
        
        delegate = self
        
        setupGesture()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewOnPan(panGesture:)))
        view.addGestureRecognizer(pan)
    }
    
    func viewOnPan(panGesture: UIPanGestureRecognizer) {
        
        if panGesture.state == .changed {
            let pointInView = panGesture.location(in: view)
            
            let xDelta = Float((lastPanLocation.x - pointInView.x) / view.bounds.width) * panSensivity
            let yDelta = Float((lastPanLocation.y - pointInView.y) / view.bounds.height) * panSensivity
            
            objectToDraw.rotationY -= xDelta
            objectToDraw.rotationX -= yDelta
            lastPanLocation = pointInView
            
        } else if panGesture.state == .began {
            lastPanLocation = panGesture.location(in: view)
        }
        
    }
    
    func renderObjects(drawable: CAMetalDrawable) {
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipeLineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
    }
    
    func updateLogic(timeSinceLastUpdate: CFTimeInterval) {
//        objectToDraw.updateWithDelta(delta: timeSinceLastUpdate)
    }

}

