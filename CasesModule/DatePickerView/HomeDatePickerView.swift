//
//  HomeDatePickerView.swift
//  Oasis
//
//  Created by Roushil singla on 5/27/21.
//  Copyright © 2021 Nikhil Narayan. All rights reserved.
//

import UIKit

public class HomeDatePickerView: UIView {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet public weak var datePickerView: UIDatePicker!
    
    public var getSelectedDate: ((Date) -> Void)?
    public var onDismissView: (() -> Void)?
    let style = StyleLibrary()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        addGestures()
        showAnimatedPopup()
        datePickerView.maximumDate = Date()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        addGestures()
        showAnimatedPopup()
        datePickerView.maximumDate = Date()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        datePickerView.tintColor = style.appColor
        popupView.layer.cornerRadius = 25
        saveButton.showStyle(with: .title, textColor: .white, bgColor: style.appColor, needCircularCorners: true)
    }
    
    private func commonInit() {
        let bundle = Bundle.init(for: HomeDatePickerView.self)
        if let viewsToAdd = bundle.loadNibNamed("HomeDatePickerView", owner: self, options: nil),
            let contentView = viewsToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
    private func addGestures() {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        gesture.direction = .down
        self.addGestureRecognizer(gesture)
    }
    
    
    @IBAction func onSaveButtonTapped(_ sender: UIButton) {
        getSelectedDate?(datePickerView.date)
        dismissView()
    }
    
    
    @IBAction func onDownArrowClick(_ sender: UIButton) {
        dismissView()
    }
    
    
    private func showAnimatedPopup() {
        popupView.transform = CGAffineTransform(translationX: 0,
                                                y: +popupView.frame.height)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            self.popupView.transform = .identity
        })
    }
    
    
    @objc private func dismissView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.popupView.transform = CGAffineTransform(translationX: 0,
                                                         y: +self.popupView.frame.height)
        }) { (_) in
            self.removeFromSuperview()
        }
        onDismissView?()
    }
    
}
