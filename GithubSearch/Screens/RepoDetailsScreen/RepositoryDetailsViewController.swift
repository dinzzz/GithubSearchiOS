//
//  RepositoryDetailsViewController.swift
//  GithubSearch
//
//  Created by Dino Bozic on 03/12/2019.
//  Copyright © 2019 Dinz Inc. All rights reserved.
//

import UIKit
import SnapKit
class RepositoryDetailsViewController: UIViewController, RepositoryDetailsDelegate {

    let repository: Repository
    var viewModel: RepositoryDetailsViewModel
    let contentView = RepositoryDetailsContentView()
    var repositoryURL: String?

    init(repository: Repository) {
        self.repository = repository
        viewModel = RepositoryDetailsViewModel(userName: repository.ownerName, repoName: repository.name)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.getRepo()

        view.addSubview(contentView)
        contentView.backgroundColor = .lightGray
        layout()
    }

    func layout() {
        contentView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(600)
        }
    }

    func didGetDetails(result: RepositoryDetails?) {
        contentView.configure(repository: repository,
                              details: result)
        repositoryURL = result?.url
        contentView.urlLabel.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                         action: #selector(openRepositoryInBrowser)))

        contentView.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                                action: #selector(openUserDetails)))
    }

    @objc func openRepositoryInBrowser() {
        guard let url = repositoryURL else {
            return
        }
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }

    @objc func openUserDetails() {
        self.present(UserDetailsViewController(userName: repository.ownerName), animated: true, completion: nil)
    }
}
