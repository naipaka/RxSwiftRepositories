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
    typealias Dependency = HomeViewModel
    private let viewModel: HomeViewModel

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var showListViewButton: UIButton!

    private let disposeBag = DisposeBag()

    // MARK: - Injectable
    required init(with dependency: Dependency) {
        viewModel = dependency
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
        viewModel.output.showListViewButtonTitle
            .observeOn(MainScheduler.instance)
            .bind(to: showListViewButton.rx.title())
            .disposed(by: disposeBag)

        viewModel.output.isEnabledShowListViewButton
            .observeOn(MainScheduler.instance)
            .bind(to: showListViewButton.rx.isEnabled)
            .disposed(by: disposeBag)

        searchTextField.rx.text
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.input.inputTextTrigger.onNext(text ?? "")
            }
        ).disposed(by: disposeBag)

        showListViewButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                print(self?.searchTextField.text ?? "")
            }
        ).disposed(by: disposeBag)
    }
}
