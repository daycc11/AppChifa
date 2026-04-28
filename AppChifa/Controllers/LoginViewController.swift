//
//  LoginViewController.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let pass = passwordTextField.text, !pass.isEmpty else {
            showAlert("Error", "Completa todos los campos"); return
        }
        activityIndicator.startAnimating(); loginButton.isEnabled = false
        APIService.shared.login(email: email, password: pass) { [weak self] result in
            self?.activityIndicator.stopAnimating(); self?.loginButton.isEnabled = true
            switch result {
            case .success(let r):
                SessionManager.shared.token = r.token; SessionManager.shared.usuario = r.usuario
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let id = SessionManager.shared.isAdmin ? "AdminTabBar" : "ClienteTabBar"
                let vc = sb.instantiateViewController(withIdentifier: id)
                vc.modalPresentationStyle = .fullScreen; self?.present(vc, animated: true)
            case .failure(let e): self?.showAlert("Error", e.localizedDescription)
            }
        }
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToRegister", sender: nil)
    }

    private func showAlert(_ t: String, _ m: String) {
        let a = UIAlertController(title: t, message: m, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default)); present(a, animated: true)
    }
}
