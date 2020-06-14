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
import GoogleSignIn

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var authStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Analytics events
        Analytics.logEvent("app_init", parameters: ["screen":"auth_view"])
        
        // Recovery data
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String,
            let provider = defaults.value(forKey: "provider") as? String {
            authStackView.isHidden = true
            self.showHome(email: email, provider: ProviderType.init(rawValue: provider)!, animated: false)
        }
        
        // Google Auth
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authStackView.isHidden = false
    }


    @IBAction func registerButtonAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) {
                (result, error) in
                if let result = result, error == nil {
                    self.showHome(email: result.user.email!, provider: .basic, animated: true)
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
                    self.showHome(email: result.user.email!, provider: .basic, animated: true)
                } else {
                    self.showAlert()
                }
            }
        }
    }
    
    
    @IBAction func googleButtonAction(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Error", message: "Error when user authenticate", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showHome(email: String, provider: ProviderType, animated: Bool) {
        self.navigationController?.pushViewController(HomeViewController(email: email, provider: provider), animated: animated)
    }
}

extension AuthViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken,
                                                           accessToken: user.authentication.accessToken)
            
            Auth.auth().signIn(with: credential) {
                (result, error) in
                if let result = result, error == nil {
                    self.showHome(email: result.user.email!, provider: .google, animated: true)
                } else {
                    self.showAlert()
                }
            }
        }
    }
}

