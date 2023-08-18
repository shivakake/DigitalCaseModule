//
//  AddCasesViewController.swift
//  DialogueiOS
//
//  Created by Pushpam on 07/05/22.
//

import UIKit

class AddCasesViewController: UIViewController {
    
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet private var subTitlesLabels: [UILabel]!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var caseModel : CaseDataModel?
    var caseLogic : CaseLogic?
    weak var delegate : CaseLogicDelegate?
    let dateFormatter = DateFormatter()
    let viewDate = Date().getFormattedStringFromDate(format: "dd-MMM-yyyy")
    var communityId: String?
    
    init(caseModel: CaseDataModel?, caseLogic: CaseLogic?, delegate: CaseLogicDelegate?,communityId: String?) {
        self.caseModel = caseModel
        self.caseLogic = caseLogic
        self.delegate = delegate
        self.communityId = communityId
        super.init(nibName: "AddCasesViewController", bundle: Bundle(for: AddCasesViewController.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "AddCasesViewController", bundle: Bundle(for: AddCasesViewController.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    func setupUI() {
        applyStyle()
        configureTextFields()
        hideKeyBoardTappedAround()
        configureKeyBoardNotifications()
        assignValueToUI()
    }
    
    public func assignValueToUI() {
        
        if caseModel != nil{
            navigationItem.title = "Edit Case"
            titleField.text = caseModel?.name
            descriptionTextView.text = caseModel?.description
            
            let finalDate = FunctionsHelper.sharedInstance.formattedDateFromString(dateString: caseModel?.scheduled ?? "", withFormat: "dd-MMM-yyyy", timeFormat: .forView1)
            selectDateButton.setTitle(finalDate, for: .normal)
        }else{
            selectDateButton.setTitle(viewDate, for: .normal)
            navigationItem.title = "Add Case"
        }
    }
    
    public func configureKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotifications(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotifications(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public func configureTextFields(){
        titleField.delegate = self
        descriptionTextView.delegate = self
    }
    
    public func applyStyle() {
        titleField.showStyle(with: .content)
        descriptionTextView.showStyle(with: .content)
        doneButton.showStyle(with: .subtitle,textColor: .white,bgColor: .black, needCircularCorners: true)
        
        for lable in subTitlesLabels{
            lable.showStyle(with: .small, color: .darkGray)
        }
    }
    
    @IBAction func selectButtonAction(_ sender: Any) {
        let datePicker = HomeDatePickerView()
        dateFormatter.dateFormat = "dd-MMM-yyyy" //"yyyy-MM-dd"
        datePicker.getSelectedDate = { [weak self] selectedDate in
            guard let weakSelf = self else { return }
            //MARK: For the view perpous date format is dd-MMM-yyyy , for logic yyyy-MM-dd
            let dateString = weakSelf.dateFormatter.string(from: selectedDate)
            weakSelf.selectDateButton.setTitle(dateString, for: .normal)
        }
        addViewThroughConstraints(for: datePicker, in: view)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        
        let name = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let descriptionString = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let finalDate = FunctionsHelper.sharedInstance.formattedDateFromString(dateString: selectDateButton.titleLabel?.text ?? "", withFormat: "yyyy-MM-dd", timeFormat: .forLogic)
        
        caseLogic?.delegate = delegate
        
        if caseModel != nil {
            caseModel?.name = name
            caseModel?.description = descriptionString
            caseModel?.scheduled = finalDate
            caseModel?.datastatus = "queue"
            caseLogic?.editCaseDetails(model: caseModel)
        } else {
            if name.isEmpty {
                showAlert("Enter Case Name")
            }else{
                caseLogic?.addNewCase(communityId: self.communityId ?? "", name: name, description: descriptionString, scheduled: finalDate)
            }
        }
        navigationController?.popViewController(animated: true)
    }
        
    @objc func handleKeyBoardNotifications(notification: Notification) {
        let keyBoardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        scrollViewBottomConstraint.constant = isKeyboardShowing ? (keyBoardFrame.height) : 10
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { self.view.layoutIfNeeded()
        } , completion: nil)
    }
}

extension AddCasesViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return range.location <= 10000
    }
}

extension AddCasesViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location <= 100
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyBoard()
        return true
    }
}
