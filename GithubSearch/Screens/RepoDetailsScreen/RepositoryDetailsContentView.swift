//
//  DetailsContentView.swift
//  GithubSearch
//
//  Created by Dino Bozic on 03/12/2019.
//  Copyright © 2019 Dinz Inc. All rights reserved.
//

import UIKit

class RepositoryDetailsContentView: UIView {

    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let ownerNameLabel = UILabel()
    let forksCountLabel = UILabel()
    let watchersCountLabel = UILabel()
    let issuesCountLabel = UILabel()

    let createdLabel = UILabel()
    let updatedLabel = UILabel()
    let pushedLabel = UILabel()
    let languageLabel = UILabel()
    let descriptionLabel = UILabel()
    let urlLabel = UILabel()
    var repositoryURL: String?

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubviews()
        addSubviews()
        layout()
        detailsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareSubviews() {
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.cornerRadius = 40
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true

        nameLabel.textAlignment = .center
        nameLabel.font = nameLabel.font.withSize(30)

        ownerNameLabel.textAlignment = .center
        ownerNameLabel.font = ownerNameLabel.font.withSize(14)

        forksCountLabel.textAlignment = .left
        forksCountLabel.font = forksCountLabel.font.withSize(14)

        watchersCountLabel.textAlignment = .center
        watchersCountLabel.font = watchersCountLabel.font.withSize(14)

        issuesCountLabel.textAlignment = .right
        issuesCountLabel.font = issuesCountLabel.font.withSize(14)

        createdLabel.textAlignment = .center
        createdLabel.font = createdLabel.font.withSize(10)
        createdLabel.numberOfLines = 2

        updatedLabel.textAlignment = .center
        updatedLabel.font = updatedLabel.font.withSize(10)
        updatedLabel.numberOfLines = 2

        pushedLabel.textAlignment = .center
        pushedLabel.font = pushedLabel.font.withSize(10)
        pushedLabel.numberOfLines = 2

        languageLabel.textAlignment = .center
        languageLabel.font = languageLabel.font.withSize(20)

        descriptionLabel.textAlignment = .center
        descriptionLabel.font = descriptionLabel.font.withSize(20)
        descriptionLabel.numberOfLines = 0

        urlLabel.textAlignment = .center
        urlLabel.font = ownerNameLabel.font.withSize(20)
        urlLabel.text = "Press here to open in browser."
        urlLabel.textColor = .red
        urlLabel.isUserInteractionEnabled = true
    }

    private func addSubviews() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(ownerNameLabel)
        addSubview(forksCountLabel)
        addSubview(watchersCountLabel)
        addSubview(issuesCountLabel)

        addSubview(createdLabel)
        addSubview(updatedLabel)
        addSubview(pushedLabel)
        addSubview(languageLabel)
        addSubview(descriptionLabel)
        addSubview(urlLabel)
    }

    private func layout() {
        avatarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }

        ownerNameLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        forksCountLabel.snp.makeConstraints {
            $0.top.equalTo(ownerNameLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }

        watchersCountLabel.snp.makeConstraints {
            $0.top.equalTo(ownerNameLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        issuesCountLabel.snp.makeConstraints {
            $0.top.equalTo(ownerNameLabel.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }

    private func detailsLayout() {
        createdLabel.snp.makeConstraints {
            $0.top.equalTo(forksCountLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }

        updatedLabel.snp.makeConstraints {
            $0.top.equalTo(forksCountLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        pushedLabel.snp.makeConstraints {
            $0.top.equalTo(forksCountLabel.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        languageLabel.snp.makeConstraints {
            $0.top.equalTo(createdLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(languageLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview().inset(20)
        }

        urlLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configure(repository: Repository,
                   details: RepositoryDetails?) {
        configure(repository: repository)
        guard let details = details else {
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let niceFormatter = DateFormatter()
        niceFormatter.dateFormat = "MMM d, h:mm a"

        if let createdDate = formatter.date(from: details.created ?? "") {
            createdLabel.text = "Created on: \n" + niceFormatter.string(from: createdDate)
        }

        if let updatedDate = formatter.date(from: details.created ?? "") {
            updatedLabel.text = "Last updated on: \n" + niceFormatter.string(from: updatedDate)
        }

        if let pushedDate = formatter.date(from: details.created ?? "") {
            pushedLabel.text = "Last pushed on: \n" + niceFormatter.string(from: pushedDate)
        }

        languageLabel.text = details.language ?? "Unknown language"
        descriptionLabel.text = details.description ?? "No description"
        repositoryURL = details.url
    }

    func configure(repository: Repository) {
        nameLabel.text = repository.name
        ownerNameLabel.text = repository.ownerName

        forksCountLabel.text = "Forks: " + String(repository.forksCount)
        watchersCountLabel.text = "Watchers: " + String(repository.watchersCount)
        issuesCountLabel.text = "Issues: " + String(repository.issueCount)

        let avatarImageURL = URL(string: repository.ownerAvatarURL)
        let data = try? Data(contentsOf: avatarImageURL!)
        avatarImageView.image = UIImage(data: data!)
    }
}
