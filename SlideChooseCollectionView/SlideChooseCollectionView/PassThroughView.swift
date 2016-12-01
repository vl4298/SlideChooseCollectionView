//
//  PassThroughView.swift
//  SlideChooseCollectionView
//
//  Created by Dinh Luu on 01/12/2016.
//  Copyright © 2016 Dinh Luu. All rights reserved.
//

import UIKit

class PassThroughView: UIView {

  override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    return false
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    opaque = false
  }
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    
    let holeFrame = CGRect(x: CGRectGetMidX(rect) - 40.0, y: CGRectGetMidY(rect) - 40.0, width: 80.0, height: 80.0)
    let grayColor = UIColor(red: 120/255, green: 130/255, blue: 140/255, alpha: 0.7)
    grayColor.setFill()
    UIRectFill(rect)
    
    let ovalPath = UIBezierPath(ovalInRect: holeFrame)
    
    CGContextSaveGState(context)
    ovalPath.addClip()
    UIColor.clearColor().setFill()
    UIRectFill(rect)
    
    CGContextRestoreGState(context)
  }

}
