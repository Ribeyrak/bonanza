//
//  LoadingVC.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 08.06.2023.
//

import UIKit

class LoadingViewController: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .purple
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        activityIndicator.startAnimating()
    }
}
