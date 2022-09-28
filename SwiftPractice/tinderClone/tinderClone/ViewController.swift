//
//  ViewController.swift
//  tinderClone
//
//  Created by 上條栞汰 on 2022/09/28.
//

import UIKit

class ViewController: UIViewController {
    
    private let view1: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private let view2: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private let view3: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    private lazy var layoutStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [view1, view2, view3])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraint()
    }
    
    private func setupViews() {
        view.addSubview(layoutStackView)
    }
    
    private func setupConstraint() {
        [
            view1.heightAnchor.constraint(equalToConstant: 100),
            view3.heightAnchor.constraint(equalToConstant: 120),
            
            layoutStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            layoutStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            layoutStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            layoutStackView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ].forEach { $0.isActive = true }
    }
}

