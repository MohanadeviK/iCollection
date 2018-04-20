//
//  ViewController.swift
//  Collection-Task
//
//  Created by Mohana on 14/04/18.
//  Copyright © 2018 F22. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var HeaderTopConstrainCollectoin: [NSLayoutConstraint]!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    //MARK: Properties
    
    let transition = CollectionPresentAnimationController()
    var isHidden:Bool = false{
        didSet{
            let duration = isHidden ? 0 : 0.5
            UIView.animate(withDuration: duration) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    var isFromCollectionView = false
    var viewSafeAreaInsetsTop = CGFloat(20.0)
    var source = [[["image" : "fav", "title" : "My collection"], ["image" : "wallet", "title" : "My wallet"], ["image" : "flag", "title" : "My paradise"]], [["image" : "happy", "title" : "After sale"], ["image" : "phone", "title" : "Customer service"]]]
    
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            self.viewSafeAreaInsetsTop = self.view.safeAreaInsets.top
        } else {
            // Fallback on earlier versions
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    override var prefersStatusBarHidden: Bool{
        return isHidden
    }
    
    //MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.backgroundImage  = UIImage()
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.initializeInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isFromCollectionView {
            // hide header
            self.hideHeader()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isFromCollectionView {
            self.hideTableViewCells()
            displayViewsWithAnimation()
        }
        isFromCollectionView = false
    }
    
    //MARK: Helper methods
    
    func initializeInterface() {
        self.tableView.tableFooterView = UIView()
    }
    
    func hideHeader() {
        for constraint in self.HeaderTopConstrainCollectoin {
            constraint.constant =  -(self.headerHeightConstraint.constant-constraint.constant-viewSafeAreaInsetsTop)
        }
    }
    
    func hideTableViewCells() {
        // hide tableview cells
        for cell in tableView.visibleCells {
            cell.frame = CGRect(x: UIScreen.main.bounds.width, y: cell.frame.origin.y, width: cell.bounds.width, height: cell.bounds.height)
        }
    }
    
    
    func displayViewsWithAnimation() {
        // show header
        for (index,constraint) in self.HeaderTopConstrainCollectoin.enumerated() {
            constraint.constant =  self.headerHeightConstraint.constant+constraint.constant-viewSafeAreaInsetsTop
            
            UIView.animate(withDuration: 0.6, delay: 0.15 + (Double(index) * 0.03), options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        // show table view cells
        for cell in tableView.visibleCells {
            if let indexPath = self.tableView.indexPath(for: cell) {
                UIView.animate(withDuration: 0.6, delay: 0.15 + (Double(indexPath.section) * 0.03), options: .curveEaseInOut, animations: {
                    cell.frame = CGRect(x: 0, y: cell.frame.origin.y, width: cell.bounds.width, height: cell.bounds.height)
                })
            }
        }
    }
}

//MARK: Extension Class

//UITableView Datasource and Delegate Methods


extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let valueDictionary = source[indexPath.section][indexPath.row]
        guard let image = valueDictionary["image"], let title = valueDictionary["title"] else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as? CollectionTableViewCell
        cell?.img.image = UIImage(named: image)
        cell?.title.text = title
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            DispatchQueue.main.async {
                let vC = self.storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController
                vC?.transitioningDelegate = self
                vC?.delegate = self
                self.tabBarController?.present(vC!, animated: true, completion: nil)
            }
        }
    }
}

extension ViewController  : UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
}

extension ViewController : CollectionViewControllerDelegate {
    func didCollectionViewControllerDismissed() {
        isFromCollectionView = true
    }
}

