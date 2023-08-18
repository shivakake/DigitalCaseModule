//
//  CaseGroupsViewController.swift
//  CasesModule
//
//  Created by PGK Shiva Kumar on 30/11/22.
//

import UIKit

class CaseGroupsViewController: UIViewController {
    
    @IBOutlet weak var caseGroupsCollectionView: UICollectionView!
    
    weak var caseLogic : CaseLogic?
    weak var delegate : CaseLogicDelegate?
    var communityId: String?
    var alert = CommonAlert()
    var plusButton: UIBarButtonItem?
    var backButtonItem: UIBarButtonItem?
    var deleteButtonItem: UIBarButtonItem?
    var selectedGroupList : [String] = [String]()
    
    init(caseLogic : CaseLogic?, caseDelegate : CaseLogicDelegate? , communityId: String?) {
        self.caseLogic = caseLogic
        self.delegate = caseDelegate
        self.communityId = communityId
        super.init(nibName: "CaseGroupsViewController", bundle: Bundle(for: CaseGroupsViewController.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonMethods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Cases Groups"
        setNavigationItems()
    }
    
    public func commonMethods() {
        
        configureColletionView()
    }
    
    public func setNavigationItems() {
        
        backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain , target: self, action: #selector(backButton))
        plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain , target: self, action: #selector(plusButtonAction))
        deleteButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(deleteGroupTapped(_:)))
        
        if caseLogic?.caseDetailsModel?.datastatus?.lowercased() == "active"  && selectedGroupList.isEmpty == true {
            navigationItem.rightBarButtonItems = [plusButton ?? UIBarButtonItem()]
        }else {
            navigationItem.rightBarButtonItems = [deleteButtonItem ?? UIBarButtonItem()]
        }
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func backButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func plusButtonAction() {
        let controller = AddCaseMemberViewController(caseLogic: caseLogic, caseDelegate: delegate, communityId: communityId)
        controller.comingFrom = AddCaseMemberGroupPurpose.group
        let addController = UINavigationController(rootViewController: controller)
        controller.selectedListDelegate = self
        if let groups = caseLogic?.caseDetailsModel?.groups {
            controller.modelFromGroup = groups
        }
        addController.modalPresentationStyle = .fullScreen
        navigationController?.present(addController, animated: true, completion: nil)
    }
    
    @objc func deleteGroupTapped(_ sender : UIBarButtonItem) {
//        setNavigationItems()
        caseLogic?.delegate = self
        caseLogic?.deleteCaseMemberAndGroup(caseId: caseLogic?.caseDetailsModel?.id, personId: "" , groupId: selectedGroupList.joined(separator: ","))
    }
    
    func getDetailsFromAPI(){
        DispatchQueue.main.async {
            self.alert.callLoadermethod(view: self.view)
        }
        caseLogic?.delegate = self
        caseLogic?.getCaseDetails(caseId: caseLogic?.caseDetailsModel?.id)
    }
    
    public func configureColletionView() {
        caseGroupsCollectionView.dataSource = self
        caseGroupsCollectionView.delegate = self
        caseGroupsCollectionView.register(UINib(nibName: "CaseMembersAndGroupsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CaseMembersAndGroupsCollectionViewCell")
        caseGroupsCollectionView.allowsMultipleSelection = true
        caseGroupsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
    }
}

extension CaseGroupsViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return caseLogic?.arrGroupsData.count ?? 0
        return caseLogic?.caseDetailsModel?.groups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = caseGroupsCollectionView.dequeueReusableCell(withReuseIdentifier: "CaseMembersAndGroupsCollectionViewCell", for: indexPath) as? CaseMembersAndGroupsCollectionViewCell {
            cell.configureCell(memberModel: nil, groupModel: caseLogic?.caseDetailsModel?.groups?[indexPath.row], which: "Group")
            return cell
        }
        return UICollectionViewCell()
    }
}

extension CaseGroupsViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath as IndexPath)?.backgroundColor = UIColor.lightGray
        setNavigationItems()
        guard let selectedMember = caseLogic?.caseDetailsModel?.groups?[indexPath.row].id else { return }
        self.selectedGroupList.append(selectedMember)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath as IndexPath)?.backgroundColor = UIColor.clear
        if selectedGroupList.count > 0{
            guard let firstIndex = selectedGroupList.firstIndex(where: { $0 == caseLogic?.caseDetailsModel?.groups?[indexPath.row].id}) else { return }
            self.selectedGroupList.remove(at: firstIndex)
            collectionView.cellForItem(at: indexPath)?.backgroundColor = .clear
        }
        setNavigationItems()
    }
    
}

extension CaseGroupsViewController : UICollectionViewDelegateFlowLayout {
    
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

extension CaseGroupsViewController : CaseLogicDelegate {
    
    func updateAddMemberAndGroupScuess() {
        getDetailsFromAPI()
    }
    
    func updateDeleteMemberAndGroup() {
        getDetailsFromAPI()
    }
    
    func getCaseDetails() {
        DispatchQueue.main.async {
            self.alert.removeLoaderMethod()
            self.selectedGroupList.removeAll()
            self.setNavigationItems()
            self.caseGroupsCollectionView.reloadData()
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

extension CaseGroupsViewController : AddCaseMemberViewControllerDelegate {
    
    func getSelectedList(data: [String]) {
        caseLogic?.delegate = self
        caseLogic?.addNewCaseMemberAndGroup(caseId: caseLogic?.caseDetailsModel?.id, personId: nil, groupId: data.joined(separator: ","))
    }
}
