//
//  LoginController.swift
//  My Notes
//
//  Created by Christian on 13/06/2019.
//  Copyright © 2019 Christian Skydt. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase
import SVProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit

class LoginController: UIViewController
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (AccessToken.current != nil)
        {
            performSegue(withIdentifier: "goToCategory", sender: self)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton)
    {
        SVProgressHUD.show()
        
        // log in the user using Firebase email and pw
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!)
        { (user, error) in
            
            if error != nil
            {
                SVProgressHUD.dismiss()
                print(error!)
                
                let alertController = UIAlertController(title: "Error", message: "Wrong username or password", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                print("Login Successful!")
                SVProgressHUD.dismiss()
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: "goToCategory", sender: self)
            }
        }
    }
    
    @IBAction func facebookLoginPressed(_ sender: UIButton)
    {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: ["public_profile", "email"], from: self)
        { (result, error) in
            
            if let error = error
            {
                print("Failed to login: \(error.localizedDescription)")
                SVProgressHUD.dismiss()
                return
            }
            
            guard let accessToken = AccessToken.current else
            {
                print("Failed to get access token")
                SVProgressHUD.dismiss()
                return
            }
            
            // Create cridential string for Firebase Auth
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential)
            { (user, error) in
                
                if let error = error
                {
                    print("Login error: \(error.localizedDescription)")
                    
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(okayAction)
                    SVProgressHUD.dismiss()
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                print("Successfully Logged in!")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToCategory", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        styleNavigation(withHexCode: "FF9810")
    }
    
    func styleNavigation(withHexCode hexcode: String)
    {
        guard let navigationBar = navigationController?.navigationBar else {fatalError()}
        guard let navigationColor = UIColor(hexString: hexcode) else {fatalError()}
        
        title = "Log in"
        navigationBar.barTintColor = navigationColor
        navigationBar.tintColor = ContrastColorOf(navigationColor, returnFlat: true)
    }
}
