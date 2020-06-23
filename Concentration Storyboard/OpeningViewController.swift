import UIKit
import CoreLocation

class OpeningViewController: UIViewController {
    
    
    //@IBOutlet weak var menu_BTN_easy: UIButton!
    //@IBOutlet weak var menu_BTN_hard: UIButton!
    //@IBOutlet weak var menu_BTN_scores: UIButton!
    
    //let EASY_MODE = "Easy"
    //let HARD_MODE = "Hard"
    //var difficult : String?;
    var locationManager: CLLocationManager!
    //var myLocation : MyLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onPlayButtonPressed(_ sender: UIButton) {
        
        //difficult = sender.titleLabel!.text
        
        //self.performSegue(withIdentifier: "goToNamePage", sender: self)
        
    }
    
    
    @IBAction func onTop10ButtonPressed(_ sender: UIButton) {
        
        //self.performSegue(withIdentifier: "goToScoresPage", sender: self)
    }
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToNamePage"){
            //let namePage = segue.destination as! NameController
            //namePage.difficult = difficult
            //namePage.myLocation = myLocation
            
            
        } else if(segue.identifier == "goToScoresPage"){
           // _ = segue.destination as! ScoresController
            
        }
    }
}

extension OpeningViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("didUpdateLocations")

        /*if let location = locations.last {
            locationManager.stopUpdatingLocation()
            self.myLocation = MyLocation(lat:location.coordinate.latitude, lng: location.coordinate.latitude)
            print("got Location: \(String(describing: myLocation.lat)) \(String(describing: myLocation.lng))")
        }*/
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("Error=\(error)")
        //self.myLocation = MyLocation(lat: 0, lng: 0)
    }
}
