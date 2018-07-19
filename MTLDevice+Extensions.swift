//
//  MTLDevice+Extensions.swift
//  Kitsunebi_Metal
//
//  Created by Tomoya Hirano on 2018/07/19.
//

import Metal

extension MTLDevice {
  internal func makeTexureCoordBuffer() -> MTLBuffer {
    let texCoordinateData: [Float] = [0,1,
                                      1,1,
                                      0,0,
                                      1,0]
    let texCoordinateDataSize = texCoordinateData.count * MemoryLayout<Float>.size
    return makeBuffer(bytes: texCoordinateData, length: texCoordinateDataSize)!
  }
  
  internal func makeVertexBuffer() -> MTLBuffer {
    let vertexData: [Float] = [-1,-1, 0, 1,
                               1,-1, 0, 1,
                               -1, 1, 0, 1,
                               1, 1, 0, 1]
    let size = vertexData.count * MemoryLayout<Float>.size
    return makeBuffer(bytes: vertexData, length: size)!
  }
}


