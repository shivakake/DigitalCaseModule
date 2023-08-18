//
//  CaseDetailsTabbarController.swift
//  CasesModule
//
//  Created by PGK Shiva Kumar on 29/11/22.
//

import UIKit

class CaseDetailsTabbarController: UITabBarController {
    
    weak var caseLogic : CaseLogic?
    weak var caseDelegate : CaseLogicDelegate?
    var communityId: String?
    var alert = CommonAlert()
    
    init(caseLogic : CaseLogic?, caseDelegate : CaseLogicDelegate?, communityId: String?) {
        self.caseLogic = caseLogic
        self.caseDelegate = caseDelegate
        self.communityId = communityId
        super.init(nibName: "CaseDetailsTabbarController", bundle: Bundle(for: CaseDetailsTabbarController.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar() {
        
        let detailsVC = CasesDetailsViewController(caseLogic: caseLogic, caseDelegate: caseDelegate, communityId: self.communityId)
        let navDetails = UINavigationController(rootViewController: detailsVC)
        let detailsIcon = UITabBarItem(title: "Details", image: UIImage(systemName: "folder"), selectedImage: UIImage(systemName: "folder"))
        navDetails.tabBarItem = detailsIcon
        
        let membersVC = CaseMembersViewController(caseLogic: caseLogic, caseDelegate: caseDelegate, communityId: communityId)
        let navMembers = UINavigationController(rootViewController: membersVC)
        let membersIcon = UITabBarItem(title: "Members", image: UIImage(systemName: "pencil.circle"), selectedImage: UIImage(systemName: "pencil.circle.fill"))
        membersVC.tabBarItem = membersIcon
        
        let groupVC = CaseGroupsViewController(caseLogic: caseLogic, caseDelegate: caseDelegate, communityId: communityId)
        let navGroups = UINavigationController(rootViewController: groupVC)
        let groupIcon = UITabBarItem(title: "Groups", image: UIImage(systemName: "trash.circle"), selectedImage: UIImage(systemName: "trash.circle.fill"))
        groupVC.tabBarItem = groupIcon
        
        let controllers = [navDetails ,navMembers, navGroups]   //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
}
