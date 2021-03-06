//
//  LoginViewController.swift
//  PrivateGalleryApplication
//
//  Created by Andrew on 4/4/21.
//  Copyright © 2021 Andrew. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let PasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Password", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Enter your password"
        view.backgroundColor = .white
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        
        passwordField.delegate = self
        PasswordButton.addTarget(self,
                                 action: #selector(PasswordButtonTapped),
                                 for: .touchUpInside)
        
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(PasswordButton)
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
        loginButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
        PasswordButton.frame = CGRect(x: 30,
                                      y: loginButton.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
    }
    
    @objc private func PasswordButtonTapped(){
        
        self.present(PwChangeViewController(), animated: true, completion: nil)
    }
    
 
    @objc private func loginButtonTapped(){
        passwordField.resignFirstResponder()
        
        guard let storedPassword = UserDefaults().value(forKey: "password") as? String else {
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty,
            password == storedPassword else {
                alertLoginError()
                return
        }
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func alertLoginError() {
        let alert = UIAlertController(title: "Alert",
                                      message: "Incorrect Password",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}
