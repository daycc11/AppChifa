//
//  CarritoItemCell.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//
import UIKit

class CarritoItemCell: UITableViewCell {
    private let nombreLbl = UILabel()
    private let detalleLbl = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurar()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); configurar() }
    
    private func configurar() {
        backgroundColor = .clear
        nombreLbl.textColor = .white; nombreLbl.font = .boldSystemFont(ofSize: 16)
        nombreLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nombreLbl)
        
        detalleLbl.textColor = .lightGray; detalleLbl.font = .systemFont(ofSize: 14)
        detalleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detalleLbl)
        
        NSLayoutConstraint.activate([
            nombreLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nombreLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            nombreLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            detalleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detalleLbl.topAnchor.constraint(equalTo: nombreLbl.bottomAnchor, constant: 4),
        ])
    }
    
    func configure(with item: CarritoItem) {
        nombreLbl.text = item.producto.nombre
        let subtotal = Double(item.cantidad) * item.producto.precio
        detalleLbl.text = "x\(item.cantidad) — S/ \(String(format: "%.2f", subtotal))"
    }
}
