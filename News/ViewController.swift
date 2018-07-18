//
//  ViewController.swift
//  News
//
//  Created by MacUser on 16.07.2018.
//  Copyright © 2018 MacUser. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireImage

class ShortArticleCell: UITableViewCell
{
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var dataLabel:     UILabel!
    @IBOutlet weak var iamgeView: UIImageView!
}

class ViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var connectionLbl: UILabel!
    
    var articles   = [Article]()
    let imageCache = AutoPurgingImageCache()
    
    lazy var refreshControl: UIRefreshControl =
    {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(getRequest), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        if #available(iOS 10.0, *)
        {
            tableView.refreshControl = refreshControl
        } else
        {
            tableView.addSubview(refreshControl)
        }
        
        getRequest()
    }
    
    @objc func getRequest()
    {
        if NetworkReachabilityManager()!.isReachable
        {
            let url = "http://176.112.213.150"
            
            Alamofire.request("\(url)/api_v1/news/").responseJSON { response in
                
                guard response.result.isSuccess else
                {
                    print("Request error \(String(describing: response.result.error))")
                    return
                }
                
                guard let articlesArr = response.result.value as? NSDictionary else
                {
                    print("Failed to create a dictionary")
                    return
                }
                
                let articlesDict = articlesArr["data"] as! [[String:AnyObject]]
                
                // TODO: check for updates (yes - continue otherwise skip)
                for article in articlesDict
                {
                    let item = Article(context: AppDelegate.context)
                    
                    item.id    = article["id"]         as! Int32
                    item.title = article["title"]      as? String
                    item.date  = article["updated_at"] as? String
                    item.body  = article["body"]       as? String
                    item.image = url + (article["image"] as! String)
                }
                
                AppDelegate.saveContext()
            }
        }
        else
        {
            showAlert()
        }
        
        fetchData()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func fetchData()
    {
        do
        {
            let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
            let articles  = try AppDelegate.context.fetch(fetchRequest)
            
            self.articles = articles
            self.tableView.reloadData()
        }
        catch { }
    }
    
    func showAlert()
    {
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            self.connectionLbl.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 1, options: [.curveEaseOut], animations: {
            self.connectionLbl.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let articleVC     = segue.destination as! ViewArticle
        let indexPath     = sender as! IndexPath
        articleVC.article = articles[indexPath.row]
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ShortArticleCell
        
        cell.iamgeView.af_setImage(withURL: URL(string: articles[indexPath.row].image!)!, placeholderImage: #imageLiteral(resourceName: "missing.png"))
        cell.headlineLabel.text = articles[indexPath.row].title
        cell.dataLabel.text     = articles[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "viewArticle", sender: indexPath)
    }
}
