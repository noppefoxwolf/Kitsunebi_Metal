//
//  KitsunebiMetal.swift
//  Kitsunebi_Metal
//
//  Created by Tomoya Hirano on 2018/07/20.
//

import Metal

public struct KitsunebiMetal {
  public static var isSupported: Bool {
    return MTLCreateSystemDefaultDevice() != nil
  }
}
