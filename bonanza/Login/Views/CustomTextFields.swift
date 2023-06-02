//
//  CustomTextFields.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import UIKit

final class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private function
    func configure() {
        backgroundColor = .secondarySystemBackground
        font = .systemFont(ofSize: 19)
        layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        autocorrectionType = .no
    }
}
    //MARK: TextFiled Delegate
extension CustomTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardAppearance = .default
        if textField == self {
            becomeFirstResponder()
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self {
            resignFirstResponder()
        }
        return true
    }

}
