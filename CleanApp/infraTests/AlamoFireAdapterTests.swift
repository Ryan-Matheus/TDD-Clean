//
//  infraTests.swift
//  infraTests
//
//  Created by user on 16/05/22.
//

import XCTest
import Alamofire

class AlamoFireAdapter {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(to url: URL) {
        session.request(url, method: .post).resume()
    }
}

class AlamoFireAdapterTests: XCTestCase {
    func test_() {
        let url = makeUrl()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamoFireAdapter(session: session)
        sut.post(to: url)
        let exp = expectation(description: "waiting")
        UrlProtocolStub.observerRequest { request in
            XCTAssertEqual("POST", request.httpMethod)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

class UrlProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    static func observerRequest(completion: @escaping (URLRequest) -> Void) {
        UrlProtocolStub.emit = completion
    }
    
   override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override open func startLoading() {
        UrlProtocolStub.emit?(request)
    }

    override open func stopLoading() {}
}
