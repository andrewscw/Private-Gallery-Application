//
//  PwChangeViewController.swift
//  PrivateGalleryApplication
//
//  Created by Andrew on 5/4/21.
//  Copyright © 2021 Andrew. All rights reserved.
//

import UIKit

class PwChangeViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()

    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = -5
        label.numberOfLines = 0
        label.highlightedTextColor = .gray
        label.textColor = .white
        label.text = "Change Password"
        label.textAlignment = .center
        
        return label
    }()
    
    private let currentField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Current Password"
        field.leftView = UIView(frame: CGRect(x:0, y:0, width:5, height:0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let newField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "New Password"
        field.leftView = UIView(frame: CGRect(x:0, y:0, width:5, height:0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let newConfirmField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Confirm New Password"
        field.leftView = UIView(frame: CGRect(x:0, y:0, width:5, height:0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let changepwButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Password", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "Change Password"
        // Do any additional setup after loading the view.
        
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(currentField)
        scrollView.addSubview(newField)
        scrollView.addSubview(newConfirmField)
        scrollView.addSubview(changepwButton)
        
        
        changepwButton.addTarget(self,
                              action: #selector(ChangepwButtonTapped),
                              for: .touchUpInside)
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        
        titleLabel.frame = CGRect(x: 30,
                                 y: 20,
                                 width: scrollView.width-60,
                                 height: 52)
        
        currentField.frame = CGRect(x: 30,
                                 y: 200,
                                 width: scrollView.width-60,
                                 height: 52)
        
        newField.frame = CGRect(x: 30,
                                 y: currentField.bottom+10,
                                 width: scrollView.width-60,
                                 height: 52)
        
        newConfirmField.frame = CGRect(x: 30,
                                 y: newField.bottom+10,
                                 width: scrollView.width-60,
                                 height: 52)
        changepwButton.frame = CGRect(x: 30,
                                 y: newConfirmField.bottom+10,
                                 width: scrollView.width-60,
                                 height: 52)
        
    }
    
    @objc private func ChangepwButtonTapped(){
        currentField.resignFirstResponder()
        newField.resignFirstResponder()
        newConfirmField.resignFirstResponder()
        
        
        let password = newField.text
        guard let storedPassword = UserDefaults().value(forKey: "password") as? String else {
            return
        }
        
        guard let newPassword = currentField.text, !newPassword.isEmpty
        else {
            alertEmptyPassword()
                return
        }
        
        guard let checkChange = newField.text, let confirmChange = newConfirmField.text, checkChange == confirmChange
        else{
            alertWrongChangedPassword()
            return
        }
        
        guard let passwordCheck = currentField.text,
              passwordCheck == storedPassword
        
        else {
            alertWrongCurrentPassword()
                return
        }
        
        DispatchQueue.main.async {
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.set(password, forKey: "password")
            UserDefaults.standard.synchronize()
            }
      //  print(UserDefaults.standard.string(forKey: "password"))
      //  print(UserDefaults.standard.string(forKey: "password"))
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    func alertEmptyPassword() {
        let alert = UIAlertController(title: "Alert",
                                      message: "No Password Entered",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func alertWrongCurrentPassword() {
        let alert = UIAlertController(title: "Alert",
                                      message: "Current Password Is Wrong",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func alertWrongChangedPassword() {
        let alert = UIAlertController(title: "Alert",
                                      message: "New Passwords Do Not Match",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
