//
//  ViewModelType.swift
//  09
//
//  Created by 김기영 on 2021/09/10.
//

import Foundation


import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
