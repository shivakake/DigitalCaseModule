//
//  CasesDetailsViewController.swift
//  DialogueiOS
//
//  Created by Pushpam on 07/05/22.
//

import UIKit

class CasesDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var dataStatusimageView: UIImageView!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var subTitlesLabel: [UILabel]!
    
    weak var caseLogic : CaseLogic?
    weak var delegate : CaseLogicDelegate?
    var communityId: String?
    var alert = CommonAlert()
    
    init(caseLogic : CaseLogic?, caseDelegate : CaseLogicDelegate?, communityId: String?) {
        self.caseLogic = caseLogic
        self.delegate = caseDelegate
        self.communityId = communityId
        super.init(nibName: "CasesDetailsViewController", bundle: Bundle(for: CasesDetailsViewController.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Cases Details"
    }
    
    func seupUI() {
        applyStylesToLabels()
        getDetailsFromAPI()
    }
    
    public func getDetailsFromAPI(){
        alert.callLoadermethod(view: self.view)
        caseLogic?.delegate = self
        caseLogic?.getCaseDetails(caseId: caseLogic?.caseDetailsModel?.id)
    }
    
    public func updateUI() {
        titleLabel.text = caseLogic?.caseDetailsModel?.name
        descriptionLabel.text = caseLogic?.caseDetailsModel?.description
        scheduleLabel.text = caseLogic?.caseDetailsModel?.scheduled
        createdDateLabel.text = caseLogic?.caseDetailsModel?.created
        updatedDateLabel.text = caseLogic?.caseDetailsModel?.updated
        setStatusNavigation(status: caseLogic?.caseDetailsModel?.datastatus?.lowercased() ?? "live")
    }
    
    public func applyStylesToLabels() {
        
        titleLabel.showStyle(with: .largeTitle, weight: .medium)
        descriptionLabel.showStyle(with: .content)
        scheduleLabel.showStyle(with: .content)
        createdDateLabel.showStyle(with: .meta)
        updatedDateLabel.showStyle(with: .meta)
        for lable in subTitlesLabel{
            lable.showStyle(with: .small, weight: .regular, color: .lightGray)
        }
    }
    
    @objc func backButton() {
        dismiss(animated: true, completion: nil)
    }
    
    public func goToAddOrEditPage() {
        let controller = AddCasesViewController(caseModel: caseLogic?.caseDetailsModel, caseLogic: caseLogic, delegate: self, communityId: self.communityId)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    public func setStatusNavigation(status: String){
        
        var moreBarButtonItem = UIBarButtonItem()
        var backButtonItem: UIBarButtonItem?
        
        //        let moreImage = UIImage(systemName: "")
        //        let backImage = UIImage(systemName: "")
        
        let cancelAction = UIAction(title: "Cancel", image: UIImage(systemName:"xmark")) { [unowned self] _ in
            caseLogic?.delegate = self
            caseLogic?.cancelCase(communityId: communityId ?? "", caseId: caseLogic?.caseDetailsModel?.id ?? "")
        }
        
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { [unowned self] _ in
            goToAddOrEditPage()
        }
        
        let draftAction = UIAction(title: "Draft", image: UIImage(systemName: "envelope.open")) { [unowned self] _ in
            caseLogic?.delegate = self
            caseLogic?.draftCase(communityId: communityId ?? "", caseId: caseLogic?.caseDetailsModel?.id ?? "")
        }
        
        let completeAction = UIAction(title: "Complete", image: UIImage(systemName: "doc.badge.ellipsis")) { [unowned self] _ in
            caseLogic?.delegate = delegate
            caseLogic?.completeCase(communityId: communityId ?? "", caseId: caseLogic?.caseDetailsModel?.id ?? "")
            dismiss(animated: true, completion: nil)
        }
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { [unowned self] _ in
            caseLogic?.delegate = delegate
            caseLogic?.deleteCase(communityId: communityId ?? "", caseId: caseLogic?.caseDetailsModel?.id ?? "")
            dismiss(animated: true, completion: nil)
        }
        
        let approveAction = UIAction(title: "Approve", image: UIImage(systemName: "checkmark.circle")) { [unowned self] _ in
            caseLogic?.delegate = self
            caseLogic?.approveCase(communityId: communityId ?? "", caseId: caseLogic?.caseDetailsModel?.id ?? "")
        }
        
        switch status.lowercased() {
        
        case "active" ,"live":
            dataStatusimageView.tintColor = .systemGreen
            moreBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: UIMenu(title: "", children: [editAction ,deleteAction ,draftAction , cancelAction ,completeAction]))
            
        case "draft" :
            dataStatusimageView.tintColor = .systemYellow
            moreBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: UIMenu(title: "", children: [editAction , deleteAction , approveAction]))
            
        case "complete" :
            dataStatusimageView.tintColor = .systemBlue
            moreBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: UIMenu(title: "", children: [approveAction]))
            
        case "inactive" :
            dataStatusimageView.tintColor = .systemGray
            
        case "error" :
            dataStatusimageView.tintColor = .systemRed
            
        case "queue" :
            dataStatusimageView.tintColor = .systemPurple
            
        case "cancelled" :
            dataStatusimageView.tintColor = .systemOrange
            
        default:
            break
        }
        
        backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain , target: self, action: #selector(backButton))
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem]
        navigationItem.leftBarButtonItem = backButtonItem
    }
}

extension CasesDetailsViewController : CaseLogicDelegate {
    
    func getCaseDetails() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.alert.removeLoaderMethod()
            weakSelf.updateUI()
        }
    }
    
    func editCaseInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.updateUI()
            weakSelf.delegate?.editCaseInQueue(index: index)
        }
    }
    
    func updateEditCaseSuccess(dataStatus: String, index: Int) {
        
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setStatusNavigation(status: dataStatus)
            weakSelf.delegate?.updateEditCaseSuccess(dataStatus: dataStatus, index: index)
        }
    }
    
    func updateCaseStatusChange(dataStatus: String, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setStatusNavigation(status: dataStatus)
            weakSelf.delegate?.updateCaseStatusChange(dataStatus: dataStatus, index: index)
        }
    }
    
    func caseStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setStatusNavigation(status: "queue")
            weakSelf.delegate?.caseStatusChangeForQueue(index: index)
        }
    }
    
    func getCasesList() { }
    
    func addNewCaseInQueue() { }
    
    func updateAddCaseSuccess(status: Int, index: Int) { }
    
    func updateDeleteCaseSuccess(status: Int, index: Int) { }
    
    func updateAddMemberAndGroupScuess() { }
    
    func updateDeleteMemberAndGroup() { }
    
    func getMessagePeopleGroupList(model: MessagePeopleGroupsDataModel?) { }
    
    func showPoorInternet() { }
}

/*
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 navigationItem.title = "Cases Details"
 scrollView.keyboardDismissMode = .onDrag
 navigationController?.navigationBar.prefersLargeTitles = false
 }
 
 public func passDataToMemeber() {
 if let memberTab = self.tabBarController?.viewControllers?[1] as? CaseMembersViewController {
 memberTab.caseModel = caseModel
 }
 }
 */
