//
//  Pedido.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation

struct DetallePedido: Codable {
    let productoId: String
    let nombre: String
    let precio: Double
    let cantidad: Int
    let subtotal: Double
}

struct Pedido: Codable {
    let id: String?
    let usuarioId: String
    let nombre: String
    let telefono: String
    let direccion: String
    let tipoPedido: String
    let metodoPago: String
    let estado: String?
    let total: Double
    let fecha: String?
    let detalles: [DetallePedido]
}

struct PedidoResponse: Codable {
    let id: String
    let mensaje: String
}
