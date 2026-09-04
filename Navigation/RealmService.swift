//
//  RealmService.swift
//  Navigation
//

import Foundation
import RealmSwift

class RealmService {
    static let shared = RealmService()
    
    private var realm: Realm?
    
    private init() {
        setupRealm()
    }
    
    // MARK: - Setup
    
    private func setupRealm() {
        let encryptionKey = KeychainManager.shared.getOrCreateEncryptionKey()
        
        let config = Realm.Configuration(
            encryptionKey: encryptionKey,
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    print("🔄 Миграция Realm: версия \(oldSchemaVersion) → 1")
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
        
        do {
            realm = try Realm()
            print("✅ Realm инициализирован с шифрованием")
            print("📁 Путь к базе: \(realm?.configuration.fileURL?.absoluteString ?? "неизвестен")")
        } catch {
            print("⚠️ Ошибка открытия Realm, удаляем старую базу и пересоздаём: \(error)")
            deleteRealmFiles()
            // Сбрасываем ключ и генерируем новый
            KeychainManager.shared.deleteKey()
            let newKey = KeychainManager.shared.getOrCreateEncryptionKey()
            let newConfig = Realm.Configuration(
                encryptionKey: newKey,
                schemaVersion: 1
            )
            Realm.Configuration.defaultConfiguration = newConfig
            do {
                realm = try Realm()
                print("✅ Realm пересоздан с новым ключом шифрования")
            } catch {
                print("❌ Критическая ошибка Realm: \(error)")
            }
        }
    }
    
    // MARK: - Helpers
    
    private func deleteRealmFiles() {
        guard let realmURL = Realm.Configuration.defaultConfiguration.fileURL else { return }
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        realmURLs.forEach { url in
            do {
                try FileManager.default.removeItem(at: url)
                print("🗑️ Удалён файл: \(url.lastPathComponent)")
            } catch {
                print("⚠️ Не удалось удалить \(url.lastPathComponent): \(error)")
            }
        }
    }
    
    // MARK: - CREATE
    
    func saveQuote(text: String, category: String) {
        guard let realm = realm else {
            print("❌ Realm не инициализирован")
            return
        }
        
        let quote = Quote(text: text, category: category)
        
        do {
            try realm.write {
                realm.add(quote, update: .modified)
                
                if let existingCategory = realm.object(ofType: Category.self, forPrimaryKey: category) {
                    if !existingCategory.quotes.contains(where: { $0.text == text }) {
                        existingCategory.quotes.append(quote)
                    }
                } else {
                    let newCategory = Category(name: category)
                    newCategory.quotes.append(quote)
                    realm.add(newCategory, update: .modified)
                }
            }
            print("✅ Цитата сохранена (зашифровано)")
        } catch {
            print("❌ Ошибка сохранения цитаты: \(error)")
        }
    }
    
    // MARK: - READ
    
    func getAllQuotes() -> Results<Quote>? {
        guard let realm = realm else { return nil }
        return realm.objects(Quote.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    func getAllCategories() -> Results<Category>? {
        guard let realm = realm else { return nil }
        return realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
    }
    
    func getQuotes(for category: String) -> Results<Quote>? {
        guard let realm = realm else { return nil }
        return realm.objects(Quote.self)
            .filter("category == %@", category)
            .sorted(byKeyPath: "createdAt", ascending: false)
    }
}
