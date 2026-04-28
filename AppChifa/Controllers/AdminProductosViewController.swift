import Foundation
import UIKit

class AdminProductosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var productos: [Producto] = []
    private var categorias: [Categoria] = []
    private var categoriaSeleccionada: Categoria?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarProductos()
    }
    
    private func cargarProductos() {
        APIService.shared.getProductos { [weak self] resultado in
            if case .success(let lista) = resultado {
                self?.productos = lista
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func agregarProductoTapped(_ sender: Any) {
        mostrarFormulario(producto: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { productos.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "AdminProductoCell", for: indexPath) as! AdminProductoCell
        celda.configure(with: productos[indexPath.row])
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        mostrarFormulario(producto: productos[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let prod = productos[indexPath.row]
            APIService.shared.deleteProducto(id: prod.id) { [weak self] _ in
                self?.cargarProductos()
            }
        }
    }
    
    // MARK: - Formulario con selector de categoría
    private func mostrarFormulario(producto: Producto?) {
        APIService.shared.getCategorias { [weak self] resultado in
            if case .success(let cats) = resultado {
                self?.categorias = cats
                if let catId = producto?.categoriaId {
                    self?.categoriaSeleccionada = cats.first(where: { $0.id == catId })
                } else {
                    self?.categoriaSeleccionada = nil
                }
                self?.mostrarAlerta(producto: producto, datos: nil)
            }
        }
    }
    
    private func mostrarAlerta(producto: Producto?, datos: [String]?) {
        let alerta = UIAlertController(title: producto == nil ? "Nuevo Producto" : "Editar Producto", message: nil, preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre"; $0.text = datos?[0] ?? producto?.nombre }
        alerta.addTextField { $0.placeholder = "Descripción"; $0.text = datos?[1] ?? producto?.descripcion }
        alerta.addTextField { $0.placeholder = "Precio"; $0.text = datos?[2] ?? (producto != nil ? "\(producto!.precio)" : ""); $0.keyboardType = .decimalPad }
        alerta.addTextField { $0.placeholder = "URL Imagen"; $0.text = datos?[3] ?? producto?.imagenUrl }
        alerta.addTextField { $0.placeholder = "Categoría"; $0.text = self.categoriaSeleccionada?.nombre ?? ""; $0.isUserInteractionEnabled = false }
        alerta.addTextField { $0.placeholder = "Cantidad"; $0.text = datos?[4] ?? (producto != nil ? "\(producto!.cantidad)" : ""); $0.keyboardType = .numberPad }
        
        alerta.addAction(UIAlertAction(title: "Elegir Categoría", style: .default) { [weak self] _ in
            let datosTemp = [
                alerta.textFields?[0].text ?? "",
                alerta.textFields?[1].text ?? "",
                alerta.textFields?[2].text ?? "",
                alerta.textFields?[3].text ?? "",
                alerta.textFields?[5].text ?? ""
            ]
            self?.mostrarSelectorCategoria(producto: producto, datosTemp: datosTemp)
        })
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let catId = self?.categoriaSeleccionada?.id else {
                let err = UIAlertController(title: "Error", message: "Selecciona una categoría", preferredStyle: .alert)
                err.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(err, animated: true); return
            }
            let campos = alerta.textFields!
            let data: [String: Any] = [
                "Nombre": campos[0].text ?? "",
                "Descripcion": campos[1].text ?? "",
                "Precio": Double(campos[2].text ?? "0") ?? 0,
                "ImagenUrl": campos[3].text ?? "",
                "CategoriaId": catId,
                "Cantidad": Int(campos[5].text ?? "0") ?? 0,
                "Estado": true
            ]
            if let prod = producto {
                APIService.shared.updateProducto(id: prod.id, data: data) { _ in self?.cargarProductos() }
            } else {
                APIService.shared.createProducto(data: data) { _ in self?.cargarProductos() }
            }
        })
        present(alerta, animated: true)
    }
    
    private func mostrarSelectorCategoria(producto: Producto?, datosTemp: [String]) {
        let selector = UIAlertController(title: "Elegir Categoría", message: nil, preferredStyle: .actionSheet)
        for cat in categorias {
            selector.addAction(UIAlertAction(title: cat.nombre, style: .default) { [weak self] _ in
                self?.categoriaSeleccionada = cat
                self?.mostrarAlerta(producto: producto, datos: datosTemp)
            })
        }
        selector.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { [weak self] _ in
            self?.mostrarAlerta(producto: producto, datos: datosTemp)
        })
        present(selector, animated: true)
    }
}
