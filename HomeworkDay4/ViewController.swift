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
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //読み込み用インジケーター表示
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        
        //非表示設定
        activityIndicator.hidesWhenStopped = true
        
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
        DispatchQueue.main.async {
            cell.displaySetting(data: self.gitHubDataArray[indexPath.row])
        }
        
        return cell
    }
  
    //APIから取得する関数
    func getData() {
        //アニメーション開始
        activityIndicator.startAnimating()
        
        //URL定義
        guard let url = URL(string: "https://api.github.com/search/repositories?q=language%3Aswift&sort=stars")
            else {
            fatalError("url is nil")
        }
        var urlRequest = URLRequest(url: url)
        //タイムアウト時間定義
        urlRequest.timeoutInterval = 5
        //データ取得
        AF.request(urlRequest).validate().responseJSON {
            response in
            switch response.result {
            //成功
            case .success(let value) :
                self.onSuccess(value: value)
            //失敗
            case .failure(let error) :
                self.onError(error: error)
            }
            //終了
            self.onComplete()
        }
    }
    
    //取得成功時
    func onSuccess(value: Any) -> Void {
        let jsonData = JSON(value)
        let items = jsonData["items"]
        
        //データを解析し、配列に格納する
        self.gitHubDataArray = items.map { GitHubData(item: $0.1) }
        
        //テーブルデータ更新
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //取得失敗時
    func onError(error: Error) -> Void {
        print(error)
        //インジケーター停止
        self.activityIndicator.stopAnimating()
        //Alert表示
        let alert = UIAlertController.apiAlert(title: "Error", message: "The internet connection appeared to be offline.", preferredStyle: .alert, retryHandler: {
            (action: UIAlertAction) -> Void in
            self.getData()
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //終了時
    func onComplete() {
        self.activityIndicator.stopAnimating()
    }
}
