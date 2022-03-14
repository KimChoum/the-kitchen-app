//
//  LocalFileManager.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/13/22.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() { }
    
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        createFolderIfNeeded(folderName: folderName)
        
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
            else { return }
        do{
            try data.write(to: url)
        }catch let error{
            print("Error saving image \(error)")
        }
        
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage?{
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else{
                print("RETURNING NIL")
                return nil
            }
        print("Returning image")
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String){
        guard let url = getURLForFolder(folderName: folderName)
        else{
            return
        }
        if !FileManager.default.fileExists(atPath: url.path){
            do{
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }catch let error{
                print("failed to create folder. Folder name \(folderName). error: \(error)")
            }
        }
    }
    
    private func getURLForFolder(folderName:  String) -> URL?{
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else{
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let url = getURLForFolder(folderName: folderName)
        else{
            print("return nil")
            return nil
        }
        return url.appendingPathComponent(imageName + ".png")
    }
}
