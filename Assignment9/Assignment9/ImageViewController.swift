//
//  ImageViewController.swift
//  Assignment9
//
//  Created by Nguyễn Lâm on 4/14/20.
//  Copyright © 2020 Nguyễn Lâm. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    private let serverConnection = ServerConnection()
    let fileManager = FileManagers()
    @IBOutlet weak var imageView: UIImageView!
    public var imageURL: URL!
    public var imageName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImage()
    }

    private func displayImage(_ image: UIImage) {
        imageView.image = image
    }
    
}

extension ImageViewController {
   private func setUpImage(){
        let image = fileManager.loadImageFromDocumentWithName(imageName, "Image")
        if let _image = image {
            imageView.image = _image
        } else {
            serverConnection.downloadImageFromURL(imageURL) { [weak self] (image, error) in
                guard let self = self else { return }
                
                if let image_ = image {
                    DispatchQueue.main.async {
                        self.displayImage(image_)
                        if let name = self.imageName {
                            let _ = self.fileManager.saveFileToDocuments(image_, "\(name)", "Image")
                        }
                    }
                } else if let err = error {
                    print(err)
                }
            }
        }
    }
}
