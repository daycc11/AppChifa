//
//  CarritoViewController.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation
import UIKit

class CarritoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var pedidoButton: UIButton!
    
    private var items: [CarritoItem] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = CarritoService.shared.obtenerItems()
        tableView.reloadData()
        actualizarTotal()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func actualizarTotal() {
        let total = CarritoService.shared.calcularTotal()
        totalLabel.text = String(format: "Total: S/ %.2f", total)
        pedidoButton.isEnabled = !items.isEmpty
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "CarritoItemCell", for: indexPath) as! CarritoItemCell
        celda.configure(with: items[indexPath.row])
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CarritoService.shared.eliminar(at: indexPath.row)
            items = CarritoService.shared.obtenerItems()
            tableView.deleteRows(at: [indexPath], with: .fade)
            actualizarTotal()
        }
    }
    
    // MARK: - Realizar Pedido
    @IBAction func realizarPedidoTapped(_ sender: Any) {
        guard let usuario = SessionManager.shared.usuario, !items.isEmpty else { return }
        
        let detalles = items.map { item -> [String: Any] in
            return [
                "ProductoId": item.producto.id,
                "Nombre": item.producto.nombre,
                "Precio": item.producto.precio,
                "Cantidad": item.cantidad,
                "Subtotal": Double(item.cantidad) * item.producto.precio
            ]
        }
        
        let data: [String: Any] = [
            "UsuarioId": usuario.id ?? "",
            "Nombre": usuario.nombre,
            "Telefono": usuario.telefono,
            "Direccion": usuario.direccion ?? "",
            "TipoPedido": "delivery",
            "MetodoPago": "efectivo",
            "Total": CarritoService.shared.calcularTotal(),
            "Detalles": detalles
        ]
        
        APIService.shared.crearPedido(data: data) { [weak self] resultado in
            switch resultado {
            case .success:
                CarritoService.shared.vaciar()
                let alerta = UIAlertController(title: "✅ Pedido creado", message: "Tu pedido fue enviado", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self?.items = []
                    self?.tableView.reloadData()
                    self?.actualizarTotal()
                })
                self?.present(alerta, animated: true)
            case .failure(let error):
                let alerta = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alerta, animated: true)
            }
        }
    }
}


