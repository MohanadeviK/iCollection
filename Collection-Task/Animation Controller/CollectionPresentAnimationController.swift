//
//  CollectionPresentAnimationController.swift
//  Collection-Task
//
//  Created by Mohana on 18/04/18.
//  Copyright © 2018 F22. All rights reserved.
//

import UIKit

class CollectionPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning{
    
    //MARK: Properties
    
    var presenting = true
    
    //MARK: Helper Methods
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        if self.presenting {
            guard let toVC = transitionContext.viewController(forKey: .to) as? CollectionViewController
                else {
                    return
            }
            
            let containerView = transitionContext.containerView
            containerView.addSubview(toVC.view)
            
            // slide animation
            toVC.view.frame  = CGRect(x: +toVC.view.bounds.width, y: 0, width: toVC.view.bounds.width, height: toVC.view.bounds.height)
            
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: .curveEaseInOut,
                           animations: { () -> Void in
                            toVC.view.frame  = CGRect(x:0, y: 0, width: toVC.view.bounds.width, height: toVC.view.bounds.height)
            }, completion: { (flag) in
                transitionContext.completeTransition(true)
            })
            
            // header animation
            toVC.headerTopConstraint.constant = -toVC.headerHeightConstraint.constant - 64
            toVC.view.layoutIfNeeded()
            
            toVC.headerTopConstraint.constant = 0
            
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: .curveEaseInOut,
                           animations: { () -> Void in
                            toVC.view.layoutIfNeeded()
            }, completion: { (flag) in
                transitionContext.completeTransition(true)
            })
            
            // collectionView animation
            
            let cells = toVC.collectionView.visibleCells.sorted {
                if let firstCellIndexPath = toVC.collectionView.indexPath(for: $0), let secondCellIndexPath = toVC.collectionView.indexPath(for: $1) {
                    return firstCellIndexPath.item < secondCellIndexPath.item
                }
                return false
            }
            
            for (index,cell) in cells.enumerated() {
                
                cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y + 100, width: cell.bounds.width, height: cell.bounds.height)
                let delay = (index == 0) ? 0 :  (0.15 + (Double(index - 1) * 0.05)) // delay for animation between each cell
                UIView.animate(withDuration: duration - delay , delay: delay, options: .curveEaseInOut, animations: {
                    cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y - 100, width: cell.bounds.width, height: cell.bounds.height)
                })
            }
        }
        else {
            transitionContext.completeTransition(true) // dismiss view controller
        }
    }
}
