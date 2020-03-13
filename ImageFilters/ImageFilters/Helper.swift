//
//  Helper.swift
//  ImageFilters
//
//  Created by Alexander Supe on 13.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

struct Helper {
    static func getImages() -> [Image]{
        if let data = UserDefaults.standard.data(forKey: "Images") {
            let decoder = JSONDecoder()
            if let array = try? decoder.decode([Image].self, from: data) {
                return array
            }
        }
        return []
    }
    
    static func setImages(_ images: [Image]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(images) {
            UserDefaults.standard.set(data, forKey: "Images")
        }
    }
}
