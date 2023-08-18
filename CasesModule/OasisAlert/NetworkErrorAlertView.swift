//
//  NetworkErrorAlertView.swift
//  PageWyze
//
//  Created by Nikhil Narayan on 06/06/19.
//  Copyright © 2019 Nikhil Narayan. All rights reserved.
//

import UIKit

class NetworkErrorAlertView: UIView {

    let nibName = "NetworkErrorAlertView"
    var contentView: UIView!
    @IBOutlet var networkLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    func setUpView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        contentView.frame = self.bounds
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 0)
            ])
        
        let heightView = contentView.heightAnchor.constraint(equalToConstant: 50)
        heightView.isActive = true
        self.networkLabel.text = "Not able reach network"
        self.networkLabel.textColor = UIColor.white
        self.networkLabel.font = UIFont.init(name: "ArialMT", size: 16)
    }

}
