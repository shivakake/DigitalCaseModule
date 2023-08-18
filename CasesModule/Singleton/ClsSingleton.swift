//
//  ClsSingleton.swift
//  OasisModules
//
//  Created by Pushpam on 05/02/22.
//

import Foundation
import NixelQueue

class ClsSingleton {
    
    private static var sharedInstance: ClsSingleton?
    
    class var shared: ClsSingleton {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = ClsSingleton()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    
    class func destroySingletonInstance() {
        sharedInstance = nil
    }
    
    let strPathUrl = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    let strAppName = "Dialogue"
    var strAppDirPath = ""
    var memberIdDirPath = ""
    var baseURL = "https://apin.dialogue247.com" //"https://apio.oasisapi.net"
    
    public func createDirs(memberID: String) {
        
        strAppDirPath = strAppName
        memberIdDirPath = strAppDirPath + "/" + memberID
        
        let strAppDirPathFull =
            strPathUrl.appendingPathComponent(strAppDirPath)
        
        if(!fileCheckAtPath(strFilePath: strAppDirPathFull)) {
            // create the directory
            createFolder(strDirPath: strAppDirPathFull)
        }
        
        let strMemberDirPathFull =
            strPathUrl.appendingPathComponent(memberIdDirPath)
        
        if(!fileCheckAtPath(strFilePath: strMemberDirPathFull)){
            // if 'QueueUpload' directory does not exist
            // create the directory
            createFolder(strDirPath: strMemberDirPathFull)
        }
    }
    
    public func fileCheckAtPath(strFilePath:String) -> Bool {
        return FileManager.default.fileExists(atPath: strFilePath)
    }
    
    public func createFolder(strDirPath: String) {
        do {
            // create directory at given path
            try FileManager.default.createDirectory(atPath: strDirPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK:- Make HomeViewControlle and call this func there and navigate to appointment page.
    /*
     func setUpValuesForNixelQueueLibrary() {
     let session = "kwhxafrcvjftolopfnqfmummwdqmrrbchqahckhcumzfigcj"
     let session = UserDefaults.standard.string(forKey: "SessionId") ?? ""
     let memberId = "hqwvdhemkkhtgyw"
     let memberId = UserDefaults.standard.string(forKey: "memberId") ?? ""
     ClsQueueManager.shared.setInternetValue(value: 1)
     ClsSingleton.shared.createDirs(memberID: memberId)
     ClsQueueManager.shared.initializeQueueLogic(strPathUrl: ClsSingleton.shared.strPathUrl, strMemberIdDirPath: ClsSingleton.shared.memberIdDirPath, strBaseUrl: ClsSingleton.shared.baseURL, strSessionId: session)
     }
     */
}
