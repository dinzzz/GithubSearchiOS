//
//  DetailsDelegate.swift
//  GithubSearch
//
//  Created by Dino Bozic on 04/12/2019.
//  Copyright © 2019 Dinz Inc. All rights reserved.
//

import Foundation

protocol RepositoryDetailsDelegate {
    
    func didGetDetails(result: RepositoryDetails?)
}
