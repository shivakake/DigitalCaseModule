//
//  Device.swift
//  DigitalHorizonTaksThree
//
//  Created by PGK Shiva Kumar on 06/09/22.
//

import Foundation
import UIKit

public enum Orientation {
    
    case portrait
    case landscape
}

public class Device: NSObject {
    
    public class var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    public class var orientation: Orientation {
        
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            return .portrait
        case .landscapeLeft, .landscapeRight:
            return .landscape
        default:
            return .portrait
        }
    }
}
