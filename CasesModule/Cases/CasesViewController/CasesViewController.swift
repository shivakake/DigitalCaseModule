//
//  CasesViewController.swift
//  DialogueiOS
//
//  Created by Pushpam on 07/05/22.
//

import UIKit

class CasesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet private weak var noCaseAvailableLabel: UILabel!
    @IBOutlet weak var casesListCollectionView : UICollectionView!
    
    var plusButton: UIBarButtonItem?
    var backButtonItem: UIBarButtonItem?
    let caseLogic : CaseLogic = CaseLogic()
    var selectedStatusId = "live"
    let alert = CommonAlert()
    weak var searchTime: Timer?
    let communityId = "wtkwfwwrdjqwurr"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Cases"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    public func setupUI() {
        noCaseAvailableLabel.showStyle(with: .content, color: .darkGray)
        setBarButtonItemAndAction()
        setupSearchBar()
        getCasesListFromAPI()
        registerColletionViewCellAndDelegate()
    }
    
    public func getCasesListFromAPI() {
        alert.callLoadermethod(view: self.view)
        caseLogic.delegate = self
        caseLogic.getCaseList(communityId: communityId, text: searchBar.text, status: selectedStatusId)
    }
    
    public func setupSearchBar(){
        searchBar.delegate = self
        searchBar.barTintColor = .clear
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
    
    public func setBarButtonItemAndAction() {
        
        backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain , target: self, action: #selector(backButton))
        
        plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain , target: self, action: #selector(plusButtonAction))
        
        navigationItem.rightBarButtonItems = [ plusButton ?? UIBarButtonItem()]
        
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func plusButtonAction() {
        let controller = AddCasesViewController(caseModel: nil, caseLogic: caseLogic, delegate: self, communityId: communityId)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    public func registerColletionViewCellAndDelegate(){
        casesListCollectionView.register(UINib(nibName: "CasesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CasesCollectionViewCell")
        casesListCollectionView.delegate = self
        casesListCollectionView.dataSource = self
    }
    
    public func showNoCaseLabel() {
        self.noCaseAvailableLabel.isHidden = !self.caseLogic.casesData.isEmpty
    }
}

extension CasesViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caseLogic.casesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = casesListCollectionView.dequeueReusableCell(withReuseIdentifier: "CasesCollectionViewCell", for: indexPath) as? CasesCollectionViewCell {
            cell.configureCell(caseData: caseLogic.casesData[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension CasesViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = caseLogic.casesData[indexPath.row]
        if model.datastatus != "queue" {
            caseLogic.caseDetailsModel = model
            let controller = CaseDetailsTabbarController(caseLogic: caseLogic, caseDelegate: self, communityId: communityId)
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
        }
    }
}

extension CasesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: casesListCollectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension CasesViewController : CaseLogicDelegate {
    
    func getCasesList() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.alert.removeLoaderMethod()
            weakSelf.showNoCaseLabel()
            weakSelf.casesListCollectionView.reloadData()
        }
    }
    func updateCaseStatusChange(dataStatus: String, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            if (dataStatus == "error" || dataStatus == "live") && dataStatus.lowercased() != "complete" {
                weakSelf.casesListCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }else{
                let indexpath = IndexPath(row: index, section: 0)
                weakSelf.casesListCollectionView.deleteItems(at: [indexpath])
                weakSelf.showNoCaseLabel()
            }
        }
    }
    
    func caseStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.casesListCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func addNewCaseInQueue() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.casesListCollectionView.reloadData()
            weakSelf.showNoCaseLabel()
        }
    }
    
    func updateAddCaseSuccess(status: Int, index: Int) {
        let indexpath = IndexPath(row: index, section: 0)
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            if status == 1 {
                weakSelf.casesListCollectionView.reloadItems(at: [indexpath])
            } else {
                weakSelf.casesListCollectionView.deleteItems(at: [indexpath])
                weakSelf.showNoCaseLabel()
            }
        }
    }
    
    func editCaseInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.caseLogic.casesData[index].name = weakSelf.caseLogic.caseDetailsModel?.name
            weakSelf.caseLogic.casesData[index].created = weakSelf.caseLogic.caseDetailsModel?.created
            weakSelf.caseLogic.casesData[index].datastatus = weakSelf.caseLogic.caseDetailsModel?.datastatus
            weakSelf.casesListCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func updateEditCaseSuccess(dataStatus: String, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.caseLogic.casesData[index].datastatus = dataStatus
            weakSelf.casesListCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func updateDeleteCaseSuccess(status: Int, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            let indexpath = IndexPath(row: index, section: 0)
            if status == 1{
                weakSelf.casesListCollectionView.deleteItems(at: [indexpath])
                weakSelf.showNoCaseLabel()
            } else {
                weakSelf.casesListCollectionView.reloadItems(at: [indexpath])
            }
        }
    }
    
    func getCaseDetails() { }
    
    func updateAddMemberAndGroupScuess() { }
    
    func updateDeleteMemberAndGroup() { }
    
    func getMessagePeopleGroupList(model: MessagePeopleGroupsDataModel?) { }
    
    func showPoorInternet() { }
}


extension CasesViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchTime != nil {
            searchTime?.invalidate()
        }
        searchTime = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(searchAPICall), userInfo: searchText, repeats: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    @objc func searchAPICall() {
        getCasesListFromAPI()
    }
}
