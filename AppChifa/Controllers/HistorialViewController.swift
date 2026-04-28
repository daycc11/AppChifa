//
//  HistorialViewController.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation
import UIKit

class HistorialViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private var pedidos: [Pedido] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarPedidos()
    }
    
    private func cargarPedidos() {
        guard let userId = SessionManager.shared.usuario?.id else { return }
        APIService.shared.getPedidosByUsuario(usuarioId: userId) { [weak self] resultado in
            switch resultado {
            case .success(let lista):
                self?.pedidos = lista
                self?.tableView.reloadData()
                self?.emptyLabel.isHidden = !lista.isEmpty
                self?.tableView.isHidden = lista.isEmpty
            case .failure(let error):
                print("Error cargando pedidos: \(error)")
            }
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { pedidos.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "PedidoCell", for: indexPath) as! PedidoCell
        celda.configure(with: pedidos[indexPath.row])
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pedido = pedidos[indexPath.row]
        
        var mensaje = "Estado: \(pedido.estado ?? "pendiente")\n"
        mensaje += "Tipo: \(pedido.tipoPedido) | Pago: \(pedido.metodoPago)\n\n"
        mensaje += "--- Productos ---\n"
        for d in pedido.detalles {
            mensaje += "• \(d.nombre) x\(d.cantidad) = S/ \(String(format: "%.2f", d.subtotal))\n"
        }
        mensaje += "\nTotal: S/ \(String(format: "%.2f", pedido.total))"
        
        let alerta = UIAlertController(title: "Pedido", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }

}

