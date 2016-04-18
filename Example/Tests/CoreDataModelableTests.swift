//
//  Created by Dariusz Rybicki on 18/04/16.
//

import Foundation

import XCTest

import CoreData
import BNRCoreDataStack
import BNRCoreDataStackConvenienceSaves

class CoreDataModelableTests: XCTestCase {
    var stack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        
        weak var expectation = expectationWithDescription("callback")
        CoreDataStack.constructSQLiteStack(withModelName: "Sample", inBundle: unitTestBundle, withStoreURL: tempStoreURL) { result in
            switch result {
            case .Success(let stack):
                self.stack = stack
            case .Failure(let error):
                XCTFail("Error constructing stack: \(error)")
            }
            expectation?.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    override func tearDown() {
        removeTempDir()
        super.tearDown()
    }
    
    // MARK: - Helpers
    
    private var unitTestBundle: NSBundle {
        return NSBundle(forClass: self.dynamicType)
    }
    
    private func failingOn(error: ErrorType) {
        XCTFail("Failing with error: \(error) in: \(self)")
    }
    
    private lazy var tempStoreURL: NSURL? = {
        return self.tempStoreDirectory?.URLByAppendingPathComponent("testmodel.sqlite")
    }()
    
    private lazy var tempStoreDirectory: NSURL? = {
        let baseURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
        let tempDir = baseURL.URLByAppendingPathComponent("XXXXXX")
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(tempDir,
                                                                    withIntermediateDirectories: true,
                                                                    attributes: nil)
            return tempDir
        } catch {
            assertionFailure("\(error)")
        }
        return nil
    }()
    
    private func removeTempDir() {
        if let tempStoreDirectory = tempStoreDirectory {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(tempStoreDirectory)
            } catch {
                assertionFailure("\(error)")
            }
        }
    }
}
