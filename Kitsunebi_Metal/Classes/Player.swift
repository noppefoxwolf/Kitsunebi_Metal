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
  private lazy var displayLink: CADisplayLink = .init(target: self, selector: #selector(Player.update))
  private lazy var renderThread: Thread = .init(target: self, selector: #selector(Player.threadLoop), object: nil)
  private let fpsKeeper: FPSKeeper
  
  public init(source: SourceVideo) {
    srcAsset = Asset(url: source.src)
    maskAsset = Asset(url: source.mask)
    fpsKeeper = FPSKeeper(fps: 30)
  }
  
  public func play() {
    renderThread.start()
//    displayLink = CADisplayLink(target: self, selector: #selector(onDisplayLink))
//    displayLink?.preferredFramesPerSecond = 30
//    displayLink?.add(to: .main, forMode: .defaultRunLoopMode)
  }
  
  @objc private func onDisplayLink(_ displayLink: CADisplayLink) {
    guard let src = srcAsset.copyNextSampleBuffer() else { return }
    guard let mask = maskAsset.copyNextSampleBuffer() else { return }
    delegate?.player(self, didUpdate: src, mask: mask)
  }
  
  @objc private func threadLoop() -> Void {
    displayLink.add(to: .current, forMode: .commonModes)
    displayLink.preferredFramesPerSecond = 0
    
    while true {
      RunLoop.current.run(until: Date(timeIntervalSinceNow: 1/30))
    }
  }
  
  @objc private func update(_ link: CADisplayLink) {
    guard fpsKeeper.checkPast1Frame(link) else { return }
    guard let src = srcAsset.copyNextSampleBuffer() else { return }
    guard let mask = maskAsset.copyNextSampleBuffer() else { return }
    delegate?.player(self, didUpdate: src, mask: mask)
  }
}
