// ****************************************************
// ******************  Avraham Rada  ******************
// ******************    309539674   ******************
// ****************************************************

import UIKit
import CoreLocation

class OpeningViewController: UIViewController {

    //  MARK: Variables
    var name : String!
    var myLocation : MyLocation!
    var locationManager: CLLocationManager!
    
    //  MARK: IBOutlet
    @IBOutlet weak var name_TEXTFIELD_nameHolder: UITextField!
    
    // MARK: onCreate()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    // MARK: onClick_01()
    @IBAction func onPlayButtonPressed(_ sender: UIButton) {
        name = name_TEXTFIELD_nameHolder.text
        if(name.isEmpty){
            name = "DEMO PLAYER"
        }
        self.performSegue(withIdentifier: "goToGameView", sender: self)
    }
    
    // MARK: onClick_02()
    @IBAction func onTop10ButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToTop10View", sender: self)
    }
    
    //MARK: Navigation == Intent(Android)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToGameView"){
            let gameView = segue.destination as! GameController
            gameView.name = name
            gameView.myLocation = self.myLocation
            gameView.numOfRows = 4
            gameView.numOfCardsPerRow = 4
            
        } else if(segue.identifier == "goToTop10View"){
            _ = segue.destination as! Top10Controller
        }
    }
}

//  MARK: Extension
extension OpeningViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            self.myLocation = MyLocation(lat:location.coordinate.latitude, lng: location.coordinate.latitude)
            print("got Location: \(String(describing: myLocation.lat)) \(String(describing: myLocation.lng))")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error=\(error)")
        // Default location - in case of an ERROR
        self.myLocation = MyLocation(lat:31.92933, lng: 34.79868)
    }
}
