//
//  ViewController.swift
//  GithubSearch
//
//  Created by Dino Bozic on 02/12/2019.
//  Copyright © 2019 Dinz Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    var tableView: UITableView!

    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { return searchController.searchBar }

    var viewModel = SearchViewModel()
    let disposeBag = DisposeBag()

    let starsButton = UIButton()
    let forksButton = UIButton()
    let updatedButton = UIButton()

    let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        setupTableView()
        setupSearchController()
        layout()
        
        viewModel.results
            .catchError { [weak self] error -> Observable<[Repository]> in
                self?.showError(error.localizedDescription)
                return Observable.just([])
        }
        .bind(to: self.tableView.rx.items(cellIdentifier: "SearchResultCell",
                                          cellType: SearchResultCell.self)) { (_, result, cell) in
                                            cell.configure(repository: result)
                                            cell.delegate = self
        }
        .disposed(by: disposeBag)

        tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: {
                let repoVC = RepositoryDetailsViewController(repository: $0)
                self.searchController.present(repoVC, animated: true, completion: nil)
            }).disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
    }

    func setupButtons() {
        starsButton.setTitle("Stars", for: .normal)
        starsButton.backgroundColor = .lightGray

        forksButton.setTitle("Forks", for: .normal)
        forksButton.backgroundColor = .lightGray

        updatedButton.setTitle("Updated", for: .normal)
        updatedButton.backgroundColor = .lightGray

        view.addSubview(starsButton)
        view.addSubview(forksButton)
        view.addSubview(updatedButton)

        starsButton.rx.tap
            .bind {
                self.viewModel.sort.accept("stars")
        }
        .disposed(by: disposeBag)

        forksButton.rx.tap
            .bind {
                self.viewModel.sort.accept("forks")
        }
        .disposed(by: disposeBag)

        updatedButton.rx.tap
            .bind {
                self.viewModel.sort.accept("updated")
        }
        .disposed(by: disposeBag)
    }

    func setupTableView() {
        tableView = UITableView(frame: self.view.frame, style: .plain)

        activityIndicator.center = tableView.center
        tableView.addSubview(activityIndicator)
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 80
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")

        view.addSubview(tableView)
    }

    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Github"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }

    func layout() {
        starsButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalTo(forksButton.snp.leading)
            $0.height.equalTo(30)
        }

        forksButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        }

        updatedButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalTo(forksButton.snp.trailing)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(starsButton.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().offset(-30)
        }
    }

    private func showError(_ errorMessage: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "An error occured", message: "Oops, something went wrong!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in
                self.viewDidLoad()
            }))
            self.searchController.present(controller, animated: true, completion: nil)
        }
    }
}

extension SearchViewController: TapHandleDelegate {

    func didTapAvatar(username: String) {
        let userVC = UserDetailsViewController(userName: username)
        self.searchController.present(userVC, animated: true, completion: nil)
    }
}
