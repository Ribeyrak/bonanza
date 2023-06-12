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
    var link = "https://bonanzabillion.fun"
    var appsFID: String = AppsFlyerLib.shared().getAppsFlyerUID()
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        wView = WKWebView(frame: .zero, configuration: webConfiguration)
        wView.uiDelegate = self
        wView.allowsBackForwardNavigationGestures = true
        view = wView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: link)
        let myRequest = URLRequest(url: myURL!)
        wView.load(myRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
