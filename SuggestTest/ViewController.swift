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
    
    let tableView = UITableView(frame: .zero, style: .plain)
    let searchBar = UISearchBar()
    var suggest = [String]()
    var api = GoogleSuggestion()


    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        layout()
        // Do any additional setup after loading the view.
    }
    
    func layout() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchBar.delegate = self
        tableView.dataSource = self
        
        
        searchBar.snp.makeConstraints{
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints{
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(searchBar.snp.bottom)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
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
        Task {
            guard let suggestion = try? await api.getSuggestions(searchText: searchText) else { return }
            self.suggest = suggestion
            tableView.reloadData()
//            print(suggest)
        }
    }
    
}

class GoogleSuggestion {
    
    private let apiURL = "https://www.google.com/complete/search?hl=en&output=toolbar&q="
    
    func getSuggestions(searchText: String) async throws -> [String] {
        guard let percentEncoding = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: apiURL + percentEncoding) else {
            return []
        }
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
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
}
