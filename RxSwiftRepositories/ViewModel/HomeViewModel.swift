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
    var isEmpty: Observable<Bool> { get }
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
    var isEmpty: Observable<Bool>
    private let isEmptySubject = PublishSubject<Bool>()

    private let disposeBag = DisposeBag()

    // MARK: - injectable
    init(with dependency: Void) {
        self.showListViewButtonTitle = Observable.just("Show Repositories")
        self.isEmpty = isEmptySubject

        inputTextTrigger
            .map { $0.isEmpty }
            .bind(to: isEmptySubject)
            .disposed(by: disposeBag)
    }
}
