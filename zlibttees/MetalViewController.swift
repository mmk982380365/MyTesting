//
//  MetalViewController.swift
//  metalTest
//
//  Created by MaMingkun on 2017/3/15.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

import UIKit
import Metal

protocol MetalViewControllerDelegate : class{
    func updateLogic(timeSinceLastUpdate:CFTimeInterval)
    func renderObjects(drawable:CAMetalDrawable)
}

class MetalViewController: UIViewController {
    
    var device: MTLDevice!
    
    var metalLayer: CAMetalLayer!
    
    var pipeLineState: MTLRenderPipelineState!
    
    var commandQueue: MTLCommandQueue!
    
    var projectionMatrix: Matrix4!
    
    var displayLink: CADisplayLink?
    
    var lastFrameTimestamp: TimeInterval = 0.0
    
    weak var delegate: MetalViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degrees(toRad: 85.0), aspectRatio: Float(view.bounds.width / view.bounds.height), nearZ: 0.01, farZ: 100.0)
        
        device = MTLCreateSystemDefaultDevice()
        
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.contentsScale = UIScreen.main.scale
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
//        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)
        
        let defaultLibrary = device.newDefaultLibrary()
        let fragmentProgram = defaultLibrary?.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary?.makeFunction(name: "basic_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        
        pipeLineState = try? device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = device.makeCommandQueue()
        
        displayLink = CADisplayLink(target: self, selector: #selector(newFrame(displayLink:)))
        displayLink?.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gameloop(timeSinceLastUpdate: TimeInterval) {
        
        delegate?.updateLogic(timeSinceLastUpdate: timeSinceLastUpdate)
        
        
        autoreleasepool {
            self.render()
        }
    }
    
    func newFrame(displayLink: CADisplayLink) {
        
        if lastFrameTimestamp == 0.0 {
            lastFrameTimestamp = displayLink.timestamp
        }
        
        
        let elapsed: TimeInterval = displayLink.timestamp - lastFrameTimestamp
        lastFrameTimestamp = displayLink.timestamp
        
        gameloop(timeSinceLastUpdate: elapsed)
        
    }
    
    func render() {
        
        
        if let drawable = metalLayer.nextDrawable() {
            
            delegate?.renderObjects(drawable: drawable)
            
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let window = view.window {
            let scale = window.screen.scale
            let layerSize = view.bounds.size
            
            view.contentScaleFactor = scale
            
            metalLayer.frame = CGRect(x: 0, y: 0, width: layerSize.width, height: layerSize.height)
            metalLayer.drawableSize = CGSize(width: layerSize.width * scale, height: layerSize.height * scale)
            
            projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degrees(toRad: 85.0), aspectRatio: Float(view.bounds.width / view.bounds.height), nearZ: 0.01, farZ: 100.0)
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
