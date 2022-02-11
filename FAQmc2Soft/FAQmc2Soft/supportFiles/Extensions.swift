//
//  Extensions.swift
//  FAQmc2Soft
//
//  Created by Акифьев Максим  on 09.02.2022.
//
 
import UIKit

public protocol ActivityIndicatorPresenter {
    
    var activityIndicator: UIActivityIndicatorView! { get }
    func showActivityIndicator()
    func hideActivityIndicator()
}

public extension ActivityIndicatorPresenter where Self: UIViewController {
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.backgroundColor = (UIColor (white: 0.8, alpha: 0.8))
            self.activityIndicator.layer.cornerRadius = 10
            self.activityIndicator.style = .gray
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            self.activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}
