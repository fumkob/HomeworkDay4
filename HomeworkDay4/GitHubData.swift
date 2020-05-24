//
//  GitHubData.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/05/22.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation

class GitHubData {
    //リポジトリ名
    var repositoryName: String?
    //ユーザーアイコン
    var userIconUrl: String?
    //ユーザー名
    var userName: String?
    //リポジトリ説明文
    var description: String?
    //スター数
    var starCount: Int?
    //フォーク数
    var forkCount: Int?
    //ウォッチ数
    var watcherCount: Int?
    //作成日
    var createdDate: String?
    //更新日
    var updatedDate: String?
    
//    init?(items: JSON, number: Int) {
//        guard
//            let repositoryName = items[number]["name"].string,
//            let userIconUrl = items[number]["owner"]["avatar_url"].string,
//            let userName = items[number]["owner"]["login"].string,
//            let description = items[number]["description"].string,
//            let starCount = items[number]["stargazers_count"].int,
//            let forkCount = items[number]["forks_count"].int,
//            let watcherCount = items[number]["watchers_count"].int,
//            let createdDate = items[number]["created_at"].string,
//            let updatedDate = items[number]["updated_at"].string
//
//        else {
//            return nil
//        }
//        self.repositoryName = repositoryName
//        self.userIconUrl = userIconUrl
//        self.userName = userName
//        self.description = description
//        self.starCount = starCount
//        self.forkCount = forkCount
//        self.watcherCount = watcherCount
//        self.createdDate = createdDate
//        self.updatedDate = updatedDate
//    }
}
