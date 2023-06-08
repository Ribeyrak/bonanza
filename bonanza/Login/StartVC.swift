//
//  StartVC.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import UIKit
import SnapKit
import Then
import Alamofire
import AppsFlyerLib

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
        $0.contentMode = .scaleAspectFill
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
    
    var window: UIWindow?
    var appsFID: String = ""
    var utms: String = "organic"
    var campaign: String = ""
    var campID: String = ""
    var appDelegate: AppDelegate?
    var advertising_id: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //parseCampaing()
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
            $0.height.equalTo(UIScreen.main.bounds.height / 3)
        }
    }
    
    private func bindUI() {
        joinButton.addAction(.init(handler: { [self] _ in
            nextVC()
        }), for: .touchUpInside)
    }
    
    func parseCampaing() {
        do {
            let components = campaign.components(separatedBy: "_")
            var t1 = "organic"
            var t2 = "organic"
            var t3 = "organic"
            var t4 = "organic"
            var t5 = "organic"
            
            if components.count >= 5 {
                t1 = components[0]
                t2 = components[1]
                t3 = components[2]
                t4 = components[3]
                t5 = components[4]
            }
            
            let urlString = "https://bonanzabillion.fun/NiUS37WTD?1drgsc6=\(UserDefaults.standard.string(forKey: UserDefaultsKeys.userID.rawValue))&ZCcmVT9XF=\(appsFID)&upiyls=\(campID)&Yaymb09=\(AppsFlyerLib.shared().appleAppID)&yd8Ls=\(utms)&qsL6UPS9XU=\(t1)&vlnaomzd=\(t2)&lrz2Cbs=\(t3)&AB23Cf78=\(t4)&xA5Ga1=\(t5)&sn23sl6=\(advertising_id)"
            
            AF.request(urlString).response { [self] response in
                switch response.result {
                case .success(let value):
                    print("TESSST")

                    let someString = String(data: value!, encoding: .utf8)
                    let tempSting = String(someString!.reversed())
                    let privacyPolicyVC = PrivacyPolicy(link: tempSting)
                    privacyPolicyVC.link = tempSting
                    
                    let viewController = UINavigationController(rootViewController: PrivacyPolicy(link: tempSting))
                    window?.rootViewController = viewController
                case .failure(let error):
                    print("TESSST+++")

                    print("Request failed with error: \(error)")
                    let privacyPolicyVC = PrivacyPolicy(link: RCValues.sharedInstance.updateLink(forKey: .link))
                    privacyPolicyVC.link = RCValues.sharedInstance.updateLink(forKey: .link)
                    let viewController = UINavigationController(rootViewController: StartVC())
                    window?.rootViewController = viewController
                }
            }
            
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    // MARK: - Actions
    private func nextVC() {
        let nextVC = LoginVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

