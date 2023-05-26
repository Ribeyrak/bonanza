//
//  StartVC.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import UIKit
import SnapKit
import Then

final class StartVC: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let backgroundImage = "BG"
        static let sweet = "sweet"
        static let back = "back"
        static let candy = "candy"
        static let firstLabel = "Bonanza Billion Game"
        static let secondLabel = "Pragmatic play"
        static let joinButton = "Join"
        static let logInButton = "Log in"
    }
    
    // MARK: - UI
    private let backgroundImage = UIImageView().then {
        $0.image = UIImage(named: Constants.backgroundImage)
    }
    
    private let candy = UIImageView().then {
        $0.image = UIImage(named: Constants.candy)
    }
    
    private let firstLabel = UILabel().then {
        $0.text = Constants.firstLabel
        $0.textColor = #colorLiteral(red: 0.1702037156, green: 0.1242171898, blue: 0.240055114, alpha: 1)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 52)
    }
    
    private let secondLabel = UILabel().then {
        $0.text = Constants.secondLabel
        $0.textColor = #colorLiteral(red: 0.1702037156, green: 0.1242171898, blue: 0.240055114, alpha: 1)
        $0.font = .preferredFont(forTextStyle: .largeTitle)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let joinButton = CustomButtom().then {
        $0.setTitleAndColor(Constants.logInButton, color: .purple)
        $0.layer.cornerRadius = 2
    }
    
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
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        
        view.addSubview(firstLabel)
        firstLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(88)
            $0.left.right.equalToSuperview()
        }
        
        view.addSubview(secondLabel)
        secondLabel.snp.makeConstraints {
            $0.top.equalTo(firstLabel.snp.bottom).offset(38)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        view.addSubview(joinButton)
        joinButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(73)
            $0.left.right.equalToSuperview().inset(34)
            $0.height.equalTo(69)
        }
        
        view.addSubview(candy)
        candy.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(90)
            $0.right.equalToSuperview().offset(5)
            $0.width.equalTo(UIScreen.main.bounds.width / 2.5)
            $0.height.equalTo(UIScreen.main.bounds.height / 2.5)
        }
    }
    
    private func bindUI() {
        joinButton.addAction(.init(handler: { [self] _ in
            nextVC()
        }), for: .touchUpInside)
    }
    
    // MARK: - Actions
    private func nextVC() {
        let nextVC = LoginVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

