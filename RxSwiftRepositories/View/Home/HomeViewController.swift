//
//  ViewController.swift
//  RxSwiftRepositories
//
//  Created by 小林遼太 on 2020/09/16.
//  Copyright © 2020 小林遼太. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, Injectable {
    typealias Dependency = Void

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var showListViewButton: UIButton!

    private let disposeBag = DisposeBag()

    // MARK: - Injectable
    required init(with dependency: Void) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }

    // MARK: - private
    private func onViewDidLoad() {
        searchTextField.rx.text
            .subscribe(onNext: { [weak self] text in
                self?.showListViewButton.isEnabled = !(text?.isEmpty ?? true)
            }
        ).disposed(by: disposeBag)

        showListViewButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                print(self?.searchTextField.text ?? "")
            }
        ).disposed(by: disposeBag)
    }
}
