// ****************************************************
// ******************  Avraham Rada  ******************
// ******************    309539674   ******************
// ****************************************************

import Foundation

class TimerHelper {
    
    var minutes : Int = 0
    var seconds : Int = 0
    var minutesText : String = "0"
    var secondsText : String = "0"
    
    func buildClockVishion(timePassed: Int) -> String{

        //Calucalte minutes and seconds
        minutes = timePassed / 60
        if(timePassed >= 60){
            seconds = timePassed - minutes * 60
        } else {
            seconds = timePassed
        }
        
        //Show zero before seconds/minutes if less than 10
        if(seconds < 10){
            secondsText = "0\(seconds)"
        } else {
            secondsText = "\(seconds)"
        }
        
        if(minutes < 10){
            minutesText = "0\(minutes)"
        } else {
            minutesText = "\(minutes)"
        }

        return "\(minutesText) : \(secondsText)"
        
        
    }
    
    
    
}
