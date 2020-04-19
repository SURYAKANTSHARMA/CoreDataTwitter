//
//  ViewModel.swift
//  CoreDataTwitter
//
//  Created by tokopedia on 16/02/20.
//  Copyright © 2020 SuryaKant Sharma. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
