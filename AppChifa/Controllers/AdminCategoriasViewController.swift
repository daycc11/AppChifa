//
//  AdminCategoriasViewController.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation
import UIKit

class AdminCategoriasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var categorias: [Categoria] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarCategorias()
    }
    
    private func cargarCategorias() {
        APIService.shared.getCategorias { [weak self] resultado in
            if case .success(let lista) = resultado {
                self?.categorias = lista
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func agregarCategoriaTapped(_ sender: Any) {
        mostrarFormulario(categoria: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { categorias.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "AdminCategoriaCell", for: indexPath) as! AdminCategoriaCell
        celda.configure(with: categorias[indexPath.row])
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        mostrarFormulario(categoria: categorias[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cat = categorias[indexPath.row]
            APIService.shared.deleteCategoria(id: cat.id) { [weak self] _ in
                self?.cargarCategorias()
            }
        }
    }
    
    private func mostrarFormulario(categoria: Categoria?) {
        let alerta = UIAlertController(title: categoria == nil ? "Nueva Categoría" : "Editar Categoría", message: nil, preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre"; $0.text = categoria?.nombre }
        alerta.addTextField { $0.placeholder = "Descripción"; $0.text = categoria?.descripcion }
        alerta.addTextField { $0.placeholder = "URL Imagen"; $0.text = categoria?.imagenUrl }
        
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            let campos = alerta.textFields!
            let data: [String: Any] = [
                "Nombre": campos[0].text ?? "",
                "Descripcion": campos[1].text ?? "",
                "ImagenUrl": campos[2].text ?? ""
            ]
            if let cat = categoria {
                APIService.shared.updateCategoria(id: cat.id, data: data) { _ in self?.cargarCategorias() }
            } else {
                APIService.shared.createCategoria(data: data) { _ in self?.cargarCategorias() }
            }
        })
        present(alerta, animated: true)
    }
}
