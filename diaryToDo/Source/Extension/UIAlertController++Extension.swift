//
//  UIAlertController++Extension.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/29.
//

import UIKit

extension UIAlertController {
    static func showAlert(message: String, vc: UIViewController) {
        let alert = UIAlertController(title: "⚠️", message: message , preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        vc.present(alert, animated: true, completion: nil)
        
    }
}
