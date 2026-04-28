//
//  AdminPedidosViewController.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation
import UIKit

class AdminPedidosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
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
        APIService.shared.getAllPedidos { [weak self] resultado in
            if case .success(let lista) = resultado {
                self?.pedidos = lista
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { pedidos.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "AdminPedidoCell", for: indexPath) as! AdminPedidoCell
        celda.configure(with: pedidos[indexPath.row])
        celda.onCambiarEstado = { [weak self] nuevoEstado in
            guard let id = self?.pedidos[indexPath.row].id else { return }
            APIService.shared.cambiarEstadoPedido(id: id, estado: nuevoEstado) { _ in
                self?.cargarPedidos()
            }
        }
        return celda
    }
}
