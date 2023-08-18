//
//  AddCaseMemberViewController.swift
//  CasesModule
//
//  Created by PGK Shiva Kumar on 02/12/22.
//

import UIKit

enum AddCaseMemberGroupPurpose {
    case member, group
}

protocol AddCaseMemberViewControllerDelegate : AnyObject {
    func getSelectedList(data: [String])
}

class AddCaseMemberViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addCaseMemberListCollectionView: UICollectionView!
    
    weak var caseLogic : CaseLogic?
    weak var delegate : CaseLogicDelegate?
    var communityId: String?
    weak var selectedListDelegate : AddCaseMemberViewControllerDelegate?
    var alert = CommonAlert()
    var modelFromMember : [MembersMessageDataModel] = [MembersMessageDataModel]()
    var modelFromGroup : [GroupMessageListDataModel] = [GroupMessageListDataModel]()
    var finalMembersArray : [MembersMessageDataModel] = [MembersMessageDataModel]()
    var finalGroupsArray : [GroupMessageListDataModel] = [GroupMessageListDataModel]()
    var comingFrom : AddCaseMemberGroupPurpose?
    var selectedMembersList = [String]()
    var selectedGroupList = [String]()
    
    init(caseLogic : CaseLogic? ,caseDelegate : CaseLogicDelegate?, communityId:String?) {
        self.caseLogic = caseLogic
        self.delegate = caseDelegate
        self.communityId = communityId
        super.init(nibName: "AddCaseMemberViewController", bundle: Bundle(for: AddCaseMemberViewController.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if comingFrom == AddCaseMemberGroupPurpose.group{
            navigationItem.title = "Select Groups"
        }else{
            navigationItem.title = "Select Members"
        }
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    public func setupUI() {
        setNavigationItems()
        getMessagePeopleGroupListFromAPI()
        configureColletionView()
    }
    
    public func setNavigationItems() {
        
        var backButtonItem: UIBarButtonItem?
        var okayButtonItem: UIBarButtonItem?
        
        backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain , target: self, action: #selector(backButton))
        okayButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle.fill"), style: .plain, target: self, action: #selector(okayButton))
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.rightBarButtonItem = okayButtonItem
    }
    
    @objc func backButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func okayButton() {
        if comingFrom == AddCaseMemberGroupPurpose.group {
            selectedListDelegate?.getSelectedList(data: selectedGroupList)
        }else{
            selectedListDelegate?.getSelectedList(data: selectedMembersList)
        }
        dismiss(animated: true, completion: nil)
    }
    
    public func getMessagePeopleGroupListFromAPI(){
        alert.callLoadermethod(view: self.view)
        caseLogic?.delegate = self
        caseLogic?.getMessagePeopleGroupList(communityId: communityId ?? "")
    }
    
    public func configureColletionView() {
        addCaseMemberListCollectionView.dataSource = self
        addCaseMemberListCollectionView.delegate = self
        addCaseMemberListCollectionView.register(UINib(nibName: "AddCaseMemberCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddCaseMemberCollectionViewCell")
        addCaseMemberListCollectionView.allowsMultipleSelection = true
        addCaseMemberListCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
    }
}

extension AddCaseMemberViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if comingFrom == AddCaseMemberGroupPurpose.group {
            return finalGroupsArray.count
        }else{
            return finalMembersArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if comingFrom == AddCaseMemberGroupPurpose.group {
            if let cell = addCaseMemberListCollectionView.dequeueReusableCell(withReuseIdentifier: "AddCaseMemberCollectionViewCell", for: indexPath) as? AddCaseMemberCollectionViewCell {
                cell.configureCell(memberModel: nil, groupModel: finalGroupsArray[indexPath.row], which: "Group")
                return cell
            }
        }else{
            if let cell = addCaseMemberListCollectionView.dequeueReusableCell(withReuseIdentifier: "AddCaseMemberCollectionViewCell", for: indexPath) as? AddCaseMemberCollectionViewCell {
                cell.configureCell(memberModel: finalMembersArray[indexPath.row], groupModel: nil, which: "")
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension AddCaseMemberViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.lightGray
        
        if comingFrom == AddCaseMemberGroupPurpose.group {
            guard let selectedGroup = finalGroupsArray[indexPath.row].id else { return }
            self.selectedGroupList.append(selectedGroup)
        }else{
            guard let selectedMember = finalMembersArray[indexPath.row].id else { return }
            self.selectedMembersList.append(selectedMember)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if comingFrom == AddCaseMemberGroupPurpose.group {
            if selectedMembersList.count > 0{
                guard let firstIndex = selectedGroupList.firstIndex(where: { $0 == finalGroupsArray[indexPath.row].id}) else { return }
                self.selectedGroupList.remove(at: firstIndex)
                collectionView.cellForItem(at: indexPath)?.backgroundColor = .clear
            }
        }else{
            if selectedMembersList.count > 0{
                guard let firstIndex = selectedMembersList.firstIndex(where: { $0 == finalMembersArray[indexPath.row].id}) else { return }
                self.selectedMembersList.remove(at: firstIndex)
                collectionView.cellForItem(at: indexPath)?.backgroundColor = .clear
            }
        }
    }
}

extension AddCaseMemberViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension AddCaseMemberViewController : CaseLogicDelegate {
    
    func getMessagePeopleGroupList(model: MessagePeopleGroupsDataModel?) {
        
        self.finalMembersArray.removeAll()
        self.finalGroupsArray.removeAll()
        
        if comingFrom == AddCaseMemberGroupPurpose.group {
            
            var tempArray = self.modelFromGroup
            
            for group in model?.groups ?? [GroupMessageListDataModel]() {
                
                var indexInt = 0
                var tempObj : GroupMessageListDataModel? = nil
                
                for obj in tempArray {
                    if group.id == obj.id {
                        tempObj = obj
                        break
                    }
                    indexInt += 1
                }
                
                if(tempObj == nil) {
                    finalGroupsArray.append(group)
                } else {
                    tempArray.remove(at: indexInt)
                }
            }
        } else {
            
            var tempArray = self.modelFromMember
            
            for member in model?.members ?? [MembersMessageDataModel]() {
                
                var indexInt = 0
                var tempObj : MembersMessageDataModel? = nil
                
                for obj in tempArray {
                    if member.id == obj.id {
                        tempObj = obj
                        break
                    }
                    indexInt += 1
                }
                
                if(tempObj == nil) {
                    finalMembersArray.append(member)
                } else {
                    tempArray.remove(at: indexInt)
                }
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.alert.removeLoaderMethod()
            weakSelf.addCaseMemberListCollectionView.reloadData()
        }
    }
    
    func getCasesList() { }
    
    func getCaseDetails() { }
    
    func updateCaseStatusChange(dataStatus: String, index: Int) { }
    
    func caseStatusChangeForQueue(index: Int) { }
    
    func addNewCaseInQueue() { }
    
    func updateAddCaseSuccess(status: Int, index: Int) { }
    
    func editCaseInQueue(index: Int) { }
    
    func updateEditCaseSuccess(dataStatus: String, index: Int) { }
    
    func updateDeleteCaseSuccess(status: Int, index: Int) { }
    
    func updateAddMemberAndGroupScuess() { }
    
    func updateDeleteMemberAndGroup() { }
    
    func showPoorInternet() { }
}
