//
//  UserDetailsContentView.swift
//  GithubSearch
//
//  Created by Dino Bozic on 04/12/2019.
//  Copyright © 2019 Dinz Inc. All rights reserved.
//

import UIKit
import SnapKit

class UserDetailsContentView: UIView {

    let avatarImageView = UIImageView()
    let urlLabel = UILabel()
    let nameLabel = UILabel()
    let locationLabel = UILabel()
    let bioLabel = UILabel()
    let repositoryCountLabel = UILabel()
    let followersCountLabel = UILabel()

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubviews()
        addSubviews()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareSubviews() {
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true

        urlLabel.textAlignment = .center
        urlLabel.font = urlLabel.font.withSize(10)
        urlLabel.text = "Press avatar to open user profile in browser."
        urlLabel.textColor = .darkGray

        nameLabel.textAlignment = .center
        nameLabel.font = nameLabel.font.withSize(30)

        locationLabel.textAlignment = .center
        locationLabel.font = locationLabel.font.withSize(14)

        repositoryCountLabel.textAlignment = .center
        repositoryCountLabel.font = repositoryCountLabel.font.withSize(14)

        followersCountLabel.textAlignment = .center
        followersCountLabel.font = followersCountLabel.font.withSize(14)

        bioLabel.textAlignment = .center
        bioLabel.font = bioLabel.font.withSize(20)
        bioLabel.numberOfLines = 0
    }

    private func addSubviews() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(locationLabel)
        addSubview(repositoryCountLabel)
        addSubview(followersCountLabel)
        addSubview(bioLabel)
        addSubview(urlLabel)
    }

    private func layout() {
        avatarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }

        urlLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(urlLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        locationLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }

        bioLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview().inset(20)
        }

        followersCountLabel.snp.makeConstraints {
            $0.top.equalTo(bioLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(50)
        }

        repositoryCountLabel.snp.makeConstraints {
            $0.top.equalTo(bioLabel.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-50)
        }
    }

    func configure(user: GithubUser?) {
        guard let user = user else {
            return
        }

        nameLabel.text = user.name ?? ""
        locationLabel.text = user.location ?? ""
        bioLabel.text = user.bio ?? ""

        followersCountLabel.text = "Followers: " + String(user.followersCount ?? 0)
        repositoryCountLabel.text = "Repos: " + String(user.publicReposCount ?? 0)

        guard let avatarURL = user.avatarURl else {
            return
        }

        let avatarImageURL = URL(string: avatarURL)
        let data = try? Data(contentsOf: avatarImageURL!)
        avatarImageView.image = UIImage(data: data!)
    }
}
