//
//  FileManager.swift
//  dataholder
//
//  Created by Nguyễn Lâm on 4/10/20.
//  Copyright © 2020 Nguyễn Lâm. All rights reserved.
//

import Foundation
import UIKit

protocol LocalFileManagerProtocol {
    func saveFileToDocuments(_ image: UIImage, _ imageName: String,_ folder: String?) -> Bool
    func loadImageFromDocumentWithName(_ name: String,_ folder: String?) -> UIImage?
    //Delete Image
//    func deleteImageWithName(_ name: String) -> Bool
}
class FileManagers {
    
    func createFileDirectory(folder:String) {
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])

    //set the name of the new folder
        let folderPath = documentsPath.appendingPathComponent(folder)
        do
        {
            try FileManager.default.createDirectory(atPath: folderPath!.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }
    
    private func getDocumentDirectory(folder:String?) -> URL? {
        // Using FileManager to create custom folder
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            if let folderName = folder {
                let folderPath = path.appendingPathComponent(folderName)
                return folderPath
            } else{
                return path
            }
        } else {
            return nil
        }
    }
}

extension FileManagers: LocalFileManagerProtocol {
    func saveFileToDocuments(_ image: UIImage, _ imageName: String,_ folder: String?) -> Bool {
        guard let url = getDocumentDirectory(folder: folder)?.appendingPathComponent(imageName) else {
            print("Get document folder error")
            return false
        }
        
        do {
            if let data = image.pngData() {
                try data.write(to: url)
                return true
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
        
        return false
    }
    
    func loadImageFromDocumentWithName(_ name: String,_ folder: String?) -> UIImage? {
        guard let url = getDocumentDirectory(folder: folder)?.appendingPathComponent(name) else {
            print("Get document folder error")
            return nil
        }
        let image = UIImage(contentsOfFile: url.path)
        return image
    }
    
//    func deleteImageWithName(_ name: String) -> Bool {
//        guard let url = getDocumentDirectory()?.appendingPathComponent(name) else {
//            print("Get document folder error")
//            return false
//        }
//
//        do {
//            try FileManager.default.removeItem(atPath: url.path)
//            return true
//        } catch (let error) {
//            print(error)
//        }
//
//        return false
//    }
}
