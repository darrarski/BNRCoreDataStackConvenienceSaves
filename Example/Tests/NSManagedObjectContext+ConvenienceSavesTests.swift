//
//  Created by Dariusz Rybicki on 18/04/16.
//

import Foundation

import XCTest

import CoreData
import BNRCoreDataStack
import BNRCoreDataStackConvenienceSaves

class NSManagedObjectContextConvenienceSavesTests: XCTestCase {
    var context: NSManagedObjectContextFake!
    
    override func setUp() {
        super.setUp()
        context = NSManagedObjectContextFake()
    }
    
    override func tearDown() {
        context = nil
        super.tearDown()
    }

    func testShouldSave() {
        context.shouldThrowOnSave = false
        context.fakeHasChanges = true
        do {
            try context.saveOrRollback()
        }
        catch {
            XCTFail("Error: \(error)")
        }
        XCTAssertEqual(context.saveCallsCount, 1)
        XCTAssertEqual(context.savesCount, 1)
        XCTAssertEqual(context.rollbacksCount, 0)
    }
    
    func testShouldRollbackOnError() {
        context.shouldThrowOnSave = true
        context.fakeHasChanges = true
        var thrownError: ErrorType?
        do {
            try context.saveOrRollback()
        }
        catch {
            thrownError = error
        }
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(context.saveCallsCount, 1)
        XCTAssertEqual(context.savesCount, 0)
        XCTAssertEqual(context.rollbacksCount, 1)
    }
}
