//
//  CarritoService.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//
import Foundation

class CarritoService {
    static let shared = CarritoService()
    private var items: [CarritoItem] = []
    
    func agregar(item: CarritoItem) {
        if let index = items.firstIndex(where: { $0.producto.id == item.producto.id }) {
            items[index].cantidad += item.cantidad
        } else {
            items.append(item)
        }
    }
    
    func obtenerItems() -> [CarritoItem] { items }
    
    func eliminar(at index: Int) { items.remove(at: index) }
    
    func calcularTotal() -> Double {
        items.reduce(0) { $0 + (Double($1.cantidad) * $1.producto.precio) }
    }
    
    func vaciar() { items.removeAll() }
}
