//
//  MapStore.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import Foundation
import RealmSwift
import MapKit
import Combine
import SwiftUI

final class MapStore: ObservableObject{
    
    @Published var realmManager: RealmManager
    private var subscribtions = Set<AnyCancellable>()
    
    
    @Published var brnoLocations: [BrnoLocation] = []
    @ObservedObject var locationManager: CustomLocationManager
    @Published var currentLocationString: String = ""
    @Published var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45, longitude: 16), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    
    init(realmManager: RealmManager, locationManager: CustomLocationManager){
        self.realmManager = realmManager
        self._locationManager = ObservedObject(wrappedValue: locationManager)
        
        initializeSubs()
    }
    
    func centerMapOnUserLocation(){
        if let loc = locationManager.currentLocation{
            self.coordinateRegion = MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        }
    }
    
}

// MARK: Subs
extension MapStore{
    
    private func initializeSubs(){
        locationManager.$currentLocation
            .receive(on: DispatchQueue.main)
            .first(where: { $0 != nil})
            .sink(receiveValue: { [weak self] location in
                if let loc = location{
                    self?.coordinateRegion = MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                }
            })
            .store(in: &subscribtions)
    }
    
    
    // METHOD FOR DELETING ALL LANDMARKS (DISCOVERABLE AND DISCOVERED OF SIGNED USER)
    @MainActor
    func deleteAllLandmarks(){
        do{
            try realmManager.realm?.write{
                realmManager.realm?.deleteAll()
            }
        } catch{
            print(error)
        }
    }
    
    // METHOD FOR ADDING DISCOVERABLE LANDMARKS
    @MainActor
    func saveDiscoverableLandmarks() throws{
        let landmarks = [
            DiscoverableLandmark(name: "Brno astronomical clock", hint: "Dark obelisk that tells time", imageAssetName: "astronomicalClock", landmarkDescription: "Brno astronomical clock (Czech: Brněnský orloj) is a black stone monument in Brno, Czech Republic. It is situated at Náměstí Svobody, the main square in the Brno City Centre. The monument was proposed by Oldřich Rujbr and Petr Kameník. Every day at 11:00 it releases a glass marble, which the spectators can catch from one of four openings in the monument and they can take it with them as a souvenir. Although the monument is publicly known as an astronomical clock (orloj), it is only a clock. Construction of the clock took three years, at a cost of approximately 12 million CZK.", landmarkReward: .astronomicalClock, longitude: 16.608581, latitude: 49.194795),
            DiscoverableLandmark(name: "Brno dragon", hint: "A dragon of sorts, but with no wings", imageAssetName: "brnoDragon", landmarkDescription: "The origin of the Brno dragon is not reliably documented. Many rumors about him have been circulating among the residents of Brno for centuries. According to some, the crocodile was brought to Brno already stuffed, according to others, it originally lived in a cave near the river Svratka. The most common tradition is that the crocodile was presented to Margrave Matyáš of Brno in 1608. A report of this was stored in the mine of the town hall tower in 1749. However, the dragon must have been in Brno before 1608, because according to accounts from the Brno archive, it was restored and wormed as early as 1578 , 1579. The Old Town Hall itself, in the passageway of which the crocodile is hung, states on the tickets to the tower that the crocodile was a gift from Turkish messengers to King Matthias II. in 1609. It is also said that the dragon was brought to Brno by knights from the Crusades.", landmarkReward: .brnoDragon, longitude: 16.608773, latitude: 49.193157),
            DiscoverableLandmark(name: "Cathedral of St. Peter and Paul", hint: "An enourmous building watching over whole Brno", imageAssetName: "peterAndPaulCathedral", landmarkDescription: "The Cathedral of Saints Peter and Paul is a Roman Catholic cathedral located on the Petrov hill in the Brno-střed district of the city of Brno in the Czech Republic. It is commonly referred to locally as simply \"Petrov\". It is the seat of the Diocese of Brno and a national cultural monument that is one of the most important pieces of architecture in South Moravia. The interior is mostly Baroque in style, while the exterior shell is Gothic that dates mostly from the 14th century, and its impressive 84-metre-high towers were constructed to the Gothic Revival designs of the architect August Kirstein between 1901–09. The original cathedral site dates to the 11th century.", landmarkReward: .peterAndPaulCathedral, longitude: 16.606897, latitude: 49.191529),
            DiscoverableLandmark(name: "Mahen theatre", hint: "A theatre with proportions of chateau", imageAssetName: "mahenTheatre", landmarkDescription: "Mahen Theatre (Czech: Mahenovo divadlo) is a Czech theatre situated in the city of Brno. Mahen Theatre, built as German Deutsches Stadttheater in 1882, was one of the first public buildings in the world lit entirely by electric light.[1] It was built in a combination of Neo-renaissance, Neo-baroque and Neoclassical architectural styles. Brno, a city of one hundred thousand inhabitants at the time the theater opened, built the first theater on the European continent equipped with electric bulb lighting. At the same time, electricity had not yet been widely introduced in the city, so a small power plant had to be built just for the needs of the theater. The author of the electric lighting project, T. A. Edison, only visited Brno twenty-five years later to see the work he designed. Parts of Edison's original wiring are on display in a small exhibit in the theater's foyer.", landmarkReward: .mahenTheatre, longitude: 16.613822, latitude: 49.195761),
            DiscoverableLandmark(name: "Plague column", hint: "Very tall column reminding people to keep their hygiene in check", imageAssetName: "plagueColumn", landmarkDescription: "Plague Column (also Marian Column) is a Baroque column on Freedom Square in Brno. It was built in 1679–1683 to commemorate the plague epidemic (hence the plague column) that plagued the city in 1679–1680. It is located in the northern (upper) part of the square and forms its dominant feature. It is dedicated to the Virgin Mary (hence the Marian column) and the five plague saints. Its early Baroque form is based on the form of the Marian column erected on the Am Hof square in Vienna.", landmarkReward: .plagueColumn, longitude: 16.607818, latitude: 49.195290),
            DiscoverableLandmark(name: "Spielberg castle", hint: "Fortress standing guard on a hill. Takes a bit of effort to get to", imageAssetName: "spielbergCastle", landmarkDescription: "Špilberk (German Spielberg, in hantec Špilas) is a castle and fortress forming a dominant feature of the city of Brno. It is located on top of the hill of the same name, which is located in the Brno-střed district, in the west of the cadastral territory of the City of Brno. The castle was founded in the second half of the 13th century by the Moravian margrave (and later the Czech king) Přemysl Otakar II. and has undergone many significant changes over the centuries. The leading royal castle in Moravia, built in the Gothic style, became a massive Baroque fortress in the second half of the 17th century, which was besieged several times without success. Its casemates were converted into a dreaded prison at the end of the 18th century. In 1962, the castle together with the surrounding park was declared a national cultural monument. Currently, it belongs to the objects of the Museum of the City of Brno, which is located here.", landmarkReward: .spielbergCastle, longitude: 16.600021, latitude: 49.193832)
        ]
        
        for landmark in landmarks {
            try? realmManager.realm?.write{
                realmManager.realm?.add(landmark)
            }
        }
        
    }
     
     
}
