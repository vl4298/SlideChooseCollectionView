//
//  ViewController.swift
//  SlideChooseCollectionView
//
//  Created by Dinh Luu on 22/09/2016.
//  Copyright © 2016 Dinh Luu. All rights reserved.
//

import UIKit

extension CGFloat {
  static func random() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
  }
}

extension UIColor {
  static func randomColor() -> UIColor {
    // If you wanted a random alpha, just create another
    // random number for that too.
    return UIColor(red:   .random(),
                   green: .random(),
                   blue:  .random(),
                   alpha: 1.0)
  }
}

class ViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  var preSelectedItem = 0
  var displayLink: CADisplayLink?
  var finalContentOffsetX: CGFloat = 0
  var lastTimeTick: TimeInterval = 0
  var animationPointPerSecond: Double = 300
  var isLeft: CGFloat = 1
  var model = [
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
    UIColor.randomColor(),
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.contentInset.left = view.bounds.width/2 - 40.0
    collectionView.contentInset.right = view.bounds.width/2 - 40.0
  }
  
}

// MARK: CollectionView
extension ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
    cell.backgroundColor = model[(indexPath as NSIndexPath).item]
    cell.layer.cornerRadius = 40.0
    return cell
  }
  
}

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    if (indexPath as NSIndexPath).item == 0 { return false }
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    isLeft = CGFloat(indexPath.item - preSelectedItem)
    preSelectedItem = (indexPath as NSIndexPath).item
    let finalOffsetX = collectionView.contentOffset.x + (110 * isLeft)
    beginAnimation(finalOffsetX)
  }
  
  func beginAnimation(_ finalContentOffsetX: CGFloat) {
    lastTimeTick = 0
    self.finalContentOffsetX = finalContentOffsetX
    displayLink = CADisplayLink(target: self, selector: #selector(self.displayLinkTick))
    displayLink!.frameInterval = 1
    displayLink!.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
  }
  
  func endAnimation() {
    displayLink!.invalidate()
    displayLink = nil
  }
  
  func displayLinkTick() {
    if lastTimeTick == 0 {
      lastTimeTick = displayLink!.timestamp
    }
    
    let currentTimestamp = displayLink!.timestamp
    let delta = CGFloat(animationPointPerSecond * (currentTimestamp - lastTimeTick))
    if isLeft > 0 {
      collectionView.contentOffset.x += delta
    } else {
      collectionView.contentOffset.x -= delta
    }
    lastTimeTick = currentTimestamp
    
    if (collectionView.contentOffset.x > finalContentOffsetX && isLeft > 0) || (collectionView.contentOffset.x < finalContentOffsetX && isLeft < 0) {
      collectionView.contentOffset.x = finalContentOffsetX
      endAnimation()
    }
  }
}

// MARK: UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let centerPoint = view.center
    let centerPointInScrollView = scrollView.convert(centerPoint, from: view)
    let currentIndexPath = collectionView.indexPathForItem(at: centerPointInScrollView)
    preSelectedItem = currentIndexPath!.item
  }
}

