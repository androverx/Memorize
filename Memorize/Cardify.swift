//
//  Cardify.swift
//  Memorize
//
//  Created by Andrey Mosolov on 03.10.2020.
//  Copyright © 2020 Andrey Mosolov. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {//ViewModifier {
    var rotation: Double
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    
    //typealias Body = <#type#>
    func body(content: Content) -> some View {
        ZStack {
            Group {
            //if isFaceUp {
                //shape
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
            
                //content
                content
            }.opacity(isFaceUp ? 1 : 0)
            //} else {
                //shape
            RoundedRectangle(cornerRadius: cornerRadius).fill().opacity(isFaceUp ? 0 : 1)
            //}
        }.rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    
    }
    // MARK: - Drawing constants
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
    
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
