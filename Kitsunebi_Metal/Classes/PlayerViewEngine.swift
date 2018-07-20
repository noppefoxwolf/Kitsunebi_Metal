//
//  PlayerViewEngine.swift
//  Kitsunebi_Metal
//
//  Created by Tomoya Hirano on 2018/07/19.
//

import MetalKit
import CoreMedia
import CoreVideo

final class PlayerViewEngine {
  private let device: MTLDevice
  private let commandQueue: MTLCommandQueue
  private var pipelineState: MTLRenderPipelineState? = nil
  private var textureCache: CVMetalTextureCache? = nil
  
  init(device: MTLDevice) {
    self.device = device
    self.commandQueue = device.makeCommandQueue()!
    CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &textureCache)
  }
  
  internal func render(to drawable: CAMetalDrawable, src: CMSampleBuffer, mask: CMSampleBuffer) {
    let srcTexture = MTLTextureFactory.make(with: src, textureCache: textureCache)!
    let maskTexture = MTLTextureFactory.make(with: mask, textureCache: textureCache)!
    render(to: drawable, src: srcTexture, mask: maskTexture)
  }
  
  private func render(to drawable: CAMetalDrawable, src: MTLTexture, mask: MTLTexture) {
    let commandBuffer = commandQueue.makeCommandBuffer()!
    let edge = makeFillEdge(dst: drawable.texture.size, src: src.size)
    let vertexBuffer = device.makeVertexBuffer(edge: edge)
    let texCoordBuffer = device.makeTexureCoordBuffer()
    let pipelineState = makeRenderPipelineState(device: device, pixelFormat: .bgra8Unorm, vertexFunctionName: "vertexShader", fragmentFunctionName: "fragmentShader")
    
    let renderDesc = MTLRenderPassDescriptor()
    renderDesc.colorAttachments[0].texture = drawable.texture
    renderDesc.colorAttachments[0].loadAction = .clear
    
    let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderDesc)!
    renderEncoder.setRenderPipelineState(pipelineState)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    renderEncoder.setVertexBuffer(texCoordBuffer, offset: 0, index: 1)
    renderEncoder.setFragmentTexture(src, index: 0)
    renderEncoder.setFragmentTexture(mask, index: 1)
    renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
    renderEncoder.endEncoding()
    
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
  
  private func makeRenderPipelineState(device: MTLDevice, pixelFormat: MTLPixelFormat, vertexFunctionName: String, fragmentFunctionName: String) -> MTLRenderPipelineState {
    let library = try! device.makeDefaultLibrary(bundle: Bundle(for: type(of: self)))
    
    let pipelineDesc = MTLRenderPipelineDescriptor()
    pipelineDesc.vertexFunction = library.makeFunction(name: vertexFunctionName)
    pipelineDesc.fragmentFunction = library.makeFunction(name: fragmentFunctionName)
    pipelineDesc.colorAttachments[0].pixelFormat = pixelFormat
    
    return try! device.makeRenderPipelineState(descriptor: pipelineDesc)
  }
  
  private func makeFillEdge(dst: CGSize, src: CGSize) -> UIEdgeInsets {
    let imageRatio = src.width / src.height
    let viewRatio = dst.width / dst.height
    if viewRatio < imageRatio { // viewの方が細長い //横がはみ出るパターン //iPhoneX
      let imageWidth = dst.height * imageRatio
      let left = ((imageWidth / dst.width) - 1.0) / 2.0
      return UIEdgeInsets(top: 0, left: left, bottom: 0, right: left)
    } else if viewRatio > imageRatio { //iPad
      let viewWidth = src.height * viewRatio
      let top = ((viewWidth / src.width) - 1.0) / 2.0
      return UIEdgeInsets(top: top, left: 0, bottom: top, right: 0)
    } else {
      return UIEdgeInsets.zero
    }
  }
}
