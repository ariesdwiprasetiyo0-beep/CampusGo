import Foundation
import CoreData

enum StudentError: LocalizedError {
    case notFound
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Student profile not found"
        case .saveFailed:
            return "Failed to save student profile"
        }
    }
}

final class StudentRepositoryImpl: StudentRepository {
    private let context: NSManagedObjectContext
    private let keychain: KeychainService

    init(context: NSManagedObjectContext, keychain: KeychainService) {
        self.context = context
        self.keychain = keychain
    }

    func getProfile() async throws -> Student {
        return try await context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: "StudentEntity")
            request.fetchLimit = 1
            let results = try self.context.fetch(request)
            guard let entity = results.first else {
                throw StudentError.notFound
            }
            return Student(
                studentID: entity.value(forKey: "studentID") as? String ?? "",
                fullName: entity.value(forKey: "fullName") as? String ?? "",
                faculty: entity.value(forKey: "faculty") as? String ?? "",
                program: entity.value(forKey: "program") as? String ?? "",
                photoURL: nil,
                isActive: entity.value(forKey: "isActive") as? Bool ?? false
            )
        }
    }

    func saveProfile(_ student: Student) async throws {
        return try await context.perform {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "StudentEntity", into: self.context)
            entity.setValue(student.studentID, forKey: "studentID")
            entity.setValue(student.fullName, forKey: "fullName")
            entity.setValue(student.faculty, forKey: "faculty")
            entity.setValue(student.program, forKey: "program")
            entity.setValue(student.isActive, forKey: "isActive")

            if let photoURL = student.photoURL {
                try self.keychain.save(photoURL.absoluteString, for: "student_photo_url")
            }

            try self.context.save()
        }
    }
}
