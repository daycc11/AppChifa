//
//  PedidoCell.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//
import UIKit

class PedidoCell: UITableViewCell {
    private let estadoLbl = UILabel()
    private let totalLbl = UILabel()
    private let fechaLbl = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurar()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); configurar() }
    
    private func configurar() {
        backgroundColor = .clear
        estadoLbl.font = .boldSystemFont(ofSize: 15); estadoLbl.textColor = .systemGreen
        estadoLbl.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview(estadoLbl)
        totalLbl.font = .boldSystemFont(ofSize: 16); totalLbl.textColor = .white
        totalLbl.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview(totalLbl)
        fechaLbl.font = .systemFont(ofSize: 13); fechaLbl.textColor = .lightGray
        fechaLbl.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview(fechaLbl)
        
        NSLayoutConstraint.activate([
            totalLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            totalLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            estadoLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            estadoLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            fechaLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fechaLbl.topAnchor.constraint(equalTo: totalLbl.bottomAnchor, constant: 6),
        ])
    }
    
    func configure(with pedido: Pedido) {
        totalLbl.text = String(format: "S/ %.2f — %d items", pedido.total, pedido.detalles.count)
        estadoLbl.text = pedido.estado ?? "pendiente"
        fechaLbl.text = pedido.fecha ?? ""
    }
}
