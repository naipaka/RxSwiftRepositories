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

class HomeViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var showListViewButton: UIButton!

    private let disposeBag = DisposeBag()

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }

    // MARK: - private
    private func onViewDidLoad() {
        searchTextField.rx.text
            .subscribe(onNext: { text in
                print(text!)
            }
        ).disposed(by: disposeBag)

        showListViewButton.rx.tap
            .subscribe(onNext: { _ in
                print("did tap show list view button")
            }
        ).disposed(by: disposeBag)
    }
}
