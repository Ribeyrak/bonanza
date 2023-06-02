//
//  ProfileVC.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import UIKit
import Combine
import CombineCocoa

class ProfileVC: UIViewController {
    
    //MARK: - UI
    private(set) lazy var phoneTextField = ProfileInputView(type: .phone).then {
        $0.title = "Phone"
        $0.inputText = viewModel.profile.phoneNumber
    }
    private(set) lazy var emailTextField = ProfileInputView(type: .email).then {
        $0.title = "Email"
        $0.inputText = viewModel.profile.userEmail
    }
    private(set) lazy var firstNameTextField = ProfileInputView().then {
        $0.title = "Name"
        $0.inputText = viewModel.profile.firstName
    }
    
    private(set) lazy var balanceTextField = ProfileInputView().then {
        $0.title = "Balance"
        $0.inputText = String(viewModel.profile.balance)
    }
    
    private let getMoney = CustomButtom().then {
        $0.setTitleAndColor("Get Points", color: .systemGreen)
        $0.layer.cornerRadius = 2
    }
    
    private let logoutButton = CustomButtom().then {
        $0.setTitleAndColor("Logout", color: .systemRed)
        $0.layer.cornerRadius = 2
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Properties
    private let viewModel: MainVM
    
    init(viewModel: MainVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        setupUI()
        configureAppearance()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    //MARK: - Private functions
    
    private func bindUI() {
        phoneTextField.phoneNumberTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] text in
                viewModel.profile.phoneNumber = text ?? ""
            }
            .store(in: &cancellables)
        
        emailTextField.textField.textPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] text in
                viewModel.profile.userEmail = text ?? ""
            }
            .store(in: &cancellables)
        
        firstNameTextField.textField.textPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] text in
                viewModel.profile.firstName = text ?? ""
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        title = "Profile"
        view.addSubview(stackView)
        
        [phoneTextField, emailTextField, firstNameTextField,balanceTextField,
         logoutButton
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(52)
            }
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(getMoney)
        getMoney.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).inset(-34)
            $0.left.right.equalToSuperview().inset(34)
            $0.height.equalTo(49)
        }
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(34)
            $0.left.right.equalToSuperview().inset(34)
            $0.height.equalTo(49)
        }
    }
    
    private func configureAppearance() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        getMoney.addAction(.init(handler: { [self] _ in
            viewModel.profile.balance += 500
            balanceTextField.textField.text = String(viewModel.profile.balance)
        }), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        let nextVC = UINavigationController(rootViewController: StartVC())
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController = nextVC
    }
}
