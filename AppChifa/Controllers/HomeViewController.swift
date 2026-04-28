//
//  HomeViewController.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    private var categorias: [Categoria] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        cargarCategorias()
        
        // Botón cerrar sesión
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Salir", style: .plain, target: self, action: #selector(cerrarSesion)
        )
        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    @objc private func cerrarSesion() {
        let alerta = UIAlertController(title: "Cerrar Sesión", message: "¿Estás seguro?", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Sí, salir", style: .destructive) { _ in
            SessionManager.shared.cerrarSesion()
            CarritoService.shared.vaciar()
            self.dismiss(animated: true)
        })
        present(alerta, animated: true)
    }

    
    private func cargarCategorias() {
        APIService.shared.getCategorias { [weak self] resultado in
            if case .success(let cats) = resultado {
                self?.categorias = cats
                self?.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { categorias.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriaCell", for: indexPath) as! CategoriaCell
        celda.configure(with: categorias[indexPath.item])
        return celda
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ancho = (collectionView.frame.width - 12) / 2
        return CGSize(width: ancho, height: ancho + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "irAProductos", sender: categorias[indexPath.item])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irAProductos",
           let destino = segue.destination as? ProductosViewController,
           let categoria = sender as? Categoria {
            destino.categoria = categoria
        }
    }
}



