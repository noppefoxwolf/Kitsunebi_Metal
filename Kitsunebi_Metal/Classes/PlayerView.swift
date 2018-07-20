//
//  PlayerView.swift
//  Kitsunebi_Metal
//
//  Created by Tomoya Hirano on 2018/07/19.
//

import UIKit
import Metal
import QuartzCore
import CoreMedia

public class PlayerView: UIView, PlayerDelegate {
  private lazy var engine: PlayerViewEngine = .init(device: metalLayer.device!)
  public var player: Player? = nil {
    didSet { player?.delegate = self }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    backgroundColor = .clear
    metalLayer.pixelFormat = .bgra8Unorm
    metalLayer.framebufferOnly = false
    metalLayer.presentsWithTransaction = false
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    metalLayer.drawableSize = bounds.size
  }
  
  func player(_ player: Player, didUpdate src: CMSampleBuffer, mask: CMSampleBuffer) {
    guard let drawable = metalLayer.nextDrawable() else { return }
    engine.render(to: drawable, src: src, mask: mask)
  }
}

// setup MetalLayer
extension PlayerView {
  public override class var layerClass: Swift.AnyClass {
    return CAMetalLayer.self
  }
  
  internal var metalLayer: CAMetalLayer {
    return layer as! CAMetalLayer
  }
}
