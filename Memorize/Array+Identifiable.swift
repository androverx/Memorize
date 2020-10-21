//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Andrey Mosolov on 01.10.2020.
//  Copyright © 2020 Andrey Mosolov. All rights reserved.
//

import Foundation

//common for arrays, returns index of first element that matching argument
extension Array where Element: Identifiable {
    func firstIndex (matching: Element) -> Int? {
        for index in 0..<self.count{
            if self[index].id == matching.id {
                return index
            }
        }
        //return 0 // TODO: bogus
        return nil
    }
}
