//
//  AdminCategoriaCell.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//
import UIKit

class AdminCategoriaCell: UITableViewCell {
    private let nombreLbl = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurar()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); configurar() }
    
    private func configurar() {
        backgroundColor = .clear
        nombreLbl.textColor = .white; nombreLbl.font = .boldSystemFont(ofSize: 16)
        nombreLbl.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview(nombreLbl)
        NSLayoutConstraint.activate([
            nombreLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nombreLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    func configure(with c: Categoria) { nombreLbl.text = "\(c.nombre) — \(c.descripcion)" }
}
