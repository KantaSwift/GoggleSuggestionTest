//
//  ViewController.swift
//  SuggestTest
//
//  Created by 上條栞汰 on 2022/07/23.
//

import UIKit
import Kanna
import SnapKit


class ViewController: UIViewController {
    
    let api = GoogleSuggestion(searchText: "Swift")
    let tableView = UITableView()
    let searchBar = UISearchBar()
    var suggest = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            guard let suggestion = try? await api?.getSuggestion() else { return }
            self.suggest = suggestion
            tableView.reloadData()
//            print(suggest)
        }
       
        layout()
        // Do any additional setup after loading the view.
    }
    
    func layout() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchBar.delegate = self
        tableView.delegate = self
        
        
        searchBar.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(tableView.snp.top)
        }
        
        tableView.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggest.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = suggest[indexPath.row]
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//      print("変更されました")
       
    }
    
}

class GoogleSuggestion {
    private var apiURL = "https://www.google.com/complete/search?hl=en&output=toolbar&q="
    
    let url: URL
    
    init?(searchText: String) {
        guard let percentEncoding = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: apiURL + percentEncoding) else { return nil}
        self.url = url
    }
    
    func getSuggestion() async throws -> [String] {
           return try await withCheckedThrowingContinuation { continuation in
               do {
                   let doc = try XML(url: url, encoding: .utf8)
                   let suggestions = doc.xpath("//suggestion").compactMap { $0["data"] }
                   continuation.resume(returning: suggestions)
               }
               catch {
                   continuation.resume(throwing: error)
               }
           }
       }
}
