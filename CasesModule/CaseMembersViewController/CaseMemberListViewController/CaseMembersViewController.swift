//
//  CaseMembersViewController.swift
//  CasesModule
//
//  Created by PGK Shiva Kumar on 30/11/22.
//

import UIKit

class CaseMembersViewController: UIViewController {
    
    @IBOutlet weak var caseMembersCollectionView: UICollectionView!
    
    weak var caseLogic : CaseLogic?
    weak var delegate : CaseLogicDelegate?
    var communityId: String?
    var alert = CommonAlert()
    var plusButton: UIBarButtonItem?
    var backButtonItem: UIBarButtonItem?
    var deleteButtonItem: UIBarButtonItem?
    var selectedMembersList : [String] = [String]()
    
    init(caseLogic : CaseLogic?, caseDelegate : CaseLogicDelegate? , communityId: String?) {
        self.caseLogic = caseLogic
        self.delegate = caseDelegate
        self.communityId = communityId
        super.init(nibName: "CaseMembersViewController", bundle: Bundle(for: CaseMembersViewController.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureColletionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Cases Members"
        setNavigationItems()
    }
    
    public func setNavigationItems() {
        
        backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain , target: self, action: #selector(backButton))
        plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain , target: self, action: #selector(plusButtonAction))
        deleteButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(deleteMemberTapped(_:)))
        
        if caseLogic?.caseDetailsModel?.datastatus?.lowercased() == "active"  && selectedMembersList.isEmpty == true {
            navigationItem.rightBarButtonItems = [plusButton ?? UIBarButtonItem()]
        }else {
            navigationItem.rightBarButtonItems = [deleteButtonItem ?? UIBarButtonItem()]
        }
//        if caseLogic?.caseDetailsModel?.datastatus?.lowercased() == "active" {
//            navigationItem.rightBarButtonItems = [plusButton ?? UIBarButtonItem()]
//        }
        
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func backButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func plusButtonAction() {
        let controller = AddCaseMemberViewController(caseLogic: caseLogic, caseDelegate: delegate, communityId: communityId)
        let addController = UINavigationController(rootViewController: controller)
        controller.selectedListDelegate = self
        
        if let members = caseLogic?.caseDetailsModel?.members {
            controller.modelFromMember = members
        }
        addController.modalPresentationStyle = .fullScreen
        navigationController?.present(addController, animated: true, completion: nil)
    }
    
    @objc func deleteMemberTapped(_ sender : UIBarButtonItem) {
//        setNavigationItems(isPuls: false)
        caseLogic?.delegate = self
        caseLogic?.deleteCaseMemberAndGroup(caseId: caseLogic?.caseDetailsModel?.id, personId: selectedMembersList.joined(separator: ","), groupId: "")
    }
    
    public func getDetailsFromAPI(){
        DispatchQueue.main.async {
            self.alert.callLoadermethod(view: self.view)
        }
        caseLogic?.delegate = self
        caseLogic?.getCaseDetails(caseId: caseLogic?.caseDetailsModel?.id)
    }
    
    public func configureColletionView() {
        caseMembersCollectionView.dataSource = self
        caseMembersCollectionView.delegate = self
        caseMembersCollectionView.register(UINib(nibName: "CaseMembersAndGroupsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CaseMembersAndGroupsCollectionViewCell")
        caseMembersCollectionView.allowsMultipleSelection = true
        caseMembersCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
    }
}

extension CaseMembersViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caseLogic?.caseDetailsModel?.members?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = caseMembersCollectionView.dequeueReusableCell(withReuseIdentifier: "CaseMembersAndGroupsCollectionViewCell", for: indexPath) as? CaseMembersAndGroupsCollectionViewCell {
            cell.configureCell(memberModel: caseLogic?.caseDetailsModel?.members?[indexPath.row], groupModel: nil, which: "")
            return cell
        }
        return UICollectionViewCell()
    }
}

extension CaseMembersViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath as IndexPath)?.backgroundColor = UIColor.lightGray
        guard let selectedMember = caseLogic?.caseDetailsModel?.members?[indexPath.row].id else { return }
        self.selectedMembersList.append(selectedMember)
        setNavigationItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath as IndexPath)?.backgroundColor = UIColor.clear
        if selectedMembersList.count > 0{
            guard let firstIndex = selectedMembersList.firstIndex(where: { $0 == caseLogic?.caseDetailsModel?.members?[indexPath.row].id}) else { return }
            self.selectedMembersList.remove(at: firstIndex)
            collectionView.cellForItem(at: indexPath)?.backgroundColor = .clear
        }
        setNavigationItems()
    }
}

extension CaseMembersViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension CaseMembersViewController : CaseLogicDelegate {
    
    func updateAddMemberAndGroupScuess() {
        getDetailsFromAPI()
    }
    
    func updateDeleteMemberAndGroup() {
        getDetailsFromAPI()
    }
    
    func getCaseDetails() {
        DispatchQueue.main.async {
            self.alert.removeLoaderMethod()
            self.selectedMembersList.removeAll()
            self.setNavigationItems()
            self.caseMembersCollectionView.reloadData()
        }
    }
    
    func getMessagePeopleGroupList(model: MessagePeopleGroupsDataModel?) { }
    
    func getCasesList() { }
    
    func updateCaseStatusChange(dataStatus: String, index: Int) { }
    
    func caseStatusChangeForQueue(index: Int) { }
    
    func addNewCaseInQueue() { }
    
    func updateAddCaseSuccess(status: Int, index: Int) { }
    
    func updateEditCaseSuccess(dataStatus: String, index: Int) { }
    
    func updateDeleteCaseSuccess(status: Int, index: Int) { }
    
    func editCaseInQueue(index: Int) { }
    
    func showPoorInternet() { }
}

extension CaseMembersViewController : AddCaseMemberViewControllerDelegate {
    
    func getSelectedList(data: [String]) {
        caseLogic?.delegate = self
        caseLogic?.addNewCaseMemberAndGroup(caseId: caseLogic?.caseDetailsModel?.id, personId: data.joined(separator: ","), groupId: nil)
    }
}
