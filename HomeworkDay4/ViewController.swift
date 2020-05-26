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
    //    var gitHubDataManager = GitHubDataManager()
    @IBOutlet weak var tableView: UITableView!
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //読み込み用インジケーター表示
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        
        //非表示設定
        activityIndicator.hidesWhenStopped = true
        
        //アニメーション開始
        activityIndicator.startAnimating()
        
        //viewに追加
        self.view.addSubview(activityIndicator)
        
        //テーブル設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GitHubCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        //高さ調整
        tableView.estimatedRowHeight = 195
        tableView.rowHeight = UITableView.automaticDimension
        
        //APIデータ取得
        getData()
        
    }
    
    //テーブルセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitHubDataArray.count
    }
    
    //テーブル内データ->GitHubCellを適用
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GitHubCell
        
        //表示内容を取得
        cell.displaySetting(data: gitHubDataArray[indexPath.row])
        
        return cell
    }
  
    //APIから取得する関数
    func getData() {
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
                //インジケーター停止
                self.activityIndicator.stopAnimating()
                //Alert表示
                let alert: UIAlertController = UIAlertController(title: "Error", message: "The internet connection appeared to be offline.", preferredStyle: UIAlertController.Style.alert)
                
                let retryAction: UIAlertAction = UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: {
                    (action: UIAlertAction) -> Void in
                    self.getData()
                })
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                    
                    (action: UIAlertAction) -> Void in
                })
                
                alert.addAction(retryAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            //テーブルデータ更新
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("Table Reloaded")
                //インジケーター停止
                self.activityIndicator.stopAnimating()
            }
        }
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

