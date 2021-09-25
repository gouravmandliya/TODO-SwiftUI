//
//  ThemeSettings.swift
//  To-Do
//
//  Created by Gourav on 04/07/21.
//

import Foundation

class ThemeSettings: ObservableObject {
    @Published var themeSettings:Int = UserDefaults.standard.integer(forKey: "Theme"){
        didSet{
            UserDefaults.standard.setValue(self.themeSettings, forKey: "Theme")
        }
    }
    private init() {}
    public static let shared = ThemeSettings()
}
