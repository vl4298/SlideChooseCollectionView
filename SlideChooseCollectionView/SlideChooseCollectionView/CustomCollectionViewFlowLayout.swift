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
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let attributesArray = super.layoutAttributesForElements(in: rect) else { return nil }
    
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
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let attribute = super.layoutAttributesForItem(at: indexPath) else { return nil }
    
    let visibleRect = CGRect(x: collectionView!.contentOffset.x,
                             y: collectionView!.contentOffset.y,
                             width: collectionView!.bounds.width,
                             height: collectionView!.bounds.height)
    apply(layoutAttributes: attribute, for: visibleRect)
    
    return attribute
  }
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    var offsetAdjust: CGFloat = 10000
    let horizontalCenter = proposedContentOffset.x + collectionView!.bounds.width / 2
    
    let proposedRect = CGRect(x: proposedContentOffset.x,
                              y: 0.0,
                              width: collectionView!.bounds.width,
                              height: collectionView!.bounds.height)
    
    guard let attributesArray = super.layoutAttributesForElements(in: proposedRect) else { return proposedContentOffset }
    
    for attribute in attributesArray {
      if case UICollectionElementCategory.supplementaryView = attribute.representedElementCategory { continue }
      
      let itemHorizontalCenter = attribute.center.x
      if fabs(itemHorizontalCenter - horizontalCenter) < fabs(offsetAdjust) {
        offsetAdjust = itemHorizontalCenter - horizontalCenter
      }
    }
    
    return CGPoint(x: proposedContentOffset.x + offsetAdjust, y: proposedContentOffset.y + offsetAdjust)
  }
  
  
  func apply(layoutAttributes attributes: UICollectionViewLayoutAttributes, for visibleRect: CGRect) {
    
    let ACTIVE_DISTANCE = collectionView!.bounds.width + 160.0
    // skip supplementary kind
    if case UICollectionElementCategory.supplementaryView = attributes.representedElementCategory { return }
    
    let distanceFromVisibleRectToItem: CGFloat = visibleRect.midX - attributes.center.x

    var transform: CATransform3D!
    if fabs(distanceFromVisibleRectToItem) < ACTIVE_DISTANCE {
      
      let normalizeDistance = fabs(distanceFromVisibleRectToItem) / ACTIVE_DISTANCE
      
      let factorScale = 1 - normalizeDistance
      //let factorScale: CGFloat = 1.0
      transform = CATransform3DScale(CATransform3DIdentity, factorScale, factorScale, 1.0)
      attributes.zIndex = 1
      attributes.transform3D = transform
    } else {
      transform = CATransform3DIdentity
      attributes.transform3D = transform
    }
    
  }
}
