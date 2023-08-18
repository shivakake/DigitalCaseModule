//
//  CaseLogic.swift
//  CasesModule
//
//  Created by PGK Shiva Kumar on 29/11/22.
//

import Foundation
import NixelQueue

enum CaseServiceAPIName : String {
    
    case casesListAPI = "cases"
    case caseDetailsAPI = "case"
    case newCaseAPI = "newcase"
    case editCaseAPI = "editcase"
    case approveCaseAPI = "approvecase"
    case draftCaseAPI = "draftcase"
    case completeCaseAPI = "completecase"
    case deleteCaseAPI = "deletecase"
    case cancelCaseAPI = "cancelcase"
    case newCaseMemberAPI = "newcasemember"
    case deleteCaseMemberAPI = "deletecasemember"
    case messagePeopleGroupsAPI = "messagepeoplegroups"
}

protocol CaseLogicDelegate : AnyObject {
    
    func getCasesList()
    func getCaseDetails()
    func updateCaseStatusChange(dataStatus: String, index: Int)
    func caseStatusChangeForQueue(index: Int)
    func addNewCaseInQueue()
    func updateAddCaseSuccess(status: Int, index: Int)
    func editCaseInQueue(index: Int)
    func updateEditCaseSuccess(dataStatus: String, index: Int)
    func updateDeleteCaseSuccess(status: Int, index: Int)
    func getMessagePeopleGroupList(model: MessagePeopleGroupsDataModel?)
    func updateAddMemberAndGroupScuess()
    func updateDeleteMemberAndGroup()
    func showPoorInternet()
}

public class CaseLogic {
    
    public init() { }
    
    weak var delegate: CaseLogicDelegate? {
        didSet {
            ClsQueueManager.shared.setQueueManagerDelegate(to: self)
            ClsQueueManager.shared.setInternetValue(value: 1)
        }
    }
    
    public var casesData: [CaseDataModel] = []
    public var caseDetailsModel : CaseDataModel?
    public var arrMembersData: [MembersMessageDataModel] = []
    public var arrGroupsData: [GroupMessageListDataModel] = []
    public var arrConversationData: [MembersMessageDataModel] = []
    var statusFilter = "live"
    var searchText = ""
    
    //MARK:- Notes List
    public func getCaseList(communityId: String?, text: String?, status: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        self.statusFilter = status ?? "live"
        self.searchText = text ?? ""
        
        let objectHashMapData = [
            "ref" : communityId ?? "",
            "text" : self.searchText,
            "status" : self.statusFilter
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "case", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: CaseServiceAPIName.casesListAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    //MARK:- Notes Details
    public func getCaseDetails(caseId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : caseId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: caseId ?? "", strObjType: "case", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: CaseServiceAPIName.caseDetailsAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func addNewCase(communityId: String?, name: String?, description: String?, scheduled: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "verify" : strId,
            "name" : name ?? "",
            "description" : description ?? "",
            "ref" : communityId ?? "",
            "scheduled" : scheduled ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "case", strVerifyId: strId, strStatus: "queue", strOperation: "addNewCase", strApiName: CaseServiceAPIName.newCaseAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        casesData.insert(CaseDataModel(datastatus: "queue", description: description, id: strId, name: name), at: 0)
        delegate?.addNewCaseInQueue()
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func editCaseDetails(model: CaseDataModel?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "verify" : strId,
            "name" : model?.name ?? "",
            "description" : model?.description ?? "",
            "scheduled" : model?.scheduled ?? "",
            "ref" : model?.id ?? "",
            
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: model?.id ?? "" , strObjType: "case", strVerifyId: strId, strStatus: "queue", strOperation: "editCase", strApiName: CaseServiceAPIName.editCaseAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = casesData.firstIndex(where: { $0.id == model?.id }) {
            caseDetailsModel = model
            delegate?.editCaseInQueue(index: firstIndex)
        }
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    //MARK:- Draft Notes
    public func draftCase(communityId: String?, caseId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "verify" : strId,
            "ref" : communityId ?? "",
            "item" : caseId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: caseId ?? "", strObjType: "case", strVerifyId: strId, strStatus: "queue", strOperation: "draftCase", strApiName: CaseServiceAPIName.draftCaseAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = casesData.firstIndex(where: {$0.id == caseId}) {
            casesData[firstIndex].datastatus = "queue"
            caseDetailsModel?.datastatus = "queue"
            delegate?.caseStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func completeCase(communityId: String?, caseId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "verify" : strId,
            "ref" : communityId ?? "",
            "item" : caseId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: caseId ?? "", strObjType: "case", strVerifyId: strId, strStatus: "queue", strOperation: "completeCase", strApiName: CaseServiceAPIName.completeCaseAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = casesData.firstIndex(where: {$0.id == caseId}) {
            casesData[firstIndex].datastatus = "queue"
            caseDetailsModel?.datastatus = "queue"
            delegate?.caseStatusChangeForQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func approveCase(communityId: String?, caseId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "verify" : strId,
            "ref" : communityId ?? "",
            "item" : caseId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: caseId ?? "", strObjType: "case", strVerifyId: strId, strStatus: "queue", strOperation: "approveCase", strApiName: CaseServiceAPIName.approveCaseAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = casesData.firstIndex(where: {$0.id == caseId}) {
            casesData[firstIndex].datastatus = "queue"
            caseDetailsModel?.datastatus = "queue"
            delegate?.caseStatusChangeForQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func deleteCase(communityId: String?, caseId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "verify" : strId,
            "ref" : communityId ?? "",
            "item" : caseId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: caseId ?? "", strObjType: "case", strVerifyId: strId, strStatus: "queue", strOperation: "deleteCase", strApiName: CaseServiceAPIName.deleteCaseAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = casesData.firstIndex(where: {$0.id == caseId}) {
            casesData[firstIndex].datastatus = "queue"
            caseDetailsModel?.datastatus = "queue"
            delegate?.caseStatusChangeForQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func cancelCase(communityId: String?, caseId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "verify" : strId,
            "ref" : communityId ?? "",
            "item" : caseId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: caseId ?? "", strObjType: "case", strVerifyId: strId, strStatus: "queue", strOperation: "cancelCase", strApiName: CaseServiceAPIName.cancelCaseAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = casesData.firstIndex(where: {$0.id == caseId}) {
            casesData[firstIndex].datastatus = "queue"
            caseDetailsModel?.datastatus = "queue"
            delegate?.caseStatusChangeForQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func addNewCaseMemberAndGroup(caseId: String?, personId: String?, groupId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : caseId ?? "",
            "person" : personId ?? "",
            "group" : groupId ?? ""
            
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "case", strVerifyId: strId, strStatus: "queue", strOperation: "addNewCaseMember", strApiName: CaseServiceAPIName.newCaseMemberAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func getMessagePeopleGroupList(communityId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : communityId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "case", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: CaseServiceAPIName.messagePeopleGroupsAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func deleteCaseMemberAndGroup(caseId: String?, personId: String?, groupId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : caseId ?? "",
            "person" : personId ?? "",
            "group" : groupId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: caseId ?? "", strObjType: "case", strVerifyId: strId, strStatus: "queue", strOperation: "deleteCaseMember", strApiName: CaseServiceAPIName.deleteCaseMemberAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
}

extension CaseLogic : QueueManagerDelegate {
    
    public func onOperationResult(objResponseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue, blIsVerify: Bool) {
        
        switch objHeaderQueue.strApiName {
        
        case CaseServiceAPIName.casesListAPI.rawValue:
            handleResponseForCasesList(responseDict: objResponseDict)
            
        case CaseServiceAPIName.caseDetailsAPI.rawValue:
            handleResponseForCaseDetails(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case CaseServiceAPIName.approveCaseAPI.rawValue , CaseServiceAPIName.draftCaseAPI.rawValue , CaseServiceAPIName.completeCaseAPI.rawValue ,
             CaseServiceAPIName.cancelCaseAPI.rawValue:
            handleResponseForChangingCaseStatus(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case CaseServiceAPIName.newCaseAPI.rawValue:
            handleResponseForNewCase(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case CaseServiceAPIName.editCaseAPI.rawValue:
            handleResponseForEditCase(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case CaseServiceAPIName.deleteCaseAPI.rawValue:
            handleResponseForDeleteCase(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case CaseServiceAPIName.newCaseMemberAPI.rawValue :
            handleResponseForAddNewCaseMemberAndGroup(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case CaseServiceAPIName.messagePeopleGroupsAPI.rawValue :
            handleResponseForMessagePeopleGroupList(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case CaseServiceAPIName.deleteCaseMemberAPI.rawValue :
            handleResponseForDeleteCaseMemberAndGroup(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
        default:
            break
        }
    }
    
    //MARK:- API Response
    
    func handleResponseForCasesList(responseDict: NSDictionary) {
        casesData.removeAll()
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                let caseList = responseDict["list"] as? NSArray
                for caseObj in caseList ?? [] {
                    let list = caseObj as? NSDictionary
                    let datastatus = list?["datastatus"] as? String
                    let description = list?["description"] as? String
                    let id = list?["id"] as? String
                    let name = list?["name"] as? String
                    
                    casesData.append(CaseDataModel(datastatus: datastatus, description: description, id: id, name: name))
                }
                delegate?.getCasesList()
            } else {
                delegate?.getCasesList()
            }
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForCaseDetails(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        
        if responseDict.count > 0 {
            var arrMembersData: [MembersMessageDataModel] = []
            var arrGroupsData: [GroupMessageListDataModel] = []
            
            if responseDict["status"] as? Int == 1 {
                let casestatus = responseDict["casestatus"] as? String
                let created = responseDict["created"] as? String
                let datastatus = responseDict["datastatus"] as? String
                let description = responseDict["description"] as? String
                let messages = responseDict["messages"] as? String
                let name = responseDict["name"] as? String
                let scheduled = responseDict["scheduled"] as? String
                let status = responseDict["status"] as? Int
                let updated = responseDict["updated"] as? String
                let members:[[String:Any]] = responseDict["members"] as? [[String:Any]] ?? []
                let groups:[[String:Any]] = responseDict["groups"] as? [[String:Any]] ?? []
                
                for member in members {
                    let id = member["id"] as? String
                    let name = member["name"] as? String
                    let objMembersData = MembersMessageDataModel(id: id, name: name)
                    arrMembersData.append(objMembersData)
                }
                
                for group in groups {
                    let id = group["id"] as? String
                    let name = group["name"] as? String
                    let objMembersData = GroupMessageListDataModel(id: id, name: name)
                    arrGroupsData.append(objMembersData)
                }
                
                caseDetailsModel = CaseDataModel(casestatus: casestatus, created: created, datastatus: datastatus, description: description, groups: arrGroupsData, id: objHeaderQueue.strObjectId, members: arrMembersData, messages: messages, name: name, scheduled: scheduled, status: status, updated: updated)
                
                delegate?.getCaseDetails()
            } else {
                delegate?.getCaseDetails()
            }
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForChangingCaseStatus(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let id = objHeaderQueue.objHashMapData?["item"] as? String ?? ""
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        if let firstIndex = casesData.firstIndex(where: { $0.id == id}) {
            if (statusFilter == dataStatus || statusFilter == "error" || statusFilter == "live") && dataStatus != "complete" {
                casesData[firstIndex].datastatus = dataStatus
                caseDetailsModel?.datastatus = dataStatus
            }else{
                self.casesData.remove(at: firstIndex)
            }
            delegate?.updateCaseStatusChange(dataStatus: datastatus ?? "", index: firstIndex)
        }
    }
    
    func handleResponseForNewCase(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let id = responseDict["id"] as? String
        let dataStatus = responseDict["datastatus"] as? String
        if let firstIndex = casesData.firstIndex(where: { $0.id == objHeaderQueue.strObjectId ?? ""}){
            if status == 1 {
                casesData[firstIndex].id = id
                casesData[firstIndex].datastatus = dataStatus
            }else{
                casesData.remove(at: firstIndex)
            }
            delegate?.updateAddCaseSuccess(status: status, index: firstIndex)
        }
    }
    
    func handleResponseForEditCase(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let id = objHeaderQueue.strObjectId ?? ""
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        if let firstIndex = casesData.firstIndex(where: { $0.id == id}) {
            if (statusFilter == dataStatus || statusFilter == "error" || statusFilter == "live"){
                casesData[firstIndex].datastatus = dataStatus
                caseDetailsModel?.datastatus = dataStatus
            }else {
                casesData.remove(at: firstIndex)
            }
            delegate?.updateEditCaseSuccess(dataStatus: datastatus ?? "", index: firstIndex)
        }
    }
    
    func handleResponseForDeleteCase(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let id = objHeaderQueue.strObjectId ?? ""
        if let firstIndex = casesData.firstIndex(where: {$0.id == id}) {
            if status == 1 {
                casesData.remove(at: firstIndex)
            } else {
                casesData[firstIndex].datastatus = "error"
            }
            delegate?.updateDeleteCaseSuccess(status: status, index: firstIndex)
        }
    }
    
    func handleResponseForAddNewCaseMemberAndGroup(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        if responseDict.count > 0 {
            if responseDict["status"] as? Int == 1{
                delegate?.updateAddMemberAndGroupScuess()
            }
        }else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForMessagePeopleGroupList(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        
        var model = MessagePeopleGroupsDataModel()
    
        if responseDict.count > 0 {
            if responseDict["status"] as? Int == 1 {
                let conversations = responseDict["conversations"] as? [[String: Any]] ?? []
                let members:[[String:Any]] = responseDict["members"] as? [[String:Any]] ?? []
                let groups:[[String:Any]] = responseDict["groups"] as? [[String:Any]] ?? []
//                arrMembersData.removeAll()
                for member in members {
                    let id = member["id"] as? String
                    let image = member["image"] as? String
                    let imagedatetime = member["imagedatetime"] as? String
                    let name = member["name"] as? String
                    let status = member["status"] as? String
                    let thumbnail = member["thumbnail"] as? String
                    let objMembersData = MembersMessageDataModel(id: id, image: image, imagedatetime: imagedatetime, name: name, status: status, thumbnail: thumbnail)
                    arrMembersData.append(objMembersData)
                }
                print(responseDict)
                print(arrMembersData)
                for group in groups {
                    let id = group["id"] as? String
                    _ = group["image"] as? String
                    _ = group["imagedatetime"] as? String
                    let name = group["name"] as? String
                    _ = group["status"] as? String
                    _ = group["thumbnail"] as? String
                    let objGroupData = GroupMessageListDataModel(id: id, name: name)
                    arrGroupsData.append(objGroupData)
                }
                
                for conversation in conversations {
                    let id = conversation["id"] as? String
                    let image = conversation["image"] as? String
                    let imagedatetime = conversation["imagedatetime"] as? String
                    let name = conversation["name"] as? String
                    let status = conversation["status"] as? String
                    let thumbnail = conversation["thumbnail"] as? String
                    let objMembersData = MembersMessageDataModel(id: id, image: image, imagedatetime: imagedatetime, name: name, status: status, thumbnail: thumbnail)
                    arrConversationData.append(objMembersData)
                }
                
                model = MessagePeopleGroupsDataModel(conversations: arrConversationData, groups: arrGroupsData, members: arrMembersData)
                print(model)
                delegate?.getMessagePeopleGroupList(model: model)
            } else {
            }
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForDeleteCaseMemberAndGroup(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        if responseDict.count > 0 {
            if responseDict["status"] as? Int == 1{
                delegate?.updateDeleteMemberAndGroup()
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
}
