// Name: Avraham Rada
// ID: 309539674

import UIKit

class ViewController: UIViewController {

    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2 )
    var cheatsEnabled = false
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelCongrats: UILabel!
    @IBOutlet weak var flipCountrLabel: UILabel!
    

    // New Game
    @IBAction func resetGame(_ sender: UIButton) {
        Card.resetIdentifiers()
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2 )
        emojiChoices = setTheme()
        updateViewFromModel()
    }
    
    // Clicking on a card
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender){

            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    /// verifies that the cards are matching and make sure all the cards match
    func updateViewFromModel(){
        for index in cardButtons.indices{
            let card = game.cards[index] // get the coresponding card from model
            let button = cardButtons[index]
            
            if card.isFaceDown {
                button.setTitle(cheatsEnabled ? emoji(for: card) : "", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ?  ( !cheatsEnabled ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.3961542694) ): #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) //
            } else {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }
        flipCountrLabel.text = "Flips: \(game.numberOfFlips)"
        labelScore.text = "Score: \(game.curentScore())"
        
        if game.isGameOver{
            for index in cardButtons.indices{
                cardButtons[index].backgroundColor = !cheatsEnabled ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.3961542694)
                if !cheatsEnabled {
                    cardButtons[index].setTitle("", for: UIControl.State.normal)
                }
                
            }
            flipCountrLabel.text = ""
            labelCongrats.text  = "Done. more?"
            labelCongrats.isHidden = false
        } else {
            labelCongrats.isHidden = true
        }
            
    }
    
    lazy var emojiChoices = setTheme()
    
    func setTheme() -> [String] {
        var availableThemes = Dictionary<Int,[String]>()
        
        availableThemes[0] = ["🧥", "🥼", "👚", "👕", "👖", "🧵", "🧶", "👔", "👗", "👙", "👘", "🧢", "🧦", "👡", "👠", "🎩"]
        availableThemes[1] = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵"]
        availableThemes[2] = ["🐙", "🦑", "🦐", "🦞", "🐡", "🐠", "🐟", "🐋", "🦈", "🐊", "🐳", "🐢", "🐍", "🦎", "🐸", "🦀"]
        availableThemes[3] = ["🌵", "🌲", "🌳", "🌴", "🌱", "🌿", "☘", "🎍", "🎋", "🍃", "🍂", "🍁", "🍄", "🌾", "🎄", "🍀"]
        availableThemes[4] = ["🍏", "🍎", "🍐", "🍋", "🍌", "🍇", "🍓", "🍈", "🍒", "🥭", "🍍", "🥥", "🥝", "🍅", "🍑", "🍉"]
        availableThemes[5] = ["🤲", "👐", "🙌", "👏", "🤝", "👍", "👎", "👊", "✊", "🤛", "🤞", "✌", "🤟", "👈", "🖖"]
        
        let randomThemeIndex = Int(arc4random_uniform(UInt32(availableThemes.count)))
        playableEmoji = [Int:String]()
        
        return (availableThemes[randomThemeIndex])!
    }
    
    var playableEmoji = [Int:String]() //dictionary
    
    func emoji(for card: Card) -> String {
        if playableEmoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            playableEmoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return playableEmoji[card.identifier] ?? "?"
    }
}

