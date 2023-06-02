//
//  CustomButtom.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import UIKit

final class CustomButtom: UIButton {

    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitleAndColor(_ title: String, color: UIColor) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.attributedTitle?.font = .systemFont(ofSize: 28)
        config.baseBackgroundColor = color
        config.baseForegroundColor = .white
        config.background.strokeColor = .white
        config.background.strokeWidth = 1
        config.cornerStyle = .capsule

        self.configuration = config
    }
}

private extension CustomButtom {
    func addViews() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
