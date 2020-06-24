// ****************************************************
// ******************  Avraham Rada  ******************
// ******************    309539674   ******************
// ****************************************************

import Foundation
import UIKit

class Card: UIButton {
    
    //  MARK: Variables
    var front : UIImage!;
    var back : UIImage = #imageLiteral(resourceName: "back")
    var isFlipped : Bool = false;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    //  MARK: onCreate()
    override init(frame: CGRect) {
        super.init(frame: frame);
        setBackgroundImage(back, for: UIControl.State.normal);
    }
    
    func flip() {
        if(isFlipped){
            // Flip the card back
            UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.setBackgroundImage(self.back, for: UIControl.State.normal);
            })
            isFlipped = false;
        } else {
            // Flip the card to his front
            UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                self.setBackgroundImage(self.front, for: UIControl.State.normal);
            })
             isFlipped = true;
        }
    }
    
    func remove() {
        UIView.animate(withDuration: 0.3,delay: 0.7, options: .curveEaseOut, animations: {
            self.alpha = 0;
        })
    }
    
    func add() {
        self.alpha = 1;
    }
}
