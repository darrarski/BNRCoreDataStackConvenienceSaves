//
//  Created by Dariusz Rybicki on 18/04/16.
//

import CoreData

class NSManagedObjectContextFake: NSManagedObjectContext {
    var fakeHasChanges = false
    var fakeHasChangesOnce = false
    var shouldThrowOnSave = false
    
    private(set) var saveCallsCount = 0
    private(set) var savesCount = 0
    private(set) var rollbacksCount = 0
    
    override var hasChanges: Bool {
        return fakeHasChanges || fakeHasChangesOnce
    }
    
    override func save() throws {
        saveCallsCount += 1
        if shouldThrowOnSave {
            throw NSError(domain: "FakeError", code: 0, userInfo: nil)
        }
        savesCount += 1
        fakeHasChangesOnce = false
    }
    
    override func rollback() {
        rollbacksCount += 1
        fakeHasChanges = false
        fakeHasChangesOnce = false
    }
}
