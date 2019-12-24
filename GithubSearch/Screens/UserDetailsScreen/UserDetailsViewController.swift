//
//  UserDetailsViewController.swift
//  GithubSearch
//
//  Created by Dino Bozic on 03/12/2019.
//  Copyright © 2019 Dinz Inc. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, UserDetailsDelegate {

    let userName: String
    var viewModel: UserDetailsViewModel
    let contentView = UserDetailsContentView()
    var userURL: String?

    init(userName: String) {
        self.userName = userName
        viewModel = UserDetailsViewModel(userName: userName)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.getUser()

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

    func didGetDetails(result: GithubUser?) {
        contentView.configure(user: result)
        userURL = result?.url
        contentView
            .avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                         action: #selector(openUserInBrowser)))
    }

    @objc func openUserInBrowser() {
        guard let url = userURL else {
            return
        }
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
