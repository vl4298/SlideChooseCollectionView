//
//  CustomCollectionViewFlowLayout.swift
//  SlideChooseCollectionView
//
//  Created by Dinh Luu on 01/12/2016.
//  Copyright © 2016 Dinh Luu. All rights reserved.
//

import UIKit

protocol CustomCollectionViewFlowLayoutDelegate: class {
  func centerItemRect() -> CGRect
}

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
  
  weak var delegate: CustomCollectionViewFlowLayoutDelegate!
  var centerItemRect: CGRect?
  
  override init() {
    super.init()
    
    itemSize = CGSize(width: 80.0, height: 80.0)
    minimumLineSpacing = 30.0
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    itemSize = CGSize(width: 80.0, height: 80.0)
    minimumLineSpacing = 30.0
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let attributesArray = super.layoutAttributesForElementsInRect(rect) else { return nil }
    
    guard let collectionView = self.collectionView else { return attributesArray }
    
    let visibleRect = CGRect(x: collectionView.contentOffset.x,
                             y: collectionView.contentOffset.y,
                             width: collectionView.bounds.width,
                             height: collectionView.bounds.height)
    
    for attribute in attributesArray {
      apply(layoutAttributes: attribute, for: visibleRect)
    }
    
    return attributesArray
  }
  
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    guard let attribute = super.layoutAttributesForItemAtIndexPath(indexPath) else { return nil }
    
    let visibleRect = CGRect(x: collectionView!.contentOffset.x,
                             y: collectionView!.contentOffset.y,
                             width: collectionView!.bounds.width,
                             height: collectionView!.bounds.height)
    apply(layoutAttributes: attribute, for: visibleRect)
    
    return attribute
  }
  
  override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    var offsetAdjust: CGFloat = 10000
    let horizontalCenter = proposedContentOffset.x + collectionView!.bounds.width / 2
    
    let proposedRect = CGRect(x: proposedContentOffset.x,
                              y: 0.0,
                              width: collectionView!.bounds.width,
                              height: collectionView!.bounds.height)
    
    guard let attributesArray = super.layoutAttributesForElementsInRect(proposedRect) else { return proposedContentOffset }
    
    for attribute in attributesArray {
      if case UICollectionElementCategory.SupplementaryView = attribute.representedElementCategory { continue }
      
      let itemHorizontalCenter = attribute.center.x
      if fabs(itemHorizontalCenter - horizontalCenter) < fabs(offsetAdjust) {
        offsetAdjust = itemHorizontalCenter - horizontalCenter
      }
    }
    
    return CGPoint(x: proposedContentOffset.x + offsetAdjust, y: proposedContentOffset.y + offsetAdjust)
  }
  
  
  func apply(layoutAttributes attributes: UICollectionViewLayoutAttributes, for visibleRect: CGRect) {
    
    let ACTIVE_DISTANCE = collectionView!.bounds.width / 2 + 40.0
    
    // skip supplementary kind
    if case UICollectionElementCategory.SupplementaryView = attributes.representedElementCategory { return }
    
    let distanceFromVisibleRectToItem: CGFloat = CGRectGetMidX(visibleRect) - attributes.center.x
    
    var transform: CATransform3D!
    if fabs(distanceFromVisibleRectToItem) < ACTIVE_DISTANCE {
      
      let normalizeDistance = fabs(distanceFromVisibleRectToItem) / ACTIVE_DISTANCE
      
      let factorScale = 1 - normalizeDistance
      //let factorScale: CGFloat = 1.0
      transform = CATransform3DScale(CATransform3DIdentity, factorScale, factorScale, 1.0)
      attributes.zIndex = 1
      attributes.transform3D = transform
      if factorScale == 1 && centerItemRect == nil {
        centerItemRect = attributes.frame
      }
    } else {
      transform = CATransform3DIdentity
      attributes.transform3D = transform
    }
    
  }
}
