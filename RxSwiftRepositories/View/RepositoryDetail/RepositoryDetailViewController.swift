//
//  RepositoryDetailViewController.swift
//  RxSwiftRepositories
//
//  Created by 小林遼太 on 2020/09/17.
//  Copyright © 2020 小林遼太. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import WebKit
import RxWebKit

class RepositoryDetailViewController: UIViewController, Injectable {
    typealias Dependency = RepositoryDetailViewModel
    private let viewModel: RepositoryDetailViewModelType

    @IBOutlet weak var repositoryDetailWebView: WKWebView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    private let disposeBag = DisposeBag()

    // MARK: - injectable
    required init(with dependency: RepositoryDetailViewModel) {
        viewModel = dependency
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.output.navigationBarTitle
            .observeOn(MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        repositoryDetailWebView.rx.loading
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        repositoryDetailWebView.load(viewModel.output.request)
    }
}
