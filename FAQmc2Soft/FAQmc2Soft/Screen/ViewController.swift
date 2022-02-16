//
//  ViewController.swift
//  FAQmc2Soft
//
//  Created by Акифьев Максим  on 09.02.2022.
//

import UIKit

class ViewController: UIViewController, ActivityIndicatorPresenter {
    
    var activityIndicator: UIActivityIndicatorView!
     
    var mTable: UITableView =
    {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var warnLabel: UILabel =
    {
        let label = UILabel(frame: .zero)
        label.text = "Увы, ничего не найдено"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var mPanel = UIView()
    lazy var mSearchBar = UISearchBar(frame: .zero)
    let mTableCellID = "CustomTableViewCell"
    var expandCell: Bool = false
    var items: [[String:Any]]?
    var filterItems: [[String:Any]]?
    var selectedIndexPath: IndexPath?
    var selectedIndexPathes: [IndexPath] = []
    
    var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setTable()
        setWarnLabel()
        loadData()
    }
    
    func setWarnLabel()
    {
        view.addSubview(warnLabel)
        view.bringSubviewToFront(warnLabel)
        warnLabel.isHidden = true
        warnLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 10).isActive = true
        warnLabel.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 15).isActive = true
        warnLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -10).isActive = true
        warnLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setView()
    {
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = []
        activityIndicator = UIActivityIndicatorView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setTable()
    {
        mTable.register(CustomTableViewCell.self, forCellReuseIdentifier: mTableCellID)
        mTable.rowHeight = UITableView.automaticDimension
        mTable.estimatedRowHeight = 300
        mTable.backgroundColor = .white 
        mTable.allowsSelection = true
        mTable.dataSource = self
        mTable.delegate = self
        mTable.estimatedSectionHeaderHeight = 0
        mTable.estimatedSectionFooterHeight = 0 
        self.view.addSubview(mTable)
        mTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 0).isActive = true
        mTable.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 0).isActive = true
        mTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 0).isActive = true
        mTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: 0).isActive = true
        
    }
    
    func showSearchBar()
    {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.keyboardType = .emailAddress
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
  
    func loadData()
    {
        self.showActivityIndicator()
        Networking.sharedInstance.loadData
        { (report) in
            self.hideActivityIndicator()
            self.items = report.items 
            DispatchQueue.main.async {
                self.mTable.reloadData()
                
            }
            
            
        } failure: {(reason) in
            self.hideActivityIndicator()
            DispatchQueue.main.async {
                self.showError(reason: reason)
            }
            
        }
        
    }
    
    func showError(reason: String)
    {
        let alert = UIAlertController(title: "Ошибка", message: reason, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler:
                                        {_ in
            self.loadData()
        }))
        
        self.present(alert, animated: true)
    } 
}

extension ViewController : UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        var filteredItemsLoc: [[String: Any]] = [[:]]
         
        
        for item in items!
        {
            let name = item["name"] as! String
            let items = item["items"] as! [[String:String]]
           
            let test = items.filter{((($0["question"]! as String).lowercased()).contains(text.lowercased()))}
            if test.count != 0
            {
                let dict = ["name": name, "items": test] as [String : Any]
                filteredItemsLoc.append(dict)
            }
              
        }
        filteredItemsLoc.removeFirst()
        filterItems = filteredItemsLoc
        warnLabel.isHidden = true
        if filterItems!.isEmpty && text != ""
        {
            warnLabel.isHidden = false
        }
        
        selectedIndexPathes.removeAll()
        mTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
            self.navigationItem.searchController = nil
        mTable.reloadData()
    }
}
extension ViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items == nil
        {
            return 0
        }
        if !searchController.isActive || searchController.searchBar.text == "" {
        return (items?[section]["items"] as! [AnyObject]).count
        }
        else
        {
        return (filterItems?[section]["items"] as! [AnyObject]).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "CustomTableViewCell") as? CustomTableViewCell
        else { return UITableViewCell() }
        if !searchController.isActive || searchController.searchBar.text == "" {
            
        cell.setUI(text1: (items?[indexPath.section]["items"] as! [AnyObject])[indexPath.row]["question"] as! String,
                   text2: (items?[indexPath.section]["items"] as! [AnyObject])[indexPath.row]["answer"] as! String)
        }
        else
        {
        cell.setUI(text1: (filterItems?[indexPath.section]["items"] as! [AnyObject])[indexPath.row]["question"] as! String,
                       text2: (filterItems?[indexPath.section]["items"] as! [AnyObject])[indexPath.row]["answer"] as! String)
        }
        
        if selectedIndexPathes.contains(indexPath)
                {
                    cell.showDetailView()
                }
                else
                {
                    cell.hideDetailView()
                }
        
        return cell
    }
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        if let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
            if cell.isDetailViewHidden {
               
            } else {
               
            }
        if selectedIndexPathes.contains(indexPath)
                {
                    if let index = selectedIndexPathes.firstIndex(of: indexPath)
                    {
                        selectedIndexPathes.remove(at: index)
                        cell.hideDetailView()
                    }
                }
                else
                {
                    selectedIndexPathes.append(indexPath)
                    cell.showDetailView()
                }
        }
        UIView.animate(withDuration: 0.3) {
            tableView.performBatchUpdates(nil)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if items == nil
        {
            return 0
        }
        if !searchController.isActive || searchController.searchBar.text == ""
        {
        return items!.count
        }
        else
        {
        return filterItems!.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if items == nil
        {
            return ""
        }
        if !searchController.isActive || searchController.searchBar.text == "" {
        return items?[section]["name"] as? String
        }
        else
        {
        return filterItems?[section]["name"] as? String
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 66))
        headerView.backgroundColor = UIColor.lightGray
        if items == nil
        {
            return headerView
        }
        
        let label = UILabel()
        label.frame = .zero
        label.text = items?[section]["name"] as? String
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textColor = .white
        label.frame.origin.x = 15
        label.sizeToFit()
        label.center.y = headerView.center.y
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 66
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
  
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        if navigationItem.searchController == nil
        {
            UIView.animate(withDuration: 0.3) {
                self.showSearchBar()
            }
        
        }
    }
}

extension ViewController
{
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            mTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        mTable.contentInset = .zero
    }
}


