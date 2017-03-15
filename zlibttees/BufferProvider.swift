//
//  BufferProvider.swift
//  metalTest
//
//  Created by MaMingkun on 2017/3/15.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

import UIKit
import Metal

class BufferProvider: NSObject {

    var availableResourcesSemaphore: DispatchSemaphore
    
    let inflightBuffersCount: Int
    
    private var uniformsBuffers: [MTLBuffer]
    
    private var availableBufferIndex: Int = 0
    
    init(device: MTLDevice, inflightBuffersCount: Int, sizeOfUniformsBuffer: Int) {
        
        availableResourcesSemaphore = DispatchSemaphore(value: inflightBuffersCount)
        
        self.inflightBuffersCount = inflightBuffersCount
        uniformsBuffers = [MTLBuffer]()
        for _ in 0..<inflightBuffersCount {
            let uniformsBuffer = device.makeBuffer(length: sizeOfUniformsBuffer, options: [])
            uniformsBuffers.append(uniformsBuffer)
        }
    }
    
    func nextUniformsBuffer(projectionMatrix: Matrix4, modelViewMatrix: Matrix4, light: Light) -> MTLBuffer {
        
        let buffer = uniformsBuffers[availableBufferIndex]
        
        let bufferPointer = buffer.contents()
        
        memcpy(bufferPointer, modelViewMatrix.raw(), MemoryLayout<Float>.size * Matrix4.numberOfElements())
        memcpy(bufferPointer + MemoryLayout<Float>.size * Matrix4.numberOfElements(), projectionMatrix.raw(), MemoryLayout<Float>.size * Matrix4.numberOfElements())
        memcpy(bufferPointer + 2 * MemoryLayout<Float>.size * Matrix4.numberOfElements(), light.raw(), Light.size())
        
        availableBufferIndex += 1
        if availableBufferIndex == inflightBuffersCount {
            availableBufferIndex = 0
        }
        
        return buffer
    }
    
    deinit {
        for _ in 0...inflightBuffersCount {
            availableResourcesSemaphore.signal()
        }
    }
    
}
