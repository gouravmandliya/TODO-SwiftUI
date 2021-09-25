//
//  IconNames.swift
//  To-Do
//
//  Created by Gourav on 03/07/21.
//

import SwiftUI

class IconNames :ObservableObject{
    var iconNames:[String?] = [nil]
    @Published var currentIndex = 0
    
    init() {
        getAlernateIconsNames()
        if let currentIcon = UIApplication.shared.alternateIconName{
            self.currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
        }
    }
    
    func getAlernateIconsNames(){
        if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String:Any],
        let alertnateIcons = icons["CFBundleAlternateIcons"] as? [String:Any]{
            for (_, value) in  alertnateIcons{
                guard let iconList = value as? Dictionary<String,Any> else { return }
                guard let iconsFiles = iconList["CFBundleIconFiles"] as? [String] else {
                    return
                }
                guard let icon = iconsFiles.first else {
                    return
                }
                    
                iconNames.append(icon)
                
            }
            
        }
    }
}
