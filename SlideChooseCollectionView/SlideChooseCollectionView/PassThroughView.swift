//
//  PassThroughView.swift
//  SlideChooseCollectionView
//
//  Created by Dinh Luu on 01/12/2016.
//  Copyright © 2016 Dinh Luu. All rights reserved.
//

import UIKit

class PassThroughView: UIView {

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return false
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    isOpaque = false
  }
  
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    
    let holeFrame = CGRect(x: rect.midX - 40.0, y: rect.midY - 40.0, width: 80.0, height: 80.0)
    let grayColor = UIColor(red: 120/255, green: 130/255, blue: 140/255, alpha: 0.7)
    grayColor.setFill()
    UIRectFill(rect)
    
    let ovalPath = UIBezierPath(ovalIn: holeFrame)
    
    context?.saveGState()
    ovalPath.addClip()
    UIColor.clear.setFill()
    UIRectFill(rect)
    
    context?.restoreGState()
  }

}
