//
//  DetailsViewModel.swift
//  GithubSearch
//
//  Created by Dino Bozic on 03/12/2019.
//  Copyright © 2019 Dinz Inc. All rights reserved.
//

import Foundation

class RepositoryDetailsViewModel {

    let userName: String
    let repoName: String
    var delegate: RepositoryDetailsDelegate? = nil

    init(userName: String, repoName: String) {
        self.userName = userName
        self.repoName = repoName
    }

    func getRepo() {
        guard let url = URL(string: "https://api.github.com/repos/\(userName)/\(repoName)") else {
            print("Error!")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let content = data
            {
                do
                {
                    let myJson = try JSONSerialization
                        .jsonObject(with: content,
                                    options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject
                    DispatchQueue.main.async {
                        self.delegate?.didGetDetails(result: self.transformJSON(json: myJson))
                    }
                }
                catch {
                    print("Error!")
                    return
                }
            }
        }.resume()
    }

    public func transformJSON(json: Any) -> RepositoryDetails? {
        guard let repoJSON = json as? [String: Any] else {
            return nil
        }
        let created = repoJSON["created_at"] as? String
        let updated = repoJSON["updated_at"] as? String
        let pushed = repoJSON["pushed_at"] as? String
        let language = repoJSON["language"] as? String
        let description = repoJSON["description"] as? String
        let url = repoJSON["html_url"] as? String

        return RepositoryDetails(created: created,
                                 updated: updated,
                                 pushed: pushed,
                                 language: language,
                                 description: description,
                                 url: url)
    }
}
