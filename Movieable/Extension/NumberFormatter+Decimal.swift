//
//  NumberFormatter+Decimal.swift
//  Movieable
//
//  Created by Duy Tran on 10/5/20.
//

import Foundation

extension NumberFormatter {
    
    static let decimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.locale = .autoupdatingCurrent
        return formatter
    }()
}
