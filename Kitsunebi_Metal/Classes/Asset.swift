//
//  Asset.swift
//  Kitsunebi_Metal
//
//  Created by Tomoya Hirano on 2018/07/19.
//

import AVFoundation

internal class Asset {
  private let outputSettings: [String : Any] = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
  private let reader: AVAssetReader
  private let output: AVAssetReaderTrackOutput
  private let asset: AVURLAsset
  internal var status: AVAssetReaderStatus { return reader.status }
  
  init(url: URL) {
    self.asset = AVURLAsset(url: url)
    self.reader = try! AVAssetReader(asset: asset)
    let track = asset.tracks(withMediaType: AVMediaType.video)[0]
    self.output = .init(track: track, outputSettings: outputSettings)
    if reader.canAdd(output) {
      reader.add(output)
    }
    output.alwaysCopiesSampleData = false
    reader.startReading()
  }
  
  deinit {
    cancel()
  }
  
  internal func cancel() {
    reader.cancelReading()
  }
  
  internal func copyNextSampleBuffer() -> CMSampleBuffer? {
    return output.copyNextSampleBuffer()
  }
}
