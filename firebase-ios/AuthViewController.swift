//
//  AuthViewController.swift
//  firebase-ios
//
//  Created by Cristian Paniagua on 06/13/20.
//  Copyright © 2020 Cristian Paniagua. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Analytics events
        Analytics.logEvent("app_init", parameters: ["screen":"auth_view"])
    }


    @IBAction func registerButtonAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) {
                (result, error) in
                if let result = result, error == nil {
                    self.showHome(email: result.user.email!, provider: .basic)
                } else {
                    self.showAlert()
                }
            }
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) {
                (result, error) in
                if let result = result, error == nil {
                    self.showHome(email: result.user.email!, provider: .basic)
                } else {
                    self.showAlert()
                }
            }
        }
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Error", message: "Error when user authenticate", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showHome(email: String, provider: ProviderType) {
        self.navigationController?.pushViewController(HomeViewController(email: email, provider: provider), animated: true)
    }
}

