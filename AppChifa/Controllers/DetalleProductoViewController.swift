//
//  DetalleProductoViewController.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation
import UIKit

class DetalleProductoViewController: UIViewController {
    
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var cantidadLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var agregarButton: UIButton!
    
    var producto: Producto?
    private var cantidad: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarVista()
    }
    
    private func configurarVista() {
        guard let producto = producto else { return }
        title = producto.nombre
        nombreLabel.text = producto.nombre
        descripcionLabel.text = producto.descripcion
        precioLabel.text = String(format: "S/ %.2f", producto.precio)
        cantidadLabel.text = "1"
        stepper.value = 1
        
        // Cargar imagen
        if let url = URL(string: producto.imagenUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let imagen = UIImage(data: data) {
                    DispatchQueue.main.async { self?.imagenView.image = imagen }
                }
            }.resume()
        }
    }
    
    @IBAction func cantidadCambiada(_ sender: UIStepper) {
        cantidad = Int(sender.value)
        cantidadLabel.text = "\(cantidad)"
    }
    
    @IBAction func agregarAlCarritoTapped(_ sender: Any) {
        guard let producto = producto else { return }
        let item = CarritoItem(producto: producto, cantidad: cantidad)
        CarritoService.shared.agregar(item: item)
        
        // Actualizar badge del tab Carrito
        if let tabBar = self.tabBarController {
            let totalItems = CarritoService.shared.obtenerItems().count
            tabBar.tabBar.items?[1].badgeValue = "\(totalItems)"
        }
        
        let alerta = UIAlertController(title: "Agregado", message: "\(producto.nombre) x\(cantidad) agregado al carrito.\nVe al tab 'Carrito' para verlo.", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alerta, animated: true)
    }

}
