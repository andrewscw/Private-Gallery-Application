//
//  RegisterViewController.swift
//  PrivateGalleryApplication
//
//  Created by Andrew on 4/4/21.
//  Copyright © 2021 Andrew. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password"
        field.leftView = UIView(frame: CGRect(x:0, y:0, width:5, height:0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let confirmPasswordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Confirm Password"
        field.leftView = UIView(frame: CGRect(x:0, y:0, width:5, height:0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Set Password", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Please set a password"
        view.backgroundColor = .white
        
        loginButton.addTarget(self,
                              action: #selector(setPasswordButtonTapped),
                              for: .touchUpInside)
        
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(confirmPasswordField)
        scrollView.addSubview(loginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        
        imageView.frame = CGRect(x: (scrollView.width - size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        passwordField.frame = CGRect(x: 30,
                                     y: imageView.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        confirmPasswordField.frame = CGRect(x: 30,
                                  y: passwordField.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        loginButton.frame = CGRect(x: 30,
                                   y: confirmPasswordField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
    }
    

    @objc private func setPasswordButtonTapped(){
        passwordField.resignFirstResponder()
        confirmPasswordField.resignFirstResponder()
        
        guard let password = passwordField.text, let confirmPassword = confirmPasswordField.text,
            !password.isEmpty, !confirmPassword.isEmpty,
            password == confirmPassword else {
                alertCreatePasswordError()
                return
        }
        
        // set password
        UserDefaults().set(password, forKey: "password")
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func alertCreatePasswordError() {
        let alert = UIAlertController(title: "Alert",
                                      message: "Please ensure your password and confirmed password is the same",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        }
        else if textField == confirmPasswordField {
            setPasswordButtonTapped()
        }
        return true
    }
}
