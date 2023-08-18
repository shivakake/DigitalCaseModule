//
//  AddCaseMemberCollectionViewCell.swift
//  CasesModule
//
//  Created by PGK Shiva Kumar on 02/12/22.
//

import UIKit

class AddCaseMemberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var caseMemberImageView: UIImageView!
    @IBOutlet weak var caseMemberNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    public func setupCell() {
        caseMemberImageView.layer.cornerRadius = caseMemberImageView.frame.size.height / 2
        applyFontToLabels()
    }
    
    public func applyFontToLabels() {
        caseMemberNameLabel.showStyle(with: .content)
    }
    
    public func configureCell(memberModel: MembersMessageDataModel? , groupModel: GroupMessageListDataModel? , which: String?) {
        
        if which == "Group"{
            caseMemberNameLabel.text = groupModel?.name
            /*
             let url = URL(string: groupModel?.image ?? "")
             let data = try? Data(contentsOf: url!)
             if let imageData = data {
             caseMemberImageView.image = UIImage(data: imageData)
             }
             */
        }else{
            caseMemberNameLabel.text = memberModel?.name
            let url = URL(string: memberModel?.image ?? "")
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                caseMemberImageView.image = UIImage(data: imageData)
            }
        }
    }
}
