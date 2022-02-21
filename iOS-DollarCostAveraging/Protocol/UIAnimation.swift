//
//  UIAnimation.swift
//  iOS-DollarCostAveraging
//
//  Created by Marina McPeak on 2022-02-20.
//

import Foundation
import MBProgressHUD

protocol UIAnimation where Self: UIViewController {
    func showLoadingAnimation()
    func hideLoadingAnimation()
}

extension UIAnimation {
    func showLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func hideLoadingAnimation(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
