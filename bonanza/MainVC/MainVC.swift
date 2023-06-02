//
//  MainVC.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 11.05.2023.
//

import UIKit
import AVFoundation
import AVKit
import Combine

// MARK: - Constants
private enum Constants {
    static let backgroundImage = "BG"
    static let backScore = "backScore"
    static let textLabel = "3 In A Row"
    static let buttonTitle = "SPIN"
    static let border = "border"
    static let play = UIImage(named: "sweet")
}

class MainVC: UIViewController {
    // MARK: - UI
    var winFlag: Bool = false
    let viewModel = MainVM()
    private var cancellables = Set<AnyCancellable>()
    
    private let backgroundImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: Constants.backgroundImage)
    }
    
    private let scoreImage: UIImageView = {
        let v = UIImageView(image: UIImage(named: Constants.backScore))
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let labelResult: UILabel = {
        let v = UILabel()
        v.textColor = #colorLiteral(red: 0.9527304769, green: 0.9527304769, blue: 0.9527304769, alpha: 1)
        v.font = .preferredFont(forTextStyle: .largeTitle)
        v.textAlignment = .center
        return v
    }()
    
    private let pickerView: UIPickerView = {
        let v = UIPickerView()
        v.contentMode = .scaleToFill
        v.semanticContentAttribute = .unspecified
        v.backgroundColor = .purple.withAlphaComponent(0.5)
        v.layer.cornerRadius = 10
        return v
    }()
    
    private let pickerViewBG = UIImageView().then {
        $0.image = UIImage(named: Constants.border)
    }
    
    private let buttonSpin: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "play"), for: .normal)
        return v
    }()
    
    private let soundButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "soundOn"), for: .normal)
        return v
    }()
    
    private let profileButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "settings"), for: .normal)
        return v
    }()
    
    private var isSoundOn = true
    private var player = AVAudioPlayer()
    private let winPoints = 500
    private var bounds    = CGRect.zero
    private var dataArray = [[Int](), [Int](), [Int](), [Int]()]
    private var winSound  = SoundManager()
    private var rattle    = SoundManager()
    
    var test = RCValues.sharedInstance
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate   = self
        pickerView.dataSource = self
        loadData()
        setupSound()
        spinSlots()
        setupUI()
        configureAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindUI()
    }
    
    // MARK: - Private functions
    private func bindUI() {
        viewModel.$profile
            .map { $0.balance }
            .sink { [unowned self] newBalance in
                labelResult.text = String(newBalance)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(soundButton)
        soundButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.left.equalToSuperview().inset(40)
            $0.height.width.equalTo(55)
        }
        
        view.addSubview(profileButton)
        profileButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.right.equalToSuperview().inset(40)
            $0.height.width.equalTo(55)
        }
        
        view.addSubview(buttonSpin)
        buttonSpin.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(120)
        }
        
        view.addSubview(scoreImage)
        scoreImage.addSubview(labelResult)
        scoreImage.snp.makeConstraints {
            $0.height.equalTo(65)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileButton.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(33)
        }
        
        labelResult.snp.makeConstraints {
            $0.height.equalTo(65)
            $0.width.equalTo(340)
        }
        
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints {
            //$0.centerX.equalToSuperview()
            $0.top.equalTo(scoreImage.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(pickerViewBG)
        pickerViewBG.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(33)
            $0.top.bottom.equalTo(pickerView).offset(-2)
        }
    }
    
    func loadData() {
        //        for i in 0...3 {
        //            for _ in 0...100 {
        //                dataArray[i].append(Int.random(in: 0...K.imageRollArray.count - 1))
        //            }
        //        }
        dataArray = Array(repeating: [], count: 4)
        
        for i in 0...3 {
            for _ in 0...100 {
                let randomIndex = Int.random(in: 0..<K.imageRollArray.count)
                dataArray[i].append(randomIndex)
            }
        }
    }
    
    func setupSound() {
        // SOUND
        winSound.setupPlayer(soundName: K.sound, soundType: SoundType.m4a)
        rattle.setupPlayer(soundName: K.rattle, soundType: .m4a)
        winSound.volume(1.0)
        rattle.volume(0.1)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else { return }
    }
    
    
    func spinSlots() {
        for i in 0...3 {
            pickerView.selectRow(Int.random(in: 3...97), inComponent: i, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.buttonSpin.alpha = 1
        }, completion: nil)
    }
    
    private func configureAppearance() {
        buttonSpin.addAction(.init(handler: { [self] _ in
            spin()
        }), for: .touchUpInside)
        soundButton.addAction(.init(handler: { [self] _ in
            toggleSound()
        }), for: .touchUpInside)
        profileButton.addAction(.init(handler: { [self] _ in
            nextVC()
        }), for: .touchUpInside)
    }
    
    func checkWinOrLose() {
        // Проверка значения labelResult и установка состояния кнопки
        //buttonSpin.isEnabled = points != 50
        let emoji0 = pickerView.selectedRow(inComponent: 0)
        let emoji1 = pickerView.selectedRow(inComponent: 1)
        let emoji2 = pickerView.selectedRow(inComponent: 2)
        let emoji3 = pickerView.selectedRow(inComponent: 3)
        
        if (dataArray[0][emoji0] == dataArray[1][emoji1]
            && dataArray[1][emoji1] == dataArray[2][emoji2]
            && dataArray[2][emoji2] == dataArray[3][emoji3]) {
            labelResult.text = K.win
            winSound.play()
            viewModel.profile.balance += winPoints
        }
    }
    
    func animateButton(){
        // animate button
        let shrinkSize = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width - 15, height: bounds.size.height)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 5,
                       options: .curveLinear,
                       animations: { self.buttonSpin.bounds = shrinkSize },
                       completion: nil )
    }
    
    private func spin() {
        winSound.pause()
        rattle.play()
        spinSlots()
        checkWinOrLose()
        animateButton()
        viewModel.profile.balance -= 10
    }
    
    private func toggleSound() {
        isSoundOn.toggle()
        soundButton.setImage(UIImage(named: isSoundOn ? "soundOn" : "soundOff"), for: .normal)
        
        if isSoundOn {
            winSound.volume(1.0)
            rattle.volume(0.1)
        } else {
            winSound.volume(0.0)
            rattle.volume(0.0)
        }
    }
    
    private func nextVC() {
        let nextVC = ProfileVC(viewModel: viewModel)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func updateBalance() {
        let test = RCValues.sharedInstance
            .updateBalance(forKey: .link)
        let temp = Int(test)
        viewModel.profile.balance = temp ?? 900
    }
    
}

// MARK: - UIPickerViewDataSource
extension MainVC : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
}

// MARK: - UIPickerViewDelegate
extension MainVC: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 70.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        switch component {
        case 0 : imageView.image = K.imageRollArray[(Int)(dataArray[0][row])]
        case 1 : imageView.image = K.imageRollArray[(Int)(dataArray[1][row])]
        case 2 : imageView.image = K.imageRollArray[(Int)(dataArray[2][row])]
        case 3 : imageView.image = K.imageRollArray[(Int)(dataArray[3][row])]
        default : print("done")
        }

        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
//        pickerView.addSubview(imageView)
//        imageView.snp.makeConstraints { make in
//            make.top.bottom.equalTo(pickerView)
//            make.centerY.equalTo(pickerView)
//            make.leading.equalTo(pickerView).offset(10)
//            make.trailing.equalTo(pickerView).inset(10)
//        }
        
        return imageView
    }
}
