//
//  CollectionViewListCell.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/16.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewListCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func defaultListConfiguration() -> UIListContentConfiguration {
        return .subtitleCell()
    }
    
    private lazy var listContentView = UIListContentView(configuration: .subtitleCell())
    
    private let stock = UILabel()
    
    private func setConstraint() {
        [listContentView, stock].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        stock.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            stock.leadingAnchor.constraint(greaterThanOrEqualTo: listContentView.trailingAnchor),
            stock.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stock.widthAnchor.constraint(lessThanOrEqualTo: listContentView.widthAnchor, multiplier: 0.5),
            stock.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configureContent(productInformation product: ProductInformation) {
        
        var configure = defaultListConfiguration()
        configure.image = product.thumbnailImage
        configure.imageProperties.maximumSize = CGSize(width: 60, height: 60)
        configure.text = product.name
        configure.textProperties.font = .preferredFont(forTextStyle: .headline)
        configure.secondaryTextProperties.font = .preferredFont(forTextStyle: .callout)
        configure.secondaryTextProperties.color = .gray
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        switch product.currency {
        case Currency.KRW.rawValue:
            numberFormatter.maximumFractionDigits = 0
        default:
            numberFormatter.maximumFractionDigits = 1
        }
        
        let stringPrice = numberFormatter.string(for: product.price) ?? ""
        
        if product.discountedPrice == 0 {
            configure.secondaryText = "\(product.currency) \(stringPrice)"
        } else {
            let stringDiscountedPrice = numberFormatter.string(for: product.discountedPrice) ?? ""
            let letter = "\(product.currency) \(stringPrice)"
            let text = letter + " \(product.currency) \(stringDiscountedPrice)"
            configure.secondaryAttributedText = NSMutableAttributedString(allText: text, redText: letter)
        }
        
        listContentView.configuration = configure
        
        if product.stock == 0 {
            stock.text = "품절"
            stock.textColor = .orange
        } else {
            stock.text = "잔여수량: \(product.stock)"
            stock.textColor = .gray
        }
        setConstraint()
    }
}
