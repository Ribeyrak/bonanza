//
//  PrivacyPolicy.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 22.05.2023.
//

import UIKit
import WebKit
import SnapKit
import AppsFlyerLib
import Alamofire

class PrivacyPolicy: UIViewController, WKUIDelegate {

    var wView: WKWebView!
    var rout = "NiUS37WTD"
    var link: String
    var appsFID: String = AppsFlyerLib.shared().getAppsFlyerUID()
    
    init(link: String) {
        self.link = link
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        wView = WKWebView(frame: .zero, configuration: webConfiguration)
        wView.uiDelegate = self
        wView.allowsBackForwardNavigationGestures = true
        view = wView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(link)
        let myURL = URL(string: link)
        let myRequest = URLRequest(url: myURL!)
        wView.load(myRequest)
    }
}
