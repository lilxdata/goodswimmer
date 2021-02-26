//
//  regex_tests.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 2/23/21.
//  Copyright © 2021 madi. All rights reserved.
//

import Foundation
class REGEX_TESTS {

    static func run_regex_date_test() -> Void {
        regex_tester(dateString: "07/31/2050")
        regex_tester(dateString: "7/31/2050")
        regex_tester(dateString: "07/31/2050")
        regex_tester(dateString: "7/32/2050")
        regex_tester(dateString: "07/32/2050")
        regex_tester(dateString: "7/31/2150")
        regex_tester(dateString: "07/31/2150")
        regex_tester(dateString: "7/31/2090")
        regex_tester(dateString: "07/31/1909")
        regex_tester(dateString: "02/31/2050")
        regex_tester(dateString: "2/31/2050")
        regex_tester(dateString: "02/28/2050")
        regex_tester(dateString: "2/28/2050")
        regex_tester(dateString: "2/28/2400")
        regex_tester(dateString: "2/29/2400")
        regex_tester(dateString: "2/31/2400")

    }
    
    static func regex_tester(dateString: String) -> Void {
        print("dateString is", dateString, Validators.isDateValid(dateString))
    }
}
