//
//  Player.swift
//  Kitsunebi_Metal
//
//  Created by Tomoya Hirano on 2018/07/19.
//

import CoreMedia

protocol PlayerDelegate {
  func player(_ player: Player, didUpdate src: CMSampleBuffer, mask: CMSampleBuffer)
}

public class Player {
  private let srcAsset: Asset
  private let maskAsset: Asset
  internal var delegate: PlayerDelegate? = nil
  private var displayLink: CADisplayLink? = nil
  
  public init(source: SourceVideo) {
    srcAsset = Asset(url: source.src)
    maskAsset = Asset(url: source.mask)
  }
  
  public func play() {
    displayLink = CADisplayLink(target: self, selector: #selector(onDisplayLink))
    displayLink?.preferredFramesPerSecond = 60
    displayLink?.add(to: .main, forMode: .defaultRunLoopMode)
  }
  
  @objc private func onDisplayLink(_ displayLink: CADisplayLink) {
    guard let src = srcAsset.copyNextSampleBuffer() else { return }
    guard let mask = maskAsset.copyNextSampleBuffer() else { return }
    delegate?.player(self, didUpdate: src, mask: mask)
  }
}
