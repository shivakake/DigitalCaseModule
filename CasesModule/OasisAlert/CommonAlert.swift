//
//  CommonAlert.swift
//  PageWyze
//
//  Created by Nikhil Narayan on 06/06/19.
//  Copyright © 2019 Nikhil Narayan. All rights reserved.
//

import UIKit

public class CommonAlert: NSObject {
    
    //MARK:Network alert methods
    let networkAlertObj = NetworkErrorAlertView()
    //MARK:Loader alert methods
    let loaderViewObj = AlertView()
    
    
    func networkAlert(view:UIView, constant:CGFloat) {
        view.addSubview(networkAlertObj)
        networkAlertObj.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            networkAlertObj.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            networkAlertObj.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant),
            networkAlertObj.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0)
        ])
        view.bringSubviewToFront(networkAlertObj)
    }
    
    
    func removeNetworkAlert(view:UIView) {
        self.networkAlertObj.removeFromSuperview()
    }
    
    public func callLoadermethod(view:UIView) {
        view.addSubview(loaderViewObj)
        loaderViewObj.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loaderViewObj.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            loaderViewObj.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            loaderViewObj.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            loaderViewObj.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0)
        ])
        loaderViewObj.activityIndicatorOutlet.startAnimating()
    }
    
    
    public func removeLoaderMethod() {
        DispatchQueue.main.async {
            self.loaderViewObj.activityIndicatorOutlet.stopAnimating()
            self.loaderViewObj.removeFromSuperview()
        }
    }
    
}
