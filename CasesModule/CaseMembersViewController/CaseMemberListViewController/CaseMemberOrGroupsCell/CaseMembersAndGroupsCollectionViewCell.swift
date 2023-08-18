//
//  CaseMembersAndGroupsCollectionViewCell.swift
//  CasesModule
//
//  Created by PGK Shiva Kumar on 30/11/22.
//

import UIKit

class CaseMembersAndGroupsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBGView: UIView!
    @IBOutlet weak var memberOrGroupImageView: UIImageView!
    @IBOutlet weak var memberOrGroupNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    public func setupCell() {
        memberOrGroupImageView.layer.cornerRadius = memberOrGroupImageView.frame.size.height / 2
        memberOrGroupNameLabel.showStyle(with: .small)
    }
    
    public func configureCell(memberModel : MembersMessageDataModel? , groupModel : GroupMessageListDataModel? , which: String?) {
        if which == "Group"{
            memberOrGroupImageView.image = UIImage(named: groupModel?.name ?? "")
            memberOrGroupNameLabel.text = groupModel?.name ?? ""
        }else{
            memberOrGroupImageView.image = UIImage(named: memberModel?.name ?? "")
            memberOrGroupNameLabel.text = memberModel?.name ?? ""
        }
    }
}
