//
//  SourceVideo.swift
//  Kitsunebi_Metal
//
//  Created by Tomoya Hirano on 2018/07/19.
//

import UIKit

public struct SourceVideo {
  internal var src: URL
  internal var mask: URL
  
  public init(src: URL, mask: URL) {
    self.src = src
    self.mask = mask
  }
}
