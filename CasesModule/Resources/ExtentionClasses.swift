//
//  ExtentionClasses.swift
//  DigitalHorizonTaksThree
//
//  Created by PGK Shiva Kumar on 30/08/22.
//

import Foundation
import UIKit

extension UIViewController{
    
    func showAlert(_ message : String) {
        
        let message = message
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        let duration: Double = 2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    func showAlertWithActions(_ alertMessage : String , _ alertTitle : String ){
        let dialogMessage = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func hideKeyBoardTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoard(){
        view.endEditing(true)
    }
    
    func addViewThroughConstraints(for customView: UIView, in mainView: UIView) {
            mainView.addSubview(customView)
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
            customView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
            customView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
            customView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        }
}

extension UIImageView { }

extension UIView {
    
    func makeCardView(_ incomingView : UIView){
        incomingView.layer.cornerRadius = 10
        incomingView.layer.shadowColor = UIColor.gray.cgColor
        incomingView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        incomingView.layer.shadowRadius = 4.0
        incomingView.layer.shadowOpacity = 0.5
    }
    
    func makeImageCircle(_ incomingImage : UIImageView , _ imageBorder : CGFloat? , _ borderColor : UIColor? , _ imageRadius : CGFloat?){
        incomingImage.layer.masksToBounds = false
        if imageRadius == nil || imageRadius == 0{
            self.layer.cornerRadius = self.layer.frame.size.height / 2
        }else{
            self.layer.cornerRadius = imageRadius ?? 0.0
        }
        if imageBorder != nil{
            incomingImage.layer.borderWidth = imageBorder ?? 0.0
            if borderColor != nil{
                incomingImage.layer.borderColor = borderColor?.cgColor
            }
        }
        incomingImage.clipsToBounds = true
    }
}

extension UIButton {
    
    func makeButtonCornerRadius(_ incomingButton : UIButton , incomingRadiusValue : CGFloat?){
        if incomingRadiusValue == nil || incomingRadiusValue == 0{
            incomingButton.layer.cornerRadius = incomingButton.layer.frame.size.height / 2
        }else{
            incomingButton.layer.cornerRadius = incomingRadiusValue ?? 0.0
        }
    }
}

extension UIImage {
    
    func toString() -> String? {
        let pngData = self.pngData()
        //let jpegData = self.jpegData(compressionQuality: 0.75)
        return pngData?.base64EncodedString(options: .lineLength64Characters)
    }
}

extension UITextField {
    
    func leftPadding(_ amount:CGFloat){
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func rightPadding(_ amount:CGFloat) {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setIconToTextField(icon incomingImage : UIImage) {
        
        self.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = incomingImage
        imageView.image = image
        imageView.tintColor = .darkGray
        self.leftView = imageView
    }
    
    func allow_MaxCharacters(limit: Int, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let charsLimit = limit
        let startingLength = self.text!.count //testField.text?.characters.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        return newLength <= charsLimit
    }
    
    func allow_Alphabets(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let set = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
        return string.rangeOfCharacter(from: set) == nil
    }
    
    func allow_MobileNumber_withREGEX(text: String) -> Bool {
        
        let isBackSpace = strcmp(text, "\\b")
        if (isBackSpace == -92) {
            return true
        }
        if self.text?.count == 0 {
            if text == "6" || text == "7" || text == "8" || text == "9" {
                return true
            }else {
                return false
            }
        }else if self.text!.count > 9 {
            return false
        }
        return true
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.{1}[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    
    func isValidMobile(setCount: Int) -> Bool {
        if (self.text?.count)! >= setCount {
            return true
        }else{
            return false
        }
    }
    
    func isValidTF() -> Bool {
        if self.text != nil && self.text != "" {
            return true
        }else{
            return false
        }
    }
    
    func isValidPassword_Regex(minChars: Int, isUppercase: Bool, isLowerCase: Bool, isDigit: Bool, isSymbol: Bool) -> Bool {
        // least one uppercase,
        // least one lowercase
        // least one digit
        // least one symbol
        //  min characters total
        
        let password = self.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        var passwordRegx = ""
        //        passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{\(minChars),}$"
        if isUppercase {
            passwordRegx += "(?=.*?[A-Z])"
        }
        if isLowerCase {
            passwordRegx += "(?=.*?[a-z])"
        }
        if isDigit {
            passwordRegx += "(?=.*?[0-9])"
        }
        if isSymbol {
            passwordRegx += "(?=.*?[#?!@$%^&<>*~:`-])"
        }
        
        passwordRegx += ".{\(minChars),}$"
        
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
        
    }
    
    func getExactString(range: NSRange, string: String) -> String {
        
        if let text = self.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            return updatedText
        }else {
            return ""
        }
    }
    
    func allow_below_IntAmount(string: String, amount: Int) -> Bool {
        
        let totalText = self.text!+string
        if let total = Int(totalText) {
            if total <= 100 {
                return true
            }else {
                return false
            }
        }else {
            return false
        }
    }
}

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension String {
    func isValidEmailCondition() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    public func fetchDateFromString(format: String?) -> Date {
        
        //* Formatting String into Date
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = format ?? "yyyy-MM-dd"
        let date                 = dateFormatter.date(from: self)
        return date ?? Date()
    }
}
extension Date {
    
    ///* Return formatted date in String from Fetched Date */
    public func getFormattedStringFromDate(format: String?) -> String {
        
        //* Formatting the Date into String
        let formatter           = DateFormatter()
        formatter.dateFormat    = format ?? "M/d/YY HH:mm a"
        let dateString          = formatter.string(from: self)
        return dateString
    }
}
