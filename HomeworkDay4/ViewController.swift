//
//  ViewController.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/05/22.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var gitHubDataArray = [GitHubData]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テーブル設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GitHubCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        //APIデータ取得
        let url = URL(string: "https://api.github.com/search/repositories?q=language%3Aswift&sort=stars")!
        var urlRequest = URLRequest(url: url)
        //タイムアウト時間定義
        urlRequest.timeoutInterval = 5
        //データ取得
        AF.request(urlRequest).validate().responseJSON {
            response in
            switch response.result {
            //成功
            case .success(let value) :
                let jsonData = JSON(value)
                let items = jsonData["items"]
                
                //データを解析し、配列に格納する
                self.gitHubDataArray = self.parseData(items: items)
            //失敗
            case .failure :
                print("Read Error")
                return
            }
            
            //テーブルデータ更新
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
    }

    //テーブルセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitHubDataArray.count
    }
    
    //テーブル内データ->GitHubCellを適用
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GitHubCell
        cell.repositoryNameLabel.text = "\(gitHubDataArray[indexPath.row].repositoryName!)"
        cell.userNameLabel.text = "\(gitHubDataArray[indexPath.row].userName!)"
        cell.descriptionLabel.text = "\(gitHubDataArray[indexPath.row].description!)"
        cell.starsLabel.text = "\(gitHubDataArray[indexPath.row].starCount!)"
        cell.forksLabel.text = "\(gitHubDataArray[indexPath.row].forkCount!)"
        cell.watchersLabel.text = "\(gitHubDataArray[indexPath.row].watcherCount!)"
        
        //DispatchQueueで画像を取得
        
        return cell
    }
    
    //テーブル高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200  //クラスを作成して可変にする
    }
    
    //データを解析
        func parseData(items: JSON) -> [GitHubData] {
            var dataArray = [GitHubData]()
            //各値を格納する
            for (number,_) in items.enumerated() {
                let gitHubData = GitHubData()
                
                if
                    let repositoryName = items[number]["name"].string,
                    let userIconUrl = items[number]["owner"]["avatar_url"].string,
                    let userName = items[number]["owner"]["login"].string,
                    let description = items[number]["description"].string,
                    let starCount = items[number]["stargazers_count"].int,
                    let forkCount = items[number]["forks_count"].int,
                    let watcherCount = items[number]["watchers_count"].int,
                    let createdDate = items[number]["created_at"].string,
                    let updatedDate = items[number]["updated_at"].string {
                    
                    gitHubData.repositoryName = repositoryName
                    gitHubData.userIconUrl = userIconUrl
                    gitHubData.userName = userName
                    gitHubData.description = description
                    gitHubData.starCount = starCount
                    gitHubData.forkCount = forkCount
                    gitHubData.watcherCount = watcherCount
                    gitHubData.createdDate = createdDate
                    gitHubData.updatedDate = updatedDate
                
                }

                
                dataArray.append(gitHubData)
            }

            
            return dataArray
        }

}

