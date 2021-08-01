//
//  ViewController.swift
//  NetworkDispatcherDemo
//
//  Created by lidor tamir on 01/08/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image_view: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let request = HTTPRequest(path: "https://www.iucn.org/sites/dev/files/styles/850x500_no_menu_article/public/content/images/2020/img_8130_edited.jpg?itok=TGXapELm", headers: nil, body: nil, method: .get)
//        let request = HTTPRequest(path: "https://restcountries.eu/rest/v2/name/israel", headers: nil, body: nil, method: .get)
        
        let _ = try? NetworkDispatcher.share.response(request) {[weak self] object, response in
            if let data = response.data , let image = UIImage(data: data) {
                self?.image_view.image = image
            }
        }
    }


}

