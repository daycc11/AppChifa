//
//  ProductosViewController.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation
import UIKit

class ProductosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var categoria: Categoria?
    private var productos: [Producto] = []
    private var productosFiltrados: [Producto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = categoria?.nombre ?? "Productos"
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        cargarProductos()
    }
    
    private func cargarProductos() {
        guard let catId = categoria?.id else { return }
        APIService.shared.getProductosByCategoria(categoriaId: catId) { [weak self] resultado in
            if case .success(let prods) = resultado {
                self?.productos = prods
                self?.productosFiltrados = prods
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange textoBusqueda: String) {
        productosFiltrados = textoBusqueda.isEmpty ? productos : productos.filter {
            $0.nombre.lowercased().contains(textoBusqueda.lowercased())
        }
        tableView.reloadData()
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productosFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCell", for: indexPath) as! ProductoCell
        celda.configure(with: productosFiltrados[indexPath.row])
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "irADetalle", sender: productosFiltrados[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irADetalle",
           let destino = segue.destination as? DetalleProductoViewController,
           let producto = sender as? Producto {
            destino.producto = producto
        }
    }
}




