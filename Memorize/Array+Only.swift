//
//  Array+Only.swift
//  Memorize
//
//  Created by Andrey Mosolov on 01.10.2020.
//  Copyright © 2020 Andrey Mosolov. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
        /*
         if faceUpCardIndicies.count == 1 {
             return faceUpCardIndicies.first
         } else {
             return nil
         }
         */
    }
}
