//
//  CasesCollectionViewCell.swift
//  CasesModule
//
//  Created by PGK Shiva Kumar on 30/11/22.
//

import UIKit

class CasesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonMethods()
    }
    
    public func commonMethods() {
        setupCell()
        applyStyle()
    }
    
    public func setupCell() {
        self.cellBackgroundView.styleWithShadow()
        self.dataStatusImageView.layer.cornerRadius = self.dataStatusImageView.layer.frame.size.height / 2
    }
    
    public func applyStyle() {
        titleLabel.showStyle(with: .content)
    }
    
    func configureCell(caseData: CaseDataModel) {
        self.titleLabel.text = caseData.name
        checkStatusChange(for: caseData.datastatus?.lowercased())
    }
    
    func checkStatusChange(for status: String?) {
        switch status {
        case "active" , "live":
            dataStatusImageView.tintColor = .systemGreen
        case "complete":
            dataStatusImageView.tintColor = .systemBlue
        case "draft":
            dataStatusImageView.tintColor = .systemYellow
        case "error":
            dataStatusImageView.tintColor = .systemRed
        case "inactive":
            dataStatusImageView.tintColor = .systemGray
        case "queue":
            dataStatusImageView.tintColor = .systemPurple
        case "cancelled" :
            dataStatusImageView.tintColor = .systemOrange
        default:
            break
        }
    }
}
