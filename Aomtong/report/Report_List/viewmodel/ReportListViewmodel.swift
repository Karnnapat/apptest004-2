//
//  ReportListViewmodel.swift
//  Aomtung
//
//  Created by Karnnapat Kamolwisutthipong on 14/2/2567 BE.
//

import Foundation

public protocol list_ViewcontrollerModelDelegate: class {
    func setupsegment()
}

class list_ViewcontrollerModel {
    var delegate :list_ViewcontrollerModelDelegate!
}
