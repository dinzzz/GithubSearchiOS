//
//  UserDetailsViewModel.swift
//  GithubSearch
//
//  Created by Dino Bozic on 04/12/2019.
//  Copyright © 2019 Dinz Inc. All rights reserved.
//

import Foundation

class UserDetailsViewModel {

    let userName: String
    var delegate: UserDetailsDelegate? = nil

    init(userName: String) {
        self.userName = userName
    }

    func getUser() {
        guard let url = URL(string: "https://api.github.com/users/\(userName)") else {
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

    public func transformJSON(json: Any) -> GithubUser? {
        guard let repoJSON = json as? [String: Any] else {
            return nil
        }
        let avatarURL = repoJSON["avatar_url"] as? String
        let location = repoJSON["location"] as? String
        let name = repoJSON["name"] as? String
        let bio = repoJSON["bio"] as? String
        let publicReposCount = repoJSON["public_repos"] as? Int
        let followersCount = repoJSON["followers"] as? Int
        let url = repoJSON["html_url"] as? String

        return GithubUser(avatarURl: avatarURL,
                          location: location,
                          name: name,
                          bio: bio,
                          publicReposCount: publicReposCount,
                          followersCount: followersCount,
                          url: url)
    }
}
