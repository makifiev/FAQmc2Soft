//
//  Networking.swift
//  FAQmc2Soft
//
//  Created by Акифьев Максим  on 10.02.2022.
//

import Foundation
import UIKit

class Networking
{
    static let sharedInstance = Networking()
    private init () {}
    
    var jsonResponse = String()
    
    func loadData(success: @escaping (DataModel) -> Void, failure: @escaping (String) -> Void)
    {
        let url: URL = URL(string: "https://www.mc2soft.ru/z04Qm4w-wp-content-34fGhe/themes/bwstheme/faqjson")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { 
                failure(error!.localizedDescription)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let report = DataModel()  
                report.items = json as? [[String:Any]] ?? [[:]]
                success(report)
                
            } catch {
                failure(error.localizedDescription)
            }
             
        }
        task.resume()
        
    }
}
 
