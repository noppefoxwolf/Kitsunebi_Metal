//
//  MTLTexture+Extensions.swift
//  Kitsunebi_Metal
//
//  Created by Tomoya Hirano on 2018/07/20.
//

import Metal

extension MTLTexture {
  internal var size: CGSize {
    return CGSize(width: width, height: height)
  }
}

