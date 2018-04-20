//
//  CollectionViewController.swift
//  Collection-Task
//
//  Created by Mohana on 18/04/18.
//  Copyright © 2018 F22. All rights reserved.
//

import UIKit

//Custom Delegate

protocol CollectionViewControllerDelegate {
    func didCollectionViewControllerDismissed()
}

class CollectionViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerMarkWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerMarkLeftConstraint: NSLayoutConstraint!
    
    //MARK: Properties
    
    var tableVeiwSorceArray = ["", "", "", "", "", ""]
    let MARKER_WIDTH = CGFloat(25)
    let COLLECTION_CELL_PADDING = 16
    var delegate : CollectionViewControllerDelegate?
    var selectedIndexPath : IndexPath!
    
    //MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.alpha = 0
        //  make nav bar transparent
        self.navBar.setBackgroundImage(UIImage(), for: .default)
        self.navBar.shadowImage = UIImage()
        self.navBar.isTranslucent = true
        
        //make header marker to center of first tab
        let xValue = ((UIScreen.main.bounds.width/2)/2)-(MARKER_WIDTH/2)
        headerMarkLeftConstraint.constant = xValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.navBar.alpha = 1
        }
        for cell in self.tableView.visibleCells {
            cell.frame = CGRect(x: cell.frame.origin.x + UIScreen.main.bounds.width, y: cell.frame.origin.y, width: cell.bounds.width, height: cell.bounds.height)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let delegate = self.delegate {
            delegate.didCollectionViewControllerDismissed()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.profileImg.layer.cornerRadius = self.profileImg.bounds.width/2
        self.profileImg.clipsToBounds = true
    }
    
    //MARK: Helper Methods
    
    @objc func btnFavOnClick(sender : UIButton) {
        let cell = sender.superview?.superview?.superview as? ProductTableViewCell
        if let selectedCell = cell {
            self.selectedIndexPath = self.tableView.indexPath(for: selectedCell)
            
            let snapshot = sender.superview!.snapshotView(afterScreenUpdates: true)
            snapshot?.frame = sender.superview!.bounds
            snapshot?.tag = 99
            sender.superview?.superview?.addSubview(snapshot!)
            
            UIView.transition(from: snapshot!, to: snapshot!, duration: 0.5, options: .transitionFlipFromTop){ (flag) in
                snapshot?.removeFromSuperview()
            }
            
            self.tableVeiwSorceArray.remove(at: self.selectedIndexPath.row)
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: .curveEaseInOut,
                           animations: { () -> Void in
                            snapshot?.alpha = 0
            },completion: { (flag) in
                snapshot?.layer.removeAllAnimations()
                self.tableView.deleteRows(at: [self.selectedIndexPath], with: .fade)
                
            })
        }
    }
    
    func headerMarkMoveToRelease() {
        //incrate width of marker
        let xValue = ((UIScreen.main.bounds.width/2)/2)-(MARKER_WIDTH/2)
        let width = UIScreen.main.bounds.width - (xValue * 2)
        headerMarkWidthConstraint.constant = width
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.view.layoutIfNeeded()
        })
        
        // move marker
        headerMarkWidthConstraint.constant = MARKER_WIDTH
        headerMarkLeftConstraint.constant =  UIScreen.main.bounds.width - xValue - MARKER_WIDTH
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.3,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.view.layoutIfNeeded()
        })
    }
    
    
    func headerMarkMoveToCommondity() {
        //incrate width of marker and move
        let xValue = ((UIScreen.main.bounds.width/2)/2)-(MARKER_WIDTH/2)
        headerMarkLeftConstraint.constant = xValue
        let width = UIScreen.main.bounds.width - (xValue * 2)
        headerMarkWidthConstraint.constant = width
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.view.layoutIfNeeded()
        })
        
        // reduce width of marker
        headerMarkWidthConstraint.constant = MARKER_WIDTH
        UIView.animate(withDuration: 0.3,
                       delay: 0.3,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.view.layoutIfNeeded()
        })
    }
    
    //MARK: Actions
    
    @IBAction func backOnClick(_ sender: Any) {
        // dismiss view controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func RleaseTabOnClick(_ sender: Any) {
        self.headerMarkMoveToRelease()
        
        // Show tableview
        self.view.bringSubview(toFront: self.tableView)
        let collectionViewCells = self.collectionView.visibleCells.sorted {
            if let firstCellIndexPath = self.collectionView.indexPath(for: $0), let secondCellIndexPath = self.collectionView.indexPath(for: $1) {
                return firstCellIndexPath.item < secondCellIndexPath.item
            }
            return false
        }
        
        for (index,cell) in collectionViewCells.enumerated() {
            let delay = (index == 0) ? 0 :  (0.15 + (Double(index - 1) * 0.05)) // delay for animation between each cell
            UIView.animate(withDuration: 0.6 , delay: delay, options: .curveEaseInOut, animations: {
                cell.frame = CGRect(x: cell.frame.origin.x - UIScreen.main.bounds.width, y: cell.frame.origin.y, width: cell.bounds.width, height: cell.bounds.height)
            })
        }
        
        
        let tableViewCells = self.tableView.visibleCells.sorted {
            if let firstCellIndexPath = self.tableView.indexPath(for: $0), let secondCellIndexPath = self.tableView.indexPath(for: $1) {
                return firstCellIndexPath.item < secondCellIndexPath.item
            }
            return false
        }
        
        for (index,cell) in tableViewCells.enumerated() {
            let delay = 0.15 + (Double(index) * 0.05)// delay for animation between each cell
            UIView.animate(withDuration: 0.6 , delay: delay, options: .curveEaseInOut, animations: {
                cell.frame = CGRect(x: cell.frame.origin.x - UIScreen.main.bounds.width, y: cell.frame.origin.y, width: cell.bounds.width, height: cell.bounds.height)
            })
        }
    }
    
    @IBAction func CommondityTabOnClick(_ sender: Any) {
        self.headerMarkMoveToCommondity()
        //Show collection view
        
        self.view.bringSubview(toFront: self.collectionView)
        self.collectionView.backgroundColor = UIColor.clear
        
        let tableViewCells = self.tableView.visibleCells.sorted {
            if let firstCellIndexPath = self.tableView.indexPath(for: $0), let secondCellIndexPath = self.tableView.indexPath(for: $1) {
                return firstCellIndexPath.item > secondCellIndexPath.item
            }
            return false
        }
        
        for (index,cell) in tableViewCells.enumerated() {
            let delay = (index == 0) ? 0 :  (0.15 + (Double(index - 1) * 0.05)) // delay for animation between each cell
            UIView.animate(withDuration: 0.6 , delay: delay, options: .curveEaseInOut, animations: {
                cell.frame = CGRect(x: cell.frame.origin.x + UIScreen.main.bounds.width, y: cell.frame.origin.y, width: cell.bounds.width, height: cell.bounds.height)
            })
        }
        
        let collectionViewCells = self.collectionView.visibleCells.sorted {
            if let firstCellIndexPath = self.collectionView.indexPath(for: $0), let secondCellIndexPath = self.collectionView.indexPath(for: $1) {
                return firstCellIndexPath.item > secondCellIndexPath.item
            }
            return false
        }
        
        for (index,cell) in collectionViewCells.enumerated() {
            let delay =  0.15 + (Double(index) * 0.05) // delay for animation between each cell
            UIView.animate(withDuration: 0.6 , delay: delay, options: .curveEaseInOut, animations: {
                cell.frame = CGRect(x: cell.frame.origin.x + UIScreen.main.bounds.width, y: cell.frame.origin.y, width: cell.bounds.width, height: cell.bounds.height)
            })
        }
    }
}


//MARK: Extension Class

//UICollectionView Datasource and Delegate Methods

extension CollectionViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = floor((UIScreen.main.bounds.width - CGFloat(COLLECTION_CELL_PADDING * 3))/2)
        return CGSize(width: size, height: size)
    }
}

//UITableView Datasource and Delegate Methods

extension CollectionViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableVeiwSorceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell
        cell?.btnFav.addTarget(self, action: #selector(self.btnFavOnClick(sender:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}

