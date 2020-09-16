//
//  GitHubApi.swift
//  RxSwiftRepositories
//
//  Created by 小林遼太 on 2020/09/16.
//  Copyright © 2020 小林遼太. All rights reserved.
//

import Foundation
import APIKit

final class GitHubApi {}

// MARK: API struct & Enums
extension GitHubApi {

    struct SearchRequest: GitHubRequest {

        // MARK: - Initialize
        let language: String
        let page: Int

        init(language: String = "Swift", page: Int) {
            self.language = language
            self.page = page
        }

        // MARK: - Request Type
        let method: HTTPMethod = .get
        let path: String = "/search/repositories"

        var parameters: Any? {
            var params = [String: Any]()
            params["q"] = language
            params["sort"] = "stars"
            params["page"] = "\(page)"
            return params
        }

        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> [GitHubRepository] {
            guard let data = object as? Data else {
                throw ResponseError.unexpectedObject(object)
            }
            let res = try JSONDecoder().decode(SearchRepositoriesResponse.self, from: data)
            return res.items
        }
    }

}

