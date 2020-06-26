// ****************************************************
// ******************  Avraham Rada  ******************
// ******************    309539674   ******************
// ****************************************************

import UIKit
import AVFoundation

class GameController: UIViewController {
    
    // MARK:IBOutlet
    @IBOutlet weak var game_LBL_moves: UILabel!
    @IBOutlet weak var game_LBL_timer: UILabel!
    @IBOutlet weak var game_STACKVIEW_cardsHolder: UIStackView!
    @IBOutlet weak var game_BTN_back: UIButton!
    
    // MARK:Variables
    var numOfRows : Int!
    var numOfCardsPerRow : Int!
    var numOfCards : Int!
    var cards = [Card]()
    var firstCard : Card?
    var raffle : Bool = true
    var isClickable : Bool = true
    var moves : Int = 0
    var timePassed : Int = 0
    var timePassedText : String! = "0"
    var timerHelper : TimerHelper!
    var name : String!
    var myLocation : MyLocation!
    let PAIR :Int = 2
    
    // MARK: onCreate()
    override func viewDidLoad() {
        super.viewDidLoad();
        
        timerHelper = TimerHelper()
        initCards(numOfRows: numOfRows, numOfCardsPerRow: numOfCardsPerRow);
        arrangeCards() // arraging the cards on the screen
        startTimer()
    }
    
    // MARK: onClickListener_01()
    @IBAction func onBackButtonPressed(_ sender: UIButton) {
       if let nav = self.navigationController {
            nav.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: onClickListener_02()
    @IBAction func flip(_ sender: Card) {
//        if(!isClickable){
//            // Player can't click a card - waiting for other cards to flip
//            return
//        }
//
//        if(sender.isFlipped){
//            //Some card has been clicked.
//            return
//        }
//        handleCard(sender: sender);
        if(!(!isClickable || sender.isFlipped)){
            handleCard(sender: sender)
        }
    }

    // MARK: initCards()
    func initCards(numOfRows : Int, numOfCardsPerRow : Int){
        numOfCards = numOfRows * numOfCardsPerRow;
        for _ in 0 ..< numOfRows {
            let row : UIStackView = createLinearViewWithCards()
            for _ in 0 ..< numOfCardsPerRow {
                let newCard : Card = createCard()
                row.addArrangedSubview(newCard) // adding newCard to row Stackview
                cards.append(newCard) //Adding newCard to cards Array ref
            }
            game_STACKVIEW_cardsHolder.addArrangedSubview(row);
        }
    }

    // MARK: createCard()
    func createCard () -> Card {
        let newCard : Card = Card()
        newCard.addTarget(self, action: #selector(flip), for: .touchUpInside);
        return newCard;
    }

    // MARK: createRow()
    func createLinearViewWithCards () -> UIStackView {
        let s: CGFloat = 4
        let row = UIStackView() // create linearView
        row.axis = .horizontal
        row.alignment = .fill
        row.distribution = .fillEqually
        row.spacing = s
        row.contentMode = .scaleToFill
        row.translatesAutoresizingMaskIntoConstraints = false

        return row;
    }

    // MARK: arrangeCards()
    func arrangeCards()  {
        var images = [#imageLiteral(resourceName: "ic_emoji_ethiopian_man"),#imageLiteral(resourceName: "ic_emoji_exploding_head"),#imageLiteral(resourceName: "ic_emoji_monkey"),#imageLiteral(resourceName: "ic_emoji__cat_face_with_eart_eyes"),#imageLiteral(resourceName: "ic_emoji_vomiting"),#imageLiteral(resourceName: "ic_emoji_devil"),#imageLiteral(resourceName: "ic_emoji_laugh"),#imageLiteral(resourceName: "ic_emoji_no_mouth")]
//      availableThemes[0] = ["🧥", "🥼", "👚", "👕", "👖", "🧵", "🧶", "👔", "👗", "👙", "👘", "🧢", "🧦", "👡", "👠", "🎩"]
//      availableThemes[1] = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵"]
//      availableThemes[2] = ["🐙", "🦑", "🦐", "🦞", "🐡", "🐠", "🐟", "🐋", "🦈", "🐊", "🐳", "🐢", "🐍", "🦎", "🐸", "🦀"]
//      availableThemes[3] = ["🌵", "🌲", "🌳", "🌴", "🌱", "🌿", "☘", "🎍", "🎋", "🍃", "🍂", "🍁", "🍄", "🌾", "🎄", "🍀"]
//      availableThemes[4] = ["🍏", "🍎", "🍐", "🍋", "🍌", "🍇", "🍓", "🍈", "🍒", "🥭", "🍍", "🥥", "🥝", "🍅", "🍑", "🍉"]
        
        var size = numOfCards / 2
        var slots = [Int](repeating: 0, count: size)
        var randomIndex : Int

        for card in cards {
            while (raffle) {
                randomIndex = Int.random(in: 0 ..< size)
                if(slots[randomIndex] < PAIR){
                    raffle = false;
                    slots[randomIndex] += 1
                    card.front = images[randomIndex]
                } else {
                    // The same card has already asign twice
                    images.remove(at: randomIndex)
                    slots.remove(at: randomIndex)
                    size -= 1
                }
            }
            raffle = true // Reset for next round.
        }
    }

    // MARK: moves++
    func addMove() {
        moves += 1
        game_LBL_moves.text  = String(moves)
    }
    
    // MARK: cardClicked()
    func handleCard(sender : Card){
        // Card #1
        if(firstCard == nil){
            sender.flip() //flip first card to reveal his image.
            firstCard = sender
        } else {
            // Card #2
            sender.flip() //flip second card to reveal his image.
            isClickable = false;
            checkIfEquals(sender: sender) // Match ?
        }
    }

    // MARK: checkIfEquals()
    func checkIfEquals(sender : Card){
        if(sender.front == firstCard!.front){
            match(sender: sender)
        } else {
            wrong(sender: sender)
        }
    }

    // MARK: match()
    func match(sender : Card){
        sender.remove()
        firstCard?.remove()
        addMove()
        firstCard = nil
        if(isThereAWinner()){
            self.performSegue(withIdentifier: "goToGameOverView", sender: self)
        }
        isClickable = true // player can now guess again.
    }

    // MARK: wrong()
    func wrong(sender : Card) {
        addMove()
        //Delay for 2 seconds when revealing the second card.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2 ) {
            self.firstCard!.flip() // flip the cards back
            sender.flip()
            self.isClickable = true // Guess again
            self.firstCard = nil // First card RESET
        }
    }

    // Mark: Start clocking
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timePassed += 1
            self.timePassedText =  self.timerHelper.convertTimeToMinutesAndSeconds(timePassed: self.timePassed)
            self.game_LBL_timer.text = String(self.timePassedText)
        }
    }
    
    // MARK: win ?
    func isThereAWinner() -> Bool {
        for card in cards {
            if(!card.isFlipped){
                return false
            }
        }
        return true
    }

    // MARK: NEW GAME
    func newGame () {
        resetCards() // New game arrange
        resetMoves()
        resetTimer()
        resetFliped()
        arrangeCards()
    }

    // MARK: RESET SCREEN
    func resetCards() {
        for card in cards {
            card.flip()
            card.add()
        }
    }

    func resetFliped() {
        for card in cards {
            card.isFlipped = false;
        }
    }

    func resetMoves() {
        self.moves = 0
        game_LBL_moves.text  = String(moves)
    }

    func resetTimer() {
        self.timePassed = 0
        game_LBL_timer.text  = String(timePassed)
    }

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToGameOverView"){
            let gameOver = segue.destination as! GameOverController
            //Set the game parameters
            gameOver.time = timePassed
            gameOver.moves = moves
            gameOver.lastGameNumOfRows = numOfRows
            gameOver.lastGameNumOfCardsPerRow = numOfCardsPerRow
            gameOver.userHighScore = HighScore(name: name, time: timePassed, location: myLocation,date: Date())
        }
    }
}

