//
//  Route.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

struct Route {
    var departureTown: Location
    var places: [Place]
    var start: Date?
    var finish: Date?
}
