//
//  ViewController.swift
//  ToDoList
//
//  Created by Çağrı Dai on 30.05.2023.
//

import UIKit

final class ViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var items = [String]()
    private var searchData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "To Do List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addItem))
        
        if let savedItems = UserDefaults.standard.stringArray(forKey: "items") {
            items = savedItems
        }
        
        searchData = items
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchData[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            searchData = items
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
        }
    }
    
    @objc private func addItem() {
        let ac = UIAlertController(title: "To Do", message: "What do you want to add", preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "What do you want to do next"
        }
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            if let fieldText = ac.textFields?[0].text, fieldText.isNotEmpty {
                self?.items.insert(fieldText, at: 0)
                self?.searchData = self?.items ?? [""]
                self?.tableView.reloadData()
                self?.save()
            }
        }))
        present(ac, animated: true)
    }
    
    private func save() {
        UserDefaults.standard.set(items, forKey: "items")
    }
}

//MARK: - Search Bar Delegate

extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchData = items
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = searchText.isEmpty ? items : items.filter({ item in
            item.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
}
