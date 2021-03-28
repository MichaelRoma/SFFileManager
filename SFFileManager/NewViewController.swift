//
//  NewViewController.swift
//  SFFileManager
//
//  Created by Mykhailo Romanovskyi on 23.03.2021.
//

import UIKit

class NewViewController: UIViewController {

    @IBOutlet weak var myLable: UILabel!
    
    let fileManager = FileManager()
    let tempDir = NSTemporaryDirectory()
    let docDir = NSHomeDirectory() + "/Documents/"
    let fileName = "customFile.txt"
    var folderPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func createFileAction(_ sender: UIButton) {
        let filePath = (tempDir as NSString).appending(fileName)
        let fileContent = "Some text here"
        
        do {
            try fileContent.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
            print("File Created")
            myLable.text = "File created at \(filePath)"
            print(filePath)
        } catch let error as NSError {
            print("Cant create a file, because \(error.localizedDescription)")
        }
    }
    
    @IBAction func checkTmp(_ sender: UIButton) {
        let filesCatalog = validatorCatalog() ?? "Nothing"
        myLable.text = filesCatalog
    }
    
    @IBAction func createADir(_ sender: UIButton) {
        let docsFolderPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logPath = docsFolderPath.appendingPathComponent("CustomFolder")
        guard let unwrLogPath = logPath else { return }
        do {
            try FileManager.default.createDirectory(atPath: unwrLogPath.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
            myLable.text = "\(unwrLogPath)"
        } catch let error as NSError {
            print("Cant create a dir, \(error.localizedDescription)")
        }
    }
    
    @IBAction func folderExistCheck(_ sender: UIButton) {
        let directories: [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        if directories.count > 0 {
            let directory = directories[0]
            folderPath = directory.appendingFormat("/" + fileName)
            print("Local path = \(folderPath)")
        } else {
            print("Could not find local directory for this folder")
        }
        
        if fileManager.fileExists(atPath: folderPath) {
            myLable.text = "Folder exist - \(folderPath)"
        } else {
            myLable.text = "Folder does not exist"
        }
    }
    
    @IBAction func readFileButtonAction(_ sender: UIButton) {
            let directoryWithFiles = validatorCatalog() ?? "Empry"
        let path = (docDir as NSString).appendingPathComponent(directoryWithFiles)
        do {
            let contentofFile = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)

            myLable.text = "\(fileName) content: \(contentofFile)"
        } catch let error as NSError {
            myLable.text = "Erorr hapend: - \(error)"
        }
        
    }
    
    @IBAction func writeToFileAction(_ sender: UIButton) {
        let someText = "Hello file"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                try someText.write(to: fileURL, atomically: false, encoding: .utf8)
                myLable.text = "\(someText) added to file: \(fileName)"
            } catch {
                myLable.text = "Unable to write"
            }
        }
    }
    
    func validatorCatalog() ->String? {
        do {
            let objectInCatalog = try fileManager.contentsOfDirectory(atPath: docDir)
            let object = objectInCatalog
            if object.count > 0 {
                if object.first == fileName {
                    print("file foundet")
                    return object.first
                } else {
                    print("There is no file you are interested in")
                    return nil
                }
            }
        } catch let errror as NSError {
            myLable.text = errror.localizedDescription
            return nil
        }
        return nil
    }
}
