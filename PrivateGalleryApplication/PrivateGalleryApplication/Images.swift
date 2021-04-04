//
//  Images.swift
//  CollectionView
//
//  Created by Andrew on 4/4/21.
//  Copyright © 2021 Andrew. All rights reserved.
//

import Foundation
import UIKit


struct Image {
}

extension UIViewController {

    func pushView(viewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        self.view.window!.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func dismissView() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        navigationController!.popViewController(animated: true)
    }
}







/*
extension UIView {

    func  addTapGesture(action : @escaping ()->Void ){
        let tap = TapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = 1

        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }

    @objc func handleTap(_ sender: TapGestureRecognizer) {
        sender.action!()
    }
}


class TapGestureRecognizer: UITapGestureRecognizer {
    var action : (()->Void)? = nil
}
*/


