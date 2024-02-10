//
//  File.swift
//  
//
//  Created by TMLI IT Dev on 10/02/24.
//

import Combine

public protocol RemoteSrc {
    associatedtype Req
    associatedtype Res

    func execute(_ req: Req?) -> AnyPublisher<Res, Error>
}
