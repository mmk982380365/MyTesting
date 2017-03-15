//
//  Node.swift
//  metalTest
//
//  Created by MaMingkun on 2017/3/15.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

import UIKit

class Node {
    
    var time: TimeInterval = 0.0
    
    var bufferProvider: BufferProvider
    
    
    
    let light = Light(color: (1.0,1.0,1.0), ambientIntensity: 0.1, direction: (0.0, 0.0 ,1.0), diffuseIntensity: 0.8, shininess: 10, specularIntensity: 2)
    
    
    let name: String
    var vertexCount: Int
    var vertexBuffer: MTLBuffer
    var uniformBuffer: MTLBuffer?
    
    var texture: MTLTexture
    
    lazy var samplerState: MTLSamplerState? = Node.defaultSampler(device: self.device)
    
    
    var device: MTLDevice
    
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0
    
    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    
    var scale: Float = 1.0
    
    
    init(name: String, vertices: Array<Vertex>, device: MTLDevice, texture: MTLTexture) {
        var vertexData = Array<Float>()
        for vertex in vertices {
            vertexData += vertex.floatBuffer()
        }
        
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize)
        
        self.name = name
        self.device = device
        vertexCount = vertices.count
        
        self.texture = texture
        
        bufferProvider = BufferProvider(device: device, inflightBuffersCount: 3, sizeOfUniformsBuffer: MemoryLayout<Float>.size * Matrix4.numberOfElements() * 2 + Light.size())
        
    }
    
    func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, parentModelViewMatrix: Matrix4, projectionMatrix: Matrix4, clearColor: MTLClearColor?) {
        
        
        let _ = bufferProvider.availableResourcesSemaphore.wait(timeout: DispatchTime.distantFuture)
        
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        commandBuffer.addCompletedHandler { (commandBuffer) in
            self.bufferProvider.availableResourcesSemaphore.signal()
        }
        
        let renderEncoderOpt = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        renderEncoderOpt.setCullMode(.front)
        
        renderEncoderOpt.setRenderPipelineState(pipelineState)
        renderEncoderOpt.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        
        renderEncoderOpt.setFragmentTexture(texture, at: 0)
        if let samplerState = samplerState {
            renderEncoderOpt.setFragmentSamplerState(samplerState, at: 0)
        }
        
        let nodeModelMatrix = modelMatrix()
        nodeModelMatrix.multiplyLeft(parentModelViewMatrix)
        
        
        let uniformBuffer = bufferProvider.nextUniformsBuffer(projectionMatrix: projectionMatrix, modelViewMatrix: nodeModelMatrix, light: light)
        
        
        renderEncoderOpt.setVertexBuffer(uniformBuffer, offset: 0, at: 1)
        renderEncoderOpt.setFragmentBuffer(uniformBuffer, offset: 0, at: 1)
        
        
        renderEncoderOpt.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: vertexCount / 3)
        renderEncoderOpt.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
    }
    
    func modelMatrix() -> Matrix4 {
        let matrix = Matrix4()!
        matrix.translate(positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(rotationX, y: rotationY, z: rotationZ)
        matrix.scale(scale, y: scale, z: scale)
        return matrix
    }
    
    func updateWithDelta(delta: TimeInterval) {
        time += delta
    }
    
    static func defaultSampler(device: MTLDevice) -> MTLSamplerState {
        let pSamplerDescriptor = MTLSamplerDescriptor()
        pSamplerDescriptor.minFilter = .nearest
        pSamplerDescriptor.magFilter = .nearest
        pSamplerDescriptor.mipFilter = .nearest
        pSamplerDescriptor.maxAnisotropy = 1
        pSamplerDescriptor.sAddressMode = .clampToEdge
        pSamplerDescriptor.tAddressMode = .clampToEdge
        pSamplerDescriptor.rAddressMode = .clampToEdge
        pSamplerDescriptor.normalizedCoordinates = true
        pSamplerDescriptor.lodMinClamp = 0
        pSamplerDescriptor.lodMaxClamp = FLT_MAX
        
        return device.makeSamplerState(descriptor: pSamplerDescriptor)
    }
    
}
