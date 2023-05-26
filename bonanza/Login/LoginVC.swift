//
//  LoginVC.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import UIKit
import WebKit

final class LoginVC: UIViewController, WKUIDelegate {
    
    // MARK: - Constants
    private enum Constants {
        static let backgroundImage = "bg2"
        static let firstLabel = "Registration"
        static let loginPlaceholder = "Name"
        static let passwordPlaceholder = "Password"
        static let buttonTitle = "Join"
        
        static let nameAlertTitle = "Warning"
        static let nameAlertMessage = "All fields must be filled"
        static let emailAlertTitle = "Incorrect email"
        static let emailAlertMessage = "Enter valid email"
        static let passwordAlertTitle = "Incorrect phone"
        static let passwordAlertMessage = "Must contain 6-12 numbers"
    }
    
    // MARK: - UI
    private let backgroundImage = UIImageView().then {
        $0.image = UIImage(named: Constants.backgroundImage)
    }
    
    private let firstLabel = UILabel().then {
        $0.text = Constants.firstLabel
        $0.textColor = .black
        $0.font = .preferredFont(forTextStyle: .largeTitle)
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
    }
    
    private let nickNameField = CustomTextField().then {
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = 18
        $0.placeholder = Constants.loginPlaceholder
    }
    
    private let passwordField = CustomTextField().then {
        $0.isSecureTextEntry = true
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.layer.cornerRadius = 18
        $0.placeholder = Constants.passwordPlaceholder
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = .systemGray.withAlphaComponent(0.5)
    }
    
    private let divider2 = UIView().then {
        $0.backgroundColor = .systemGray.withAlphaComponent(0.5)
    }
    
    private let joinButton = CustomButtom().then {
        $0.setTitleAndColor(Constants.buttonTitle, color: .purple)
    }
    
    private let privacyPolicyButton = UIButton().then {
        $0.setTitle("Privacy policy", for: .normal)
        $0.setTitleColor(.black.withAlphaComponent(0.9), for: .normal)
    }
    
    let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindUI()
    }
    
    // MARK: - Private functions
    private func setupUI() {
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(firstLabel)
        firstLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(44)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(divider)
        divider.snp.makeConstraints() {
            $0.height.equalTo(1)
        }
        
        view.addSubview(divider2)
        divider2.snp.makeConstraints() {
            $0.height.equalTo(1)
        }
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(nickNameField)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(divider2)
        
        stackView.snp.makeConstraints() {
            $0.center.equalToSuperview().offset(-88)
            $0.left.right.equalToSuperview().inset(34)
            $0.height.equalTo(96)
        }
        
        view.addSubview(joinButton)
        joinButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(64)
            $0.left.right.equalToSuperview().inset(38)
            $0.height.equalTo(69)
        }
        
        view.addSubview(privacyPolicyButton)
        privacyPolicyButton.snp.makeConstraints() {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.top.equalTo(joinButton.snp.bottom).offset(20)
        }
    }
    
    private func bindUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        joinButton.addAction(.init(handler: { [self] _ in
            nextVC()
        }), for: .touchUpInside)
        
        privacyPolicyButton.addAction(.init(handler: { [self] _ in
            let nextVC = PrivacyPolicy(link: RCValues.sharedInstance.updateLink(forKey: .link))
            navigationController?.present(nextVC, animated: true)
        }), for: .touchUpInside)
    }
    
    // MARK: - Actions
    // TextFields Validation
    private func nextVC() {
        
        if let name = nickNameField.text, let password = passwordField.text {
            if name.isEmpty || password.isEmpty {
                Validator().simpleAlert(vc: self, title: Constants.nameAlertTitle, message: Constants.nameAlertMessage)
            } else {
                if !password.isValidPassword {
                    Validator().simpleAlert(vc: self, title: Constants.passwordAlertTitle, message: Constants.passwordAlertMessage)
                } else {
                    var profile = ProfileModel.default
                    profile.firstName = nickNameField.text ?? ""
                    profile.pasword = passwordField.text ?? ""
                    let nextVC = MainVC()
                    
                    FileDataManager().write(data: profile, key: .one)
                    
                    navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        }
    }
}
