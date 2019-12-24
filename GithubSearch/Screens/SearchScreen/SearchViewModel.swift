//
//  SearchViewModel.swift
//  GithubSearch
//
//  Created by Dino Bozic on 02/12/2019.
//  Copyright © 2019 Dinz Inc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SearchViewModel {

    let searchText = BehaviorRelay(value: "")
    let sort = BehaviorRelay(value: "stars")
    let showLoading = BehaviorRelay<Bool>(value: false)

    lazy var results: Observable<[Repository]> = {
        Observable.combineLatest(self.searchText.asObservable(), self.sort.asObservable())
            .flatMapLatest(searchRepos)
    }()

    func searchRepos(_ searchText: String, _ sort: String) -> Observable<[Repository]> {
        showLoading.accept(true)
        let text = searchText.replacingOccurrences(of: " ", with: "+")
        guard !text.isEmpty,
            let url = URL(string: "https://api.github.com/search/repositories?q=\(text)&sort=\(sort)") else {
                return Observable.just([])
        }
        return URLSession.shared.rx.json(url: url)
            .map(transformJSON)
    }

    func transformJSON(json: Any) -> [Repository] {
        guard let searchJSON = json as? [String: Any] else {
            return []
        }

        guard let items = searchJSON["items"] as? [[String: Any]] else {
            return []
        }

        var repositories = [Repository]()

        items.forEach {
            guard let name = $0["name"] as? String,
                let owner = $0["owner"] as? [String: Any],
                let ownerName = owner["login"] as? String,
                let ownerAvatarURL = owner["avatar_url"] as? String,
                let watchersCount = $0["watchers_count"] as? Int,
                let forksCount = $0["forks_count"] as? Int,
                let issueCount = $0["open_issues_count"] as? Int else {
                    return
            }

            let repository = Repository(name: name,
                                        ownerName: ownerName,
                                        ownerAvatarURL: ownerAvatarURL,
                                        watchersCount: watchersCount,
                                        forksCount: forksCount,
                                        issueCount: issueCount)
            repositories.append(repository)
        }

        showLoading.accept(false)
        return repositories
    }
}
