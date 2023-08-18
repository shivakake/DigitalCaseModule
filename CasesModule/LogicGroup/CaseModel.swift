//
//  CaseModel.swift
//  CasesModule
//
//  Created by PGK Shiva Kumar on 29/11/22.
//

import Foundation

public struct CaseDataModel {
    
    public var casestatus: String?
    public var created: String?
    public var datastatus: String?
    public var description : String?
    public var groups: [GroupMessageListDataModel]?
    public var id: String?
    public var members: [MembersMessageDataModel]?
    public var messages: String?
    public var name: String?
    public var scheduled: String?
    public var status: Int?
    public var updated: String?
}

public struct MembersMessageDataModel {
    
    public var id: String?
    public var image: String?
    public var imagedatetime: String?
    public var name: String?
    public var status: String?
    public var thumbnail: String?
}

public struct GroupMessageListDataModel {
    
    public var forms: [String:Any]?
    public var id: String?
    public var name: String?
}

public struct MessagePeopleGroupsDataModel {
    
    public var conversations : [MembersMessageDataModel]?
    public var groups : [GroupMessageListDataModel]?
    public var members : [MembersMessageDataModel]?
}
