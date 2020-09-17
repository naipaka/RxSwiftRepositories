//
//  RepositoryList.swift
//  RxSwiftRepositories
//
//  Created by 小林遼太 on 2020/09/16.
//  Copyright © 2020 小林遼太. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import APIKit

protocol RepositoryListViewModelInput {
    var fetchTrigger: PublishSubject<Void> { get }
    var reachedBottomTrigger: PublishSubject<Void> { get }
}

protocol RepositoryListViewModelOutput {
    var gitHubRepositories: Observable<[GitHubRepository]> { get }
    var navigationBarTitle: Observable<String> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<NSError> { get }
}

protocol RepositoryListViewModelType {
    var input: RepositoryListViewModelInput { get }
    var output: RepositoryListViewModelOutput { get }
}

final class RepositoryListViewModel: Injectable, RepositoryListViewModelType, RepositoryListViewModelInput, RepositoryListViewModelOutput {
    typealias Dependency = GitHubRequestParam

    var input: RepositoryListViewModelInput { return self }
    var output: RepositoryListViewModelOutput { return self }

    // MARK: - input
    var fetchTrigger = PublishSubject<Void>()
    var reachedBottomTrigger = PublishSubject<Void>()
    private let page = BehaviorRelay<Int>(value: 1)

    // MARK: - output
    var gitHubRepositories: Observable<[GitHubRepository]>
    var navigationBarTitle: Observable<String>
    var isLoading: Observable<Bool>
    var error: Observable<NSError>
    private let searchAction: Action<Int, [GitHubRepository]>
    private let disposeBag = DisposeBag()

    // MARK: - injectable
    init(with dependency: GitHubRequestParam) {
        self.navigationBarTitle = Observable.just("\(dependency.language) Repositories")
        self.searchAction = Action { page in
            return Session.shared.rx.response(GitHubApi.SearchRequest(language: dependency.language, page: page))
        }
        let response = BehaviorRelay<[GitHubRepository]>(value: [])
        self.gitHubRepositories = response.asObservable()

        self.isLoading = searchAction.executing.startWith(false)
        self.error = searchAction.errors.map { _ in NSError(domain: "Network Error", code: 0, userInfo: nil) }

        searchAction.elements
            .withLatestFrom(response) { ($0, $1) }
            .map { $0.1 + $0.0 }
            .bind(to: response)
            .disposed(by: disposeBag)

        searchAction.elements
            .withLatestFrom(page)
            .map { $0 + 1 }
            .bind(to: page)
            .disposed(by: disposeBag)

        fetchTrigger
            .withLatestFrom(page)
            .bind(to: searchAction.inputs)
            .disposed(by: disposeBag)

        reachedBottomTrigger
            .withLatestFrom(isLoading)
            .filter { !$0 }
            .withLatestFrom(page)
            .filter { $0 < 5 }
            .bind(to: searchAction.inputs)
            .disposed(by: disposeBag)
    }
}
