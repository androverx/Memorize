//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Andrey Mosolov on 05.09.2020.
//  Copyright © 2020 Andrey Mosolov. All rights reserved.
//

// VIEW file //
import SwiftUI

struct EmojiMemoryGameView : View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View{
        
        VStack {
        //HStack {
        //    ForEach(viewModel.cards) {card in
        
        //instead of Hstack return custom grid type of View
        Grid(viewModel.cards) {card in
            //for single card in grid handle onTap event
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.7)) {
                        self.viewModel.choose(card: card)
                    }
                    
                }
                .padding(5)
            }
        //}
        .foregroundColor(Color.orange)
        .padding()
            
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    viewModel.resetGame()
                }
            }, label: {Text("New Game")}) //localizedString
        }
    }
}

//MARK: card View
struct CardView: View {
    var card: MemoryGame<String>.Card
    
    //MARK: reading size of view body to fit in layout
    var body: some View{
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation () {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    //MARK: card view both sides
    @ViewBuilder
    private func body (for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
            /*
            if card.isFaceUp {
                //shape
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
 */
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees (-animatedBonusRemaining*360-90), clockwise: true)//110-90
                            .onAppear{
                                self.startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees (-card.bonusRemaining*360-90), clockwise: true)//110-90
                    }
                } .padding(5).opacity(0.4)
               
           
                //content
                Text(card.content)//scale size of font depending on size of view body
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.init(degrees: card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : .default)
            /*
            } else {
                //shape
                if !card.isMatched {
                    RoundedRectangle(cornerRadius: cornerRadius).fill()
                }
               
            }*/
            }
            //.modifier(Cardify(isFaceUp: card.isFaceUp))
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
            //.rotation3DEffect(Angle.degrees(card.isFaceUp ? 0 : 180), axis: (0,1,0))
        }
    }
    
    
    // MARK: - Drawing constants
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
    private let fontScaleFactor: CGFloat = 0.75
    private func fontSize(for size: CGSize) -> CGFloat {
        fontScaleFactor * min(size.height, size.width)
    }
}






//show automatic preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
