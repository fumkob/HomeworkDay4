//
//  GitHubData.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/05/22.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct GitHubData {
    //リポジトリ名
    let repositoryName: String
    //ユーザーアイコン
    let userIconUrl: String
    //ユーザー名
    let userName: String
    //リポジトリ説明文
    let description: String
    //スター数
    let starCount: Int
    //フォーク数
    let forkCount: Int
    //ウォッチ数
    let watcherCount: Int
    //作成日
    let createdDate: String
    //更新日
    let updatedDate: String
    //初期化
    init(item: JSON) {
        guard let repositoryName = item["name"].string else {
            fatalError("Required parameter \"name\" is missing")
        }
        guard let userIconUrl = item["owner"]["avatar_url"].string else {
            fatalError("Required parameter \"owner/avatar_url\" is missing")
        }
        guard let userName = item["owner"]["login"].string else {
            fatalError("Required parameter \"owner/login\" is missing")
        }
        guard let description = item["description"].string else {
            fatalError("Required parameter \"description\" is missing")
        }
        guard let starCount = item["stargazers_count"].int else {
            fatalError("Required parameter \"stargazers_count\" is missing")
        }
        guard let forkCount = item["forks_count"].int else {
            fatalError("Required parameter \"forks_count\" is missing")
        }
        guard let watcherCount = item["watchers_count"].int else {
            fatalError("Required parameter \"watchers_count\" is missing")
        }
        guard let createdDate = item["created_at"].string else {
            fatalError("Required parameter \"created_at\" is missing")
        }
        guard let updatedDate = item["updated_at"].string else {
            fatalError("Required parameter \"updated_at\" is missing")
        }
        self.repositoryName = repositoryName
        self.userIconUrl = userIconUrl
        self.userName = userName
        self.description = description
        self.starCount = starCount
        self.forkCount = forkCount
        self.watcherCount = watcherCount
        self.createdDate = createdDate
        self.updatedDate = updatedDate
    }
}
