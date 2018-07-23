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

public class Player: NSObject {
  private let srcAsset: Asset
  private let maskAsset: Asset
  internal var delegate: PlayerDelegate? = nil
  private lazy var displayLink: CADisplayLink = .init(target: WeakProxy(target: self), selector: #selector(Player.onDisplayLink))
  private lazy var renderThread: Thread = .init(target: WeakProxy(target: self), selector: #selector(Player.threadLoop), object: nil)
  private let fpsKeeper: FPSKeeper
  private var isRunningTheread = true
  
  public init(source: SourceVideo) {
    srcAsset = Asset(url: source.src)
    maskAsset = Asset(url: source.mask)
    fpsKeeper = FPSKeeper(fps: source.fps)
    super.init()
  }
  
  deinit {
    print("deinit")
  }
  
  public func play() {
    renderThread.start()
  }
  
  public func cancel() {
    guard isRunningTheread else { return }
    isRunningTheread = false
    displayLink.remove(from: .current, forMode: .commonModes)
    displayLink.invalidate()
    renderThread.cancel()
    srcAsset.cancel()
    maskAsset.cancel()
  }
  
  @objc private func threadLoop() -> Void {
    displayLink.add(to: .current, forMode: .commonModes)
    displayLink.preferredFramesPerSecond = 0
    
    while isRunningTheread {
      RunLoop.current.run(until: Date(timeIntervalSinceNow: 1/60))
    }
  }
  
  @objc private func onDisplayLink(_ displayLink: CADisplayLink) {
    if srcAsset.status != .reading || maskAsset.status != .reading {
      cancel()
    }
    
    guard fpsKeeper.checkPast1Frame(displayLink) else { return }
    #if DEBUG
    FPSDebugger.shared.update(displayLink)
    #endif
    guard let src = srcAsset.copyNextSampleBuffer() else { return }
    guard let mask = maskAsset.copyNextSampleBuffer() else { return }
    delegate?.player(self, didUpdate: src, mask: mask)
  }
}




