//
//  SearchResultCell.swift
//  GithubSearch
//
//  Created by Dino Bozic on 02/12/2019.
//  Copyright © 2019 Dinz Inc. All rights reserved.
//

import UIKit
import SnapKit

class SearchResultCell: UITableViewCell {

    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let ownerNameLabel = UILabel()
    let forksCountLabel = UILabel()
    let watchersCountLabel = UILabel()
    let issuesCountLabel = UILabel()

    var ownerUserName: String?
    weak var delegate: TapHandleDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        UISetup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func UISetup() {
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true

        nameLabel.textAlignment = .left
        nameLabel.font = nameLabel.font.withSize(20)

        ownerNameLabel.textAlignment = .left
        ownerNameLabel.font = ownerNameLabel.font.withSize(14)

        forksCountLabel.textAlignment = .right
        forksCountLabel.font = forksCountLabel.font.withSize(14)

        watchersCountLabel.textAlignment = .right
        watchersCountLabel.font = watchersCountLabel.font.withSize(14)

        issuesCountLabel.textAlignment = .right
        issuesCountLabel.font = issuesCountLabel.font.withSize(14)

        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(ownerNameLabel)
        addSubview(forksCountLabel)
        addSubview(watchersCountLabel)
        addSubview(issuesCountLabel)
    }

    private func layout() {
        avatarImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(watchersCountLabel.snp.leading).offset(-10)
            $0.centerY.equalToSuperview().offset(-10)
        }

        ownerNameLabel.snp.makeConstraints {
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(watchersCountLabel.snp.leading).offset(-10)
            $0.centerY.equalToSuperview().offset(10)
        }

        forksCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview().offset(-20)
        }

        watchersCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }

        issuesCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview().offset(20)
        }
    }

    func configure(repository: Repository) {
        nameLabel.text = repository.name
        ownerNameLabel.text = repository.ownerName
        ownerUserName = repository.ownerName
        
        forksCountLabel.text = "Forks: " + String(repository.forksCount)
        watchersCountLabel.text = "Watchers: " + String(repository.watchersCount)
        issuesCountLabel.text = "Issues: " + String(repository.issueCount)

        avatarImageView.imageFromServerURL(urlString: repository.ownerAvatarURL)
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarTapped)))
    }

    @objc func avatarTapped() {
        guard let userName = ownerUserName else {
            return
        }
        delegate?.didTapAvatar(username: userName)
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }
}
