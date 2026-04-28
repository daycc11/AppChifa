//
//  AdminPedidoCell.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//
import UIKit

class AdminPedidoCell: UITableViewCell {
    private let infoLbl = UILabel()
    private let estadoBtn = UIButton(type: .system)
    var onCambiarEstado: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurar()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); configurar() }
    
    private func configurar() {
        backgroundColor = .clear
        infoLbl.textColor = .white; infoLbl.font = .systemFont(ofSize: 14); infoLbl.numberOfLines = 2
        infoLbl.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview(infoLbl)
        estadoBtn.setTitleColor(.white, for: .normal); estadoBtn.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0.2, alpha: 1)
        estadoBtn.layer.cornerRadius = 8; estadoBtn.titleLabel?.font = .boldSystemFont(ofSize: 12)
        estadoBtn.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview(estadoBtn)
        estadoBtn.addTarget(self, action: #selector(cambiarEstado), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            infoLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoLbl.trailingAnchor.constraint(equalTo: estadoBtn.leadingAnchor, constant: -8),
            estadoBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            estadoBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            estadoBtn.widthAnchor.constraint(equalToConstant: 100), estadoBtn.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    private var estadoActual = ""
    func configure(with pedido: Pedido) {
        estadoActual = pedido.estado ?? "pendiente"
        infoLbl.text = "\(pedido.nombre) — S/ \(String(format: "%.2f", pedido.total))\n\(pedido.tipoPedido) | \(pedido.metodoPago)"
        estadoBtn.setTitle(estadoActual, for: .normal)
    }
    
    @objc private func cambiarEstado() {
        let siguiente: [String: String] = ["pendiente": "preparando", "preparando": "enviado", "enviado": "entregado"]
        if let nuevo = siguiente[estadoActual] { onCambiarEstado?(nuevo) }
    }
}
