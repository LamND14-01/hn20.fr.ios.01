//
//  ViewController.swift
//  handleError
//
//  Created by Nguyễn Lâm on 4/14/20.
//  Copyright © 2020 Nguyễn Lâm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let serverConnection = ServerConnection()
    private var data: ResponseData!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func fetch(_ sender: Any) {
        fetchListUser()
    }
    
}

extension ViewController {
    private func fetchListUser() {
        if let url = textField.text {
            serverConnection.fetchAPIFromURL(url) { [weak self] (body, errorMessage) in
                       guard let self = self else {
                           print("Self released")
                           return
                       }

                       if let errorMessage = errorMessage {
                        self.setAlert(alert: errorMessage)
                           return
                       }

                       if let body = body {
                        self.setAlert(alert: "Success")
                           print("\(body)")
                        self.convertData(body)
                       }
                       
            }
        }
    }
    
    private func convertData(_ data: String) {
        let responseData = Data(data.utf8)
        let decoder = JSONDecoder()

        var responseEntity: ResponseData?

        do {
            responseEntity = try decoder.decode(ResponseData.self, from: responseData)
                        
            self.data = responseEntity
            if let data = self.data {
                print("\(data)")
            }
        } catch let error {
            print("Failed to decode JSON \(error)")
        }
    }
    
    private func setAlert(alert:String){
        DispatchQueue.main.async{
        let alert = UIAlertController(title: nil, message: alert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
    }
}
