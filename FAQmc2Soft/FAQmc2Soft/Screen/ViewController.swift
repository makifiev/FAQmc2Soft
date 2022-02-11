//
//  ViewController.swift
//  FAQmc2Soft
//
//  Created by Акифьев Максим  on 09.02.2022.
//

import UIKit

class ViewController: UIViewController, ActivityIndicatorPresenter {
    
    var activityIndicator: UIActivityIndicatorView!
    
    var mTable: UITableView!
    let mTableCellID = "mTableCellID"
    var items: AnyObject?
    var selectedIndexPathes: [IndexPath] = []
    var contentOffset: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func setView()
    {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.edgesForExtendedLayout = []
        setTable()
        activityIndicator = UIActivityIndicatorView()
    }
    
    func setTable()
    {
        mTable = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 44), style: .grouped)
        mTable.register(MTableViewCell.self, forCellReuseIdentifier: mTableCellID)
        mTable.estimatedRowHeight = 140
        mTable.rowHeight = UITableView.automaticDimension
        mTable.backgroundColor = .lightGray
        mTable.bounces = false
        mTable.allowsSelection = true
//        mTable.separatorInset = .
        mTable.dataSource = self
        mTable.delegate = self
//
//        mTable.estimatedRowHeight = 0

        mTable.estimatedSectionHeaderHeight = 0

        mTable.estimatedSectionFooterHeight = 0
        
        self.view.addSubview(mTable)
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

extension ViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items == nil
        {
            return 0
        }
        return ((items as! [AnyObject])[section]["items"] as! [AnyObject]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if items == nil
        {
            return UITableViewCell()
        }
        
        var cell: MTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "mTableCellID") as? MTableViewCell
        
        if (cell == nil)
        {
            cell = MTableViewCell.init(style: .default,
                                       reuseIdentifier:"mTableCellID")
        }
        if selectedIndexPathes.contains(indexPath)
        {
            
            cell?.answerLabel.isHidden = false
            cell?.chevron.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi/2))
        }
        else
        {
            cell?.answerLabel.isHidden = true
            cell?.chevron.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        }
        cell?.configureCell(questionText: ((items as! [AnyObject])[indexPath.section]["items"] as! [AnyObject])[indexPath.row]["question"] as! String,
                            answerText: ((items as! [AnyObject])[indexPath.section]["items"] as! [AnyObject])[indexPath.row]["answer"] as! String)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndexPathes.contains(indexPath)
        {
            if let index = selectedIndexPathes.firstIndex(of: indexPath)
            {
                selectedIndexPathes.remove(at: index)
            }
        }
        else
        {
            selectedIndexPathes.append(indexPath)
        }
        tableView.performBatchUpdates {
            UIView.animate(withDuration: 0.3) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }  

        
//        print(selectedIndexPathes)
               
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if items == nil
        {
            return 0
        }
        return (items as! [AnyObject]).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if items == nil
        {
            return ""
        }
        return (items as! [AnyObject])[section]["name"] as? String
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          
            return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 140
//        }
    
}


