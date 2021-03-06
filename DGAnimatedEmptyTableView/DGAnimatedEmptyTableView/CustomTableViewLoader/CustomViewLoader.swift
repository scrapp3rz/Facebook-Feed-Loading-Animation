//
//  CustomTableViewLoader.swift
//  EPGA
//
//  Created by developer on 18/07/18.
//  Copyright © 2018 Rahul Dasgupta. All rights reserved.
//

import UIKit

class CustomViewLoader: NSObject, UITableViewDelegate,UITableViewDataSource {
    private var customTableView: UITableView!
    private var customCellIdentifier:String! = "cell"
    private var gradientMask: CAGradientLayer!
    private var isAnimating: Bool = false
    private var sourceViewController: UIViewController!
    private var heightOfCell: CGFloat = 50
    var gradientColor: UIColor! = UIColor.white
    private var customView: UIView!
    override init() {
        super.init()
    }
    
    init(customTableView:UITableView,customCellIdentifier:String,sourceViewController: UIViewController,heightOfCell: CGFloat = 50) {
        self.customTableView = customTableView
        self.customCellIdentifier = customCellIdentifier
        self.sourceViewController = sourceViewController
        self.heightOfCell = heightOfCell
    }
    
    init(customView:UIView,sourceViewController: UIViewController) {
        self.customView = customView
        self.sourceViewController = sourceViewController
    }
    
    func startAnimating() {
        if customTableView != nil {
            gradientMask = CAGradientLayer()
            gradientMask.frame = self.customTableView.bounds
            addGradientMaskToView(view: self.customTableView)
            isAnimating = true
            if customTableView != nil {
                customTableView.delegate = self
                customTableView.dataSource = self
                customTableView.reloadData()
            }
            else {
                print("Please initialize the tableView.")
            }
        }
        else {
            if customView != nil {
                gradientMask = CAGradientLayer()
                gradientMask.frame = self.customView.bounds
                addGradientMaskToView(view: self.customView)
                isAnimating = true
                sourceViewController.configEmpty(self.customView)
            }
            else {
                print("Please initialize the view.")
            }
            
        }
    }
    
    func stopAnimating() {
        if customTableView != nil {
            gradientMask.removeAllAnimations()
            gradientMask = nil
            isAnimating = false
            if customTableView != nil {
                customTableView.delegate = sourceViewController as? UITableViewDelegate
                customTableView.dataSource = sourceViewController as? UITableViewDataSource
                customTableView.reloadData()
            }
            else {
                print("Please initialize the tableView.")
            }
        }
        else {
            if customView != nil {
                gradientMask.removeAllAnimations()
                gradientMask = nil
                isAnimating = false
            }
            else {
                print("Please initialize the view.")
            }
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customCellIdentifier, for: indexPath)
        sourceViewController.configEmpty(cell, at: indexPath)
        return cell
    }
    
    func addGradientMaskToView(view:UIView, transparency:CGFloat = 0.6, gradientWidth:CGFloat = 100) {
        if gradientMask != nil {
            gradientMask.removeAnimation(forKey: "rotation")
        }
        let gradientSize = gradientWidth/view.frame.size.width
        let gradientMaskColor = UIColor(white: 1, alpha: transparency)
        let startLocations = [0, gradientSize/2, gradientSize]
        let endLocations = [(1 - gradientSize), (1 - gradientSize/2), 1]
        let animation = CABasicAnimation(keyPath: "locations")
        
        gradientMask.colors = [gradientMaskColor.cgColor, gradientColor, gradientMaskColor.cgColor]
        gradientMask.locations = startLocations as [NSNumber]?
        gradientMask.startPoint = CGPoint(x:0 - (gradientSize * 2), y: 0.5)
        gradientMask.endPoint = CGPoint(x:1 + gradientSize, y: 0.5)
        
        view.layer.mask = gradientMask
        animation.fromValue = startLocations
        animation.toValue = endLocations
        animation.repeatCount = HUGE
        animation.duration = 2
        
        gradientMask.add(animation, forKey: "rotation")
        
    }
}

extension UIViewController {
    @objc func configEmpty(_ cell: UITableViewCell,at indexPath: IndexPath) {
        print("Config the cell")
    }
    
    @objc func configEmpty(_ view: UIView) {
        print("Config the view")
    }
}

