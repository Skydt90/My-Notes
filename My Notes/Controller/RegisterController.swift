//
//  RegisterController.swift
//  My Notes
//
//  Created by Christian on 13/06/2019.
//  Copyright © 2019 Christian Skydt. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class RegisterController: UIViewController
{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    

    @IBAction func registerButtonPressed(_ sender: UIButton)
    {
        SVProgressHUD.show()
        
        // set up a new user in Firbase database
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!)
        {
            (user, error) in
            
            if error != nil
            {
                SVProgressHUD.dismiss()
                print(error!)
                
                let alertController = UIAlertController(title: "Error", message: "User already exists or email is invalid", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                print("registration successful!")
                SVProgressHUD.dismiss()
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: "goToCategory", sender: self)
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
        
        title = "Register"
        navigationBar.barTintColor = navigationColor
        navigationBar.tintColor = ContrastColorOf(navigationColor, returnFlat: true)
    }
}

