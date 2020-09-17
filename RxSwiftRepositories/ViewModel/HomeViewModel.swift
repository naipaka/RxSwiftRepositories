//
//  HomeViewModel.swift
//  RxSwiftRepositories
//
//  Created by 小林遼太 on 2020/09/16.
//  Copyright © 2020 小林遼太. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelInput {
    var inputTextTrigger: PublishSubject<String> { get }
}

protocol HomeViewModelOutput {
    var showListViewButtonTitle: Observable<String> { get }
    var isEnabledShowListViewButton: Observable<Bool> { get }
}

protocol HomeViewModelType {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

final class HomeViewModel: Injectable, HomeViewModelType, HomeViewModelInput, HomeViewModelOutput {
    typealias Dependency = Void

    var input: HomeViewModelInput { return self }
    var output: HomeViewModelOutput { return self }

    // MARK: - input
    var inputTextTrigger = PublishSubject<String>()

    // MARK: - output
    var showListViewButtonTitle: Observable<String>
    var isEnabledShowListViewButton: Observable<Bool>

    private let disposeBag = DisposeBag()

    // MARK: - injectable
    init(with dependency: Void) {
        self.showListViewButtonTitle = Observable.just("Show Repositories")
        // TODO: falseにする
        self.isEnabledShowListViewButton = Observable.just(true)

        inputTextTrigger.asObserver()
            .subscribe(onNext: { [weak self] text in
                // TODO: 何故か効かない
                self?.isEnabledShowListViewButton = Observable.just(!text.isEmpty)
            }
        ).disposed(by: disposeBag)
    }
}
