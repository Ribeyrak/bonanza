//
//  ProfileInputView.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import UIKit
import SnapKit

final class ProfileInputView: UIView {
    enum ViewType {
        case phone
        case email
        case text

        var isPhone: Bool {
            self == .phone
        }
    }

    private let titleLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .caption2)
    }
    let textField = CustomTextField().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        $0.clipsToBounds = true
    }

    lazy var phoneNumberTextField = CustomTextField().then {
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.clipsToBounds = true
    }

    private let stackView = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .vertical
        $0.spacing = 4
    }

    private let viewType: ViewType

    public var title: String = "" {
        willSet {
            titleLabel.text = newValue
        }
    }

    public var placeholder: String = "" {
        willSet {
            textField.placeholder = newValue
        }
    }

    public var inputText: String = "" {
        willSet {
            if viewType.isPhone {
                phoneNumberTextField.text = newValue
            } else {
                textField.text = newValue
            }
        }
    }

    init(type: ViewType = .text) {
        self.viewType = type
        super.init(frame: .zero)
        self.setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(stackView)

        [
            titleLabel,
            viewType.isPhone ? phoneNumberTextField : textField
        ].forEach(stackView.addArrangedSubview)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        (viewType.isPhone ? phoneNumberTextField : textField).snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
}
