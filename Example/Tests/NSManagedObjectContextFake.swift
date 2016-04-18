//
//  Created by Dariusz Rybicki on 18/04/16.
//

import CoreData

class NSManagedObjectContextFake: NSManagedObjectContext {
    var fakeHasChanges = false
    var shouldThrowOnSave = false
    var fakeInsertedObjectsCount = 0
    var fakeUpdatedObjectsCount = 0
    var fakeDeletedObjectsCount = 0
    
    private(set) var saveCallsCount = 0
    private(set) var savesCount = 0
    private(set) var rollbacksCount = 0
    
    override var hasChanges: Bool {
        guard fakeInsertedObjectsCount == 0 else { return true }
        guard fakeUpdatedObjectsCount == 0 else { return true }
        guard fakeDeletedObjectsCount == 0 else { return true }
        return fakeHasChanges
    }
    
    override var changedObjectsCount: Int {
        return fakeInsertedObjectsCount + fakeUpdatedObjectsCount + fakeDeletedObjectsCount
    }
    
    override func save() throws {
        saveCallsCount += 1
        if shouldThrowOnSave {
            throw NSError(domain: "FakeError", code: 0, userInfo: nil)
        }
        usleep(250_000) // TODO: WIP
        savesCount += 1
        resetFakeModifiedObjectsCount()
    }
    
    override func rollback() {
        usleep(250_000) // TODO: WIP
        rollbacksCount += 1
        resetFakeModifiedObjectsCount()
    }
    
    private func resetFakeModifiedObjectsCount() {
        fakeInsertedObjectsCount = 0
        fakeUpdatedObjectsCount = 0
        fakeDeletedObjectsCount = 0
    }
}
