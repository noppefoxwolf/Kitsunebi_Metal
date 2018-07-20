//
//  ViewController.swift
//  Kitsunebi_Metal
//
//  Created by noppefoxwolf on 07/19/2018.
//  Copyright (c) 2018 noppefoxwolf. All rights reserved.
//

import UIKit
import Kitsunebi_Metal

class ViewController: UIViewController {
  @IBOutlet weak var playerView: PlayerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let src = Bundle.main.url(forResource: "main", withExtension: "mp4")!
    let mask = Bundle.main.url(forResource: "alpha", withExtension: "mp4")!
    let source = SourceVideo(src: src, mask: mask)
    let player = Player(source: source)
    
    playerView.player = player
    
    player.play()
  }
}

