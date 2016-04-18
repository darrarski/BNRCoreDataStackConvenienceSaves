//
//  Created by Dariusz Rybicki on 18/04/16.
//

import CoreData
import BNRCoreDataStack

/**
 Convenience extension to `NSManagedObjectContext` for easier context saving
 */
public extension NSManagedObjectContext {
    /**
     Convenience method to synchronously save the `NSManagedObjectContext` if changes are present.
     If `save()` function on the `NSManagedObjectContext` produces error, all changes will be rolled back and the error thrown.
     
     - throws: Errors produced by the `save()` function on the `NSManagedObjectContext`
     */
    public func saveOrRollback() throws {
        do {
            try saveContextAndWait()
        } catch {
            rollback()
            throw error
        }
    }
    
    /**
     Convenience method to asynchronously save the `NSManagedObjectContext` if changes are present.
     The method uses dispatch group to group multiple calls. Save will be delayed, so multiple calls to this method won't cause it
     untill maximum changed objects count will be exceeded. Save or rollback will be always performed on context's queue.
     If `save()` function on the `NSManagedObjectContext` produces error, all changes will be rolled back and the error thrown.
     
     - parameter group: `dispatch_group_t` that will be used group calls to this method.
     - parameter maxChangedObjectsCount: Maximum changed objects count, that if exceeded will cause save.
     - parameter onError: A closure that will be called when `save()` function on the `NSManagedObjectContext` produces error.
     */
    public func saveOrRollbackWithGroup(group: dispatch_group_t, maxChangedObjectsCount: Int = 100, onError: (ErrorType) -> ()) {
        saveWithGroup(group,
                      maxChangedObjectsCount: maxChangedObjectsCount,
                      usingBlock: { try self.saveOrRollback() },
                      onError: onError)
    }
    
    /**
     Convenience method to asynchronously save the `NSManagedObjectContext` if changes are present.
     The method uses dispatch group to group multiple calls. Save will be delayed, so multiple calls to this method won't cause it
     untill maximum changed objects count will be exceeded. Save will be always performed on context's queue.
     If `save()` function on the `NSManagedObjectContext` produces error `onError` closure is called.
     
     - parameter group: `dispatch_group_t` that will be used group calls to this method.
     - parameter maxChangedObjectsCount: Maximum changed objects count, that if exceeded will cause save.
     - parameter onError: A closure that will be called when `save()` function on the `NSManagedObjectContext` produces error.
     */
    public func saveWithGroup(group: dispatch_group_t, maxChangedObjectsCount: Int = 100, onError: (ErrorType) -> ()) {
        saveWithGroup(group,
                      maxChangedObjectsCount: maxChangedObjectsCount,
                      usingBlock: { try self.saveContextAndWait() },
                      onError: onError)
    }
    
    /**
     Returns sum of inserted, updated and deleted objects counts
     
     returns: `Int`: Changed objects count
     */
    var changedObjectsCount: Int {
        return insertedObjects.count + updatedObjects.count + deletedObjects.count
    }
    
    // MARK: - Helpers
    
    private func saveWithGroup(group: dispatch_group_t, maxChangedObjectsCount: Int = 100, usingBlock block: () throws -> (), onError: (ErrorType) -> ()) {
        guard changedObjectsCount < maxChangedObjectsCount else {
            guard self.hasChanges else { return }
            do { try block() }
            catch { onError(error) }
            return
        }
        let queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
        dispatch_group_notify(group, queue) {
            self.performBlockWithGroup(group) {
                guard self.hasChanges else { return }
                do { try block() }
                catch { onError(error) }
            }
        }
    }
    
    private func performBlockWithGroup(group: dispatch_group_t, block: () -> ()) {
        dispatch_group_enter(group)
        performBlock {
            block()
            dispatch_group_leave(group)
        }
    }
}
