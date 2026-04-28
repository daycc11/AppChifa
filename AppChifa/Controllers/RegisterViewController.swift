//
//  RegisterViewController.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    @IBOutlet weak var tipoDocSegmented: UISegmentedControl!
    @IBOutlet weak var documentoTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .white
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        guard let nombre = nombreTextField.text, !nombre.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let pass = passwordTextField.text, !pass.isEmpty,
              let tel = telefonoTextField.text, !tel.isEmpty,
              let dir = direccionTextField.text, !dir.isEmpty,
              let doc = documentoTextField.text, !doc.isEmpty else {
            showAlert("Error", "Completa todos los campos"); return
        }
        let tipos = ["DNI", "CE", "Pasaporte"]
        activityIndicator.startAnimating(); registerButton.isEnabled = false
        let data: [String: Any] = [
            "Nombre": nombre, "Email": email, "Password": pass,
            "Telefono": tel, "Direccion": dir,
            "TipoDocumento": tipos[tipoDocSegmented.selectedSegmentIndex],
            "NumeroDocumento": doc
        ]
        APIService.shared.register(data: data) { [weak self] result in
            self?.activityIndicator.stopAnimating(); self?.registerButton.isEnabled = true
            switch result {
            case .success:
                let a = UIAlertController(title: "Éxito", message: "Cuenta creada correctamente", preferredStyle: .alert)
                a.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self?.navigationController?.popViewController(animated: true)
                })
                self?.present(a, animated: true)
            case .failure(let e):
                self?.showAlert("Error", e.localizedDescription)
            }
        }
    }
    
    private func showAlert(_ t: String, _ m: String) {
        let a = UIAlertController(title: t, message: m, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default)); present(a, animated: true)
    }
}




