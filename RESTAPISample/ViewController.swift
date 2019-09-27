//
//  ViewController.swift
//  RESTAPISample
//
//  Created by Tatsuya Moriguchi on 9/27/19.
//  Copyright © 2019 Becko's Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    
    
    @IBAction func fetchPressedOn(_ sender: UIButton) {
        var userName: String?
        var userEmail: String?
        var userPhone: String?
        
        let urlString = "http://api.randomuser.me"
        // Make a request
        let request: URLRequest = URLRequest(url: URL(string: urlString)!)
        // Get JSON data from URL string
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                print(json)
                if let resultsArray = json.object(forKey: "results") as? NSArray {
                    // Get dictionary data
                    let resultDictionary: NSDictionary = resultsArray[0] as! NSDictionary
                    
                    if let name: NSDictionary = resultDictionary["name"] as? NSDictionary {
                        if let first = name["first"], let last = name["last"], let title = name["title"] {
                            print("Name: \(title) \(first) \(last)")
                            userName = "Name: \(title) \(first) \(last)"
                        }
                    }
                    
                    // Get a value from the dictionary
                    if let email = resultDictionary["email"] {
                        print("email is \(email)")
                        userEmail = "Email: \(email)" // as? String
                    }
                    if let phone = resultDictionary["phone"] {
                        print("phone is \(phone)")
                        userPhone = "Phone: \(phone)" // as? String
                    }
                    
                    if let picture: NSDictionary = resultDictionary["picture"] as? NSDictionary {
                        if let pic = picture["large"] {
                            self.imageURL = pic as? String
                            print("imageURL: \(self.imageURL)")
                        }
                    }
                }
                DispatchQueue.main.async {
                self.nameLabel.text = "\(userName ?? "No user name available")\n\(userEmail ?? "No email available")\n\(userPhone ?? "no phone availabel")"
                    self.showImage()
                }
                
                
                
            } catch {
                print("Error")
            }
            }.resume()
        
        //showImage()
        
    }
    
    @IBOutlet var nameLabel: UILabel!
    var imageURL: String?
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
    }
    
    func showImage() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: imageURL!) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Something went wrong: \(error)")
            }
            
            if let imageData = data {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
            }
        }.resume()
    }


}

