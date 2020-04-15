//
//  ViewController.swift
//  Assignment9
//
//  Created by Nguyễn Lâm on 4/14/20.
//  Copyright © 2020 Nguyễn Lâm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let  serverConnection = ServerConnection()
    private var listImages: [ResponseData]?
    private var cacheImage: String!
    let fileManager = FileManagers()
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fileManager.createFileDirectory(folder: "Image")
        setUpTableCell()
        fetchListImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainTableView.reloadData()
    }
}

extension ViewController {
    private func fetchListImage(){
        serverConnection.fetchAPIFromURL("/pic_dic.json") { [weak self] (body, errorMessage) in
             
             guard let self = self else {
                 print("Self released")
                 return
             }
             
             if let errorMessage = errorMessage {
                 print(errorMessage)
                 // show error message
                 return
             }
                         
             if let body = body {
                 self.convertData(body)
             }
         }
    }
    
    private func convertData(_ data: String) {
        let responseData = Data(data.utf8)
        let decoder = JSONDecoder()
        

        var responseEntity: [ResponseData]?
        do {
            responseEntity = try decoder.decode([ResponseData].self, from: responseData)
                        
            listImages = responseEntity

            if let _ = listImages {
                // All methods update UI must be done in main thread
                DispatchQueue.main.async { [weak self] in
                    self?.mainTableView.reloadData()
                }
            }
        } catch let error {
            print("Failed to decode JSON \(error)")
        }
    }
}

extension ViewController {
    func setUpTableCell(){
        let customCell = UINib.init(nibName: "TableViewCell", bundle: nil)
        mainTableView.register(customCell, forCellReuseIdentifier: "customCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    private func pushToAvatarViewControllerWith(_ imageURL: String) {
        let urlImagePath = "https://vapor-mock.herokuapp.com\(imageURL)"
        let urlImage = urlImagePath.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: urlImage) else {
            print("Image url nil")
            return
        }
        performSegue(withIdentifier: "ListToImage", sender: url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageViewController = segue.destination as? ImageViewController {
            if let url = sender as? URL {
                imageViewController.imageURL = url
                imageViewController.imageName = cacheImage
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Data source
        return listImages?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        
        if let image = listImages?[indexPath.row] {
            
            cell.name.text = image.name
            cell.link.text = image.path
            cell.imageCell.image = nil
            let image = fileManager.loadImageFromDocumentWithName(image.name, "Image")
            if let _image = image {
                cell.imageCell.image = _image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = listImages?[indexPath.row] {
            cacheImage = user.name
            pushToAvatarViewControllerWith(user.path)
          }
    }
}
