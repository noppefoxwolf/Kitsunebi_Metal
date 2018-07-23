//
//  WeakProxy.swift
//  Kitsunebi_Metal
//
//  Created by Tomoya Hirano on 2018/07/23.
//

import Foundation

final internal class WeakProxy: NSObject {
  weak var target: NSObjectProtocol?
  
  init(target: NSObjectProtocol) {
    self.target = target
    super.init()
  }
  
  override func responds(to aSelector: Selector!) -> Bool {
    return (target?.responds(to: aSelector) ?? false) || super.responds(to: aSelector)
  }
  
  override func forwardingTarget(for aSelector: Selector!) -> Any? {
    return target
  }
}
