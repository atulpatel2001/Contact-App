# Flutter Contact App

This is a **Flutter Contact Management Application** that allows users to **add, update, delete, and view contacts**. The app supports **Hive** (NoSQL) and **SQLite** databases for storage.

## Features

- **Add New Contacts**: Users can create and store new contacts.
- **Edit Contacts**: Update existing contact details.
- **Delete Contacts**: Remove contacts from the database.
- **View Contacts**: List all saved contacts.
- **Persist Data**: Contacts remain saved using **Hive** and **SQLite**.

## Technologies Used

- **Flutter** - UI Development
- **Hive** - Lightweight NoSQL database
- **SQLite** - Local relational database
- 
## Installation & Setup

### **Prerequisites**
- Install **Flutter SDK**.
- Install **Android Studio** or **VS Code**.
- Ensure **Android Emulator** or a physical device is available.

### **Clone the Repository**
```sh
 git clone https://github.com/your-repo/flutter-contact-app.git
 cd flutter-contact-app
```

### **Install Dependencies**
```sh
 flutter pub get
```

### **Run the Application**
For Android:
```sh
 flutter run
```
For iOS:
```sh
 flutter run --no-sound-null-safety
```

## Database Configuration

### **Using Hive**
- Import Hive:
```dart
import 'package:hive/hive.dart';
```
- Open Hive Box:
```dart
var box = await Hive.openBox('contacts');
```
- Add a Contact:
```dart
box.put('contact1', {'name': 'John Doe', 'phone': '1234567890'});
```
- Retrieve Contacts:
```dart
var contact = box.get('contact1');
```

### **Using SQLite**
- Import SQLite Package:
```dart
import 'package:sqflite/sqflite.dart';
```
- Create Database:
```dart
Database db = await openDatabase(
  'contacts.db',
  version: 1,
  onCreate: (db, version) {
    return db.execute('CREATE TABLE contacts (id INTEGER PRIMARY KEY, name TEXT, phone TEXT)');
  },
);
```
- Insert Contact:
```dart
await db.insert('contacts', {'name': 'Jane Doe', 'phone': '9876543210'});
```
- Fetch Contacts:
```dart
List<Map<String, dynamic>> contacts = await db.query('contacts');
```

## Future Enhancements
- Implement contact grouping.
- Add cloud synchronization.
- Introduce contact sharing functionality.

---
This app provides an efficient way to manage personal and professional contacts using **Flutter, Hive, and SQLite**. 🚀

