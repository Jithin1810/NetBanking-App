//
//  AccountSummaryCell.swift
//  NetBanking
//
//  Created by JiTHiN on 15/11/24.
//

import Foundation
import UIKit

enum AccountType: String,Codable {
    case Banking
    case CreditCard
    case Investment
}
class AccountSummaryCell: UITableViewCell {
    

    
    struct ViewModel {
        let accountType: AccountType
        let accountName: String
        let balance : Decimal
        var balanceAttributedString: NSAttributedString {
            return CurrencyFormatter().makeAttributedCurrency(balance)
        }
    }

    let viewModel: ViewModel? = nil
    
    let typeLabel = UILabel()
    let underlineView = UIView()
    let nameLabel = UILabel()
    
    let balanceStackView = UIStackView()
    let balanceLabel = UILabel()
    let balanceAmountLabel = UILabel()
    
    let chevronImageView = UIImageView()
    
    static let reuseID = "AccountSummaryCell"
    static let rowHieght : CGFloat = 112
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AccountSummaryCell {
    func setUp() {
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        typeLabel.adjustsFontForContentSizeCategory = true
        typeLabel.text = "Account Type"
        
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = appColour
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.text = "Account Name"
        nameLabel.adjustsFontSizeToFitWidth = true
        
        
        balanceStackView.translatesAutoresizingMaskIntoConstraints = false
        balanceStackView.axis = .vertical
        balanceStackView.spacing = 0
        
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.font = UIFont.preferredFont(forTextStyle: .body)
        balanceLabel.textAlignment = .right
        balanceLabel.text = "Some Balance"
        balanceLabel.adjustsFontSizeToFitWidth = true
        
        balanceAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceAmountLabel.textAlignment = .right
        balanceAmountLabel.attributedText = makeFormattedBalance(
            dollars: "929,442",
            cents: "23"
        )
        
        
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        let chevronImage = UIImage(systemName: "chevron.right")!.withTintColor(
            appColour,
            renderingMode: .alwaysOriginal
        )
        chevronImageView.image = chevronImage
        
        
        contentView.addSubview(typeLabel)
        contentView.addSubview(underlineView)
        contentView.addSubview(nameLabel)
        
        balanceStackView.addArrangedSubview(balanceLabel)
        balanceStackView.addArrangedSubview(balanceAmountLabel)
        
        contentView.addSubview(balanceStackView)
        contentView.addSubview(chevronImageView)
        
    }
    
    func layout() {
        NSLayoutConstraint.activate(
            [
                typeLabel.topAnchor
                    .constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
                typeLabel.leadingAnchor
                    .constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
                
                underlineView.topAnchor
                    .constraint(
                        equalToSystemSpacingBelow: typeLabel.bottomAnchor,
                        multiplier: 1
                    ),
                underlineView.leadingAnchor
                    .constraint(
                        equalToSystemSpacingAfter: leadingAnchor,
                        multiplier: 2
                    ),
                underlineView.heightAnchor.constraint(equalToConstant: 4),
                underlineView.widthAnchor.constraint(equalToConstant: 100),
                
                nameLabel.topAnchor
                    .constraint(
                        equalToSystemSpacingBelow: underlineView.bottomAnchor,
                        multiplier: 2
                    ),
                nameLabel.leadingAnchor
                    .constraint(
                        equalToSystemSpacingAfter: leadingAnchor,
                        multiplier: 2
                    ),
                
                
                balanceStackView.topAnchor
                    .constraint(
                        equalToSystemSpacingBelow: underlineView.bottomAnchor,
                        multiplier: 0
                    ),
                balanceStackView.leadingAnchor
                    .constraint(
                        equalTo: nameLabel.trailingAnchor,
                        constant: 4
                    ),
                trailingAnchor
                    .constraint(
                        equalToSystemSpacingAfter: balanceStackView.trailingAnchor,
                        multiplier: 4
                    ),
                
                chevronImageView.topAnchor
                    .constraint(
                        equalToSystemSpacingBelow: underlineView.bottomAnchor,
                        multiplier: 1
                    ),
                trailingAnchor.constraint(equalToSystemSpacingAfter: chevronImageView.trailingAnchor, multiplier: 1)
            ]
        )
    }
    
    private func makeFormattedBalance(dollars: String, cents: String) -> NSMutableAttributedString {
        let dollarSignAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]
        let dollarAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title1)]
        let centAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .footnote), .baselineOffset: 8]
        
        let rootString = NSMutableAttributedString(string: "$", attributes: dollarSignAttributes)
        let dollarString = NSAttributedString(string: dollars, attributes: dollarAttributes)
        let centString = NSAttributedString(string: cents, attributes: centAttributes)
        
        rootString.append(dollarString)
        rootString.append(centString)
        
        return rootString
    }
    
}

extension AccountSummaryCell {
    func configure(with vm: ViewModel) {
        
        typeLabel.text = vm.accountType.rawValue
        nameLabel.text = vm.accountName
        balanceAmountLabel.attributedText = vm.balanceAttributedString
        
        switch vm.accountType {
        case .Banking:
            underlineView.backgroundColor = .systemBlue
            balanceLabel.text = "Current balance"
        case .CreditCard:
            underlineView.backgroundColor = .systemRed
            balanceLabel.text = "Current balance"
        case .Investment:
            underlineView.backgroundColor = .systemGreen
            balanceLabel.text = "Value"
        }
    }
}
