//
//  Producto.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation

struct Producto: Codable {
    let id: String
    let nombre: String
    let descripcion: String
    let precio: Double
    let imagenUrl: String
    let categoriaId: String
    let cantidad: Int
    let estado: Bool
}
