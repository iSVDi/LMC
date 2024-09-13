//
//  MovieStepperView.swift
//  LMS
//
//  Created by Daniil on 13.09.2024.
//

import UIKit
class MovieStepperView: UIView {
    private let backButton = UIButton()
    private let forwardButton = UIButton()
    private var backHander: (()->Void)?
    private var forwardHander: ((()->Void))?
    private let pageLabel = UILabel()
    
    init(backHander: ( () -> Void)?,
         forwardHander: ( () -> Void)?) {
        self.backHander = backHander
        self.forwardHander = forwardHander
        super.init(frame: .zero)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPage(_ page: Int) {
        pageLabel.text = "\(page)"
    }
    
    private func setupLayout() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        [backButton, pageLabel, forwardButton].forEach { subview in
            stack.addArrangedSubview(subview)
            subview.verticalToSuperview()
        }
        
        addSubview(stack)
        stack.edgesToSuperview()
    }
    
    private func setupViews() {
        pageLabel.textAlignment = .center
        pageLabel.textColor = AppColors.appColor
        
        let backImage = UIImage(systemName: "chevron.backward")
        let forwardImage = UIImage(systemName: "chevron.forward")
        
        backButton.setImage(backImage, for: .normal)
        forwardButton.setImage(forwardImage, for: .normal)
        backButton.tintColor = AppColors.appColor
        forwardButton.tintColor = AppColors.appColor
        backButton.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardButtonHandler), for: .touchUpInside)
    }
    
    @objc
    private func backButtonHandler() {
        backHander?()
    }
    
    @objc
    private func forwardButtonHandler() {
        forwardHander?()
    }
    
    
}
