//
//  RepositoryListViewController.swift
//  RxSwiftRepositories
//
//  Created by 小林遼太 on 2020/09/16.
//  Copyright © 2020 小林遼太. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RepositoryListViewController: UIViewController, Injectable {
    typealias Dependency = RepositoryListViewModel
    private let viewModel: RepositoryListViewModel

    @IBOutlet weak var repositoryListTableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewWillAppear()
    }

    // MARK: - private
    private func onViewDidLoad() {
        // Bind ViewModel Outputs
        viewModel.output.navigationBarTitle
            .observeOn(MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.output.gitHubRepositories
            .observeOn(MainScheduler.instance)
            .bind(to: repositoryListTableView.rx.items) { tableView, row, githubRepository in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")
                cell.textLabel?.text = "\(githubRepository.fullName)"
                cell.detailTextLabel?.textColor = UIColor.lightGray
                cell.detailTextLabel?.text = "\(githubRepository.description)"
                return cell
            }
            .disposed(by: disposeBag)

        repositoryListTableView.rx.modelSelected(GitHubRepository.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let vc = RepositoryDetailViewController(with: RepositoryDetailViewModel(with: $0))
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.output.isLoading
            .observeOn(MainScheduler.instance)
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.output.isLoading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.repositoryListTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: $0 ? 50 : 0, right: 0)
            })
            .disposed(by: disposeBag)

        viewModel.output.error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let ac = UIAlertController(title: "Error \($0)", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(ac, animated: true)
            })
            .disposed(by: disposeBag)


        // Bind ViewModel Inputs
        repositoryListTableView.rx.reachedBottom.asObservable()
            .bind(to: viewModel.input.reachedBottomTrigger)
            .disposed(by: disposeBag)

        viewModel.input.fetchTrigger.onNext(())
    }

    private func onViewWillAppear() {
        repositoryListTableView.indexPathsForSelectedRows?.forEach { [weak self] in
            self?.repositoryListTableView.deselectRow(at: $0, animated: true)
        }
    }
}
