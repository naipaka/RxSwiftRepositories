//
//  RepositoryDetailViewModel.swift
//  RxSwiftRepositories
//
//  Created by 小林遼太 on 2020/09/17.
//  Copyright © 2020 小林遼太. All rights reserved.
//

import RxCocoa
import RxSwift
import Action
import APIKit

protocol RepositoryDetailViewModelInput {}

protocol RepositoryDetailViewModelOutput {
    var repository: GitHubRepository { get }
    var request: URLRequest { get }
    var navigationBarTitle: Observable<String> { get }
}

protocol RepositoryDetailViewModelType {
    var input: RepositoryDetailViewModelInput { get }
    var output: RepositoryDetailViewModelOutput { get }
}

final class RepositoryDetailViewModel: Injectable, RepositoryDetailViewModelType, RepositoryDetailViewModelInput, RepositoryDetailViewModelOutput {
    typealias Dependency = GitHubRepository

    var input: RepositoryDetailViewModelInput { return self }
    var output: RepositoryDetailViewModelOutput { return self }

    // MARK: - Output
    let repository: GitHubRepository
    let request: URLRequest
    let navigationBarTitle: Observable<String>

    private let disposeBag = DisposeBag()

    init(with dependency: GitHubRepository) {
        self.repository = dependency
        self.request = URLRequest(url: dependency.url)
        self.navigationBarTitle = Observable.just(dependency.fullName)
    }

}
