// ****************************************************
// ******************  Avraham Rada  ******************
// ******************    309539674   ******************
// ****************************************************

import Foundation
import UIKit

class HighScore : Codable{
    
    var name : String
    var time : Int
    var location : MyLocation
    var date : Date

    
    init(name : String, time : Int, location: MyLocation,date : Date) {
        
        self.name = name
        self.time = time
        self.location = location
        self.date = date
        
    }
    
}
