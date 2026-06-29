# Firestore Step-by-Step Visual Guide

## 🎯 Goal: Create Your First Collection in Firebase Console

This guide will walk you through creating the `users` collection manually (though it will be created automatically when you register).

---

## Step 1: Open Firebase Console

1. Go to: https://console.firebase.google.com/
2. Select your project: **"TellBarangay App"**
3. In the left sidebar, click: **"Firestore Database"**

---

## Step 2: Create the Users Collection

### Option A: Create Manually (Recommended for Learning)

1. **Click the "+ Start collection" button** (big blue button in the center)

2. **Collection ID:**
   - Type: `users`
   - Click **"Next"**

3. **Document ID:**
   - Choose: **"Auto-ID"** (or enter a test UID like `test123`)
   - Click **"Next"**

4. **Add Fields One by One:**

   Click **"Add field"** for each field below:

   | Field Name | Field Type | Value |
   |------------|------------|-------|
   | `uid` | string | `test123` |
   | `name` | string | `Test User` |
   | `email` | string | `test@example.com` |
   | `username` | string | `testuser` |
   | `role` | string | `citizen` |
   | `position` | string | *(leave empty)* |
   | `address` | string | *(leave empty)* |
   | `contact` | string | *(leave empty)* |
   | `barangay` | string | *(leave empty)* |
   | `age` | string | *(leave empty)* |
   | `createdAt` | timestamp | Click **"Set to current time"** |
   | `updatedAt` | timestamp | Click **"Set to current time"** |

5. **Click "Save"**

   ✅ You should now see the `users` collection with your test document!

### Option B: Let the App Create It (Easier)

1. **Just run your app** and register a user
2. The collection will be created automatically!
3. Go back to Firebase Console to see it

---

## Step 3: Verify the Collection Structure

After creating, you should see:

```
📁 users (collection)
  └── 📄 test123 (or auto-generated ID)
      ├── uid: "test123"
      ├── name: "Test User"
      ├── email: "test@example.com"
      ├── username: "testuser"
      ├── role: "citizen"
      ├── position: ""
      ├── address: ""
      ├── contact: ""
      ├── barangay: ""
      ├── age: ""
      ├── createdAt: [timestamp]
      └── updatedAt: [timestamp]
```

---

## Step 4: Create Index for Username Lookup

**Why?** Your app checks if username exists, which requires an index.

1. Go to **"Indexes"** tab in Firestore Database
2. Click **"Create Index"**
3. Fill in:
   - **Collection ID:** `users`
   - **Fields to index:**
     - Field: `username`
     - Order: **Ascending**
   - **Query scope:** Collection
4. Click **"Create"**
5. Wait for index to build (may take a few minutes)

---

## Step 5: Test with Your App

1. **Run your Flutter app:**
   ```bash
   flutter run
   ```

2. **Register a new user:**
   - Fill in the registration form
   - Submit

3. **Check Firebase Console:**
   - Go to Firestore Database → Data tab
   - Click on `users` collection
   - You should see a new document with the Firebase Auth UID as the document ID
   - All fields should match what you entered in the form!

---

## 📝 Creating Other Collections

The other collections (`reports`, `requests`, `announcements`, `notifications`) will be created automatically when your app writes data to them. You don't need to create them manually!

However, if you want to create them manually for testing:

### Reports Collection:
- Collection ID: `reports`
- Fields: `reportId`, `title`, `description`, `category`, `photos` (array), `status`, `createdBy`, `createdAt`, `updatedAt`

### Requests Collection:
- Collection ID: `requests`
- Fields: `requestId`, `type`, `purpose`, `fullName`, `proofUrl`, `status`, `createdBy`, `createdAt`, `updatedAt`

### Announcements Collection:
- Collection ID: `announcements`
- Fields: `announcementId`, `title`, `body`, `createdBy`, `createdAt`

### Notifications Collection:
- Collection ID: `notifications`
- Fields: `notificationId`, `toUid`, `message`, `type`, `read`, `createdAt`

---

## 🎨 Visual Guide: What You'll See

### In Firebase Console:

```
Firestore Database
├── 📁 users
│   ├── 📄 abc123xyz (document ID = Firebase Auth UID)
│   │   ├── uid: "abc123xyz"
│   │   ├── name: "Juan Dela Cruz"
│   │   ├── email: "juan@example.com"
│   │   ├── username: "juandelacruz"
│   │   └── ... (other fields)
│   └── 📄 def456uvw
│       └── ... (another user)
│
├── 📁 reports
│   ├── 📄 RPT-1234567890
│   │   ├── reportId: "RPT-1234567890"
│   │   ├── title: "Uncollected garbage"
│   │   ├── category: "Garbage"
│   │   └── ... (other fields)
│   └── ... (more reports)
│
├── 📁 requests
│   ├── 📄 REQ-1234567890
│   │   ├── requestId: "REQ-1234567890"
│   │   ├── type: "Barangay Certificate"
│   │   └── ... (other fields)
│   └── ... (more requests)
│
├── 📁 announcements
│   └── ... (announcements)
│
└── 📁 notifications
    └── ... (notifications)
```

---

## ✅ Checklist

- [ ] Firestore Database created
- [ ] Users collection created (manually or automatically)
- [ ] Username index created
- [ ] Test user registered from app
- [ ] User document appears in Firebase Console
- [ ] All fields match registration form data

---

## 🆘 Troubleshooting

**Q: I don't see the collection after registering?**
- A: Refresh the Firebase Console page
- A: Make sure you're looking at the correct project
- A: Check if there were any errors in your app console

**Q: Fields are missing?**
- A: Check your `DatabaseService.createUserProfile()` method
- A: Make sure all fields are being passed from registration form

**Q: Can't create index?**
- A: Wait a few minutes - indexes take time to build
- A: Check if index already exists
- A: The app will prompt you to create indexes when needed

**Q: Getting permission errors?**
- A: Check Firestore Security Rules
- A: Make sure rules allow create operations

---

## 🎓 Next Steps

1. ✅ Create users collection
2. ✅ Test registration
3. ✅ Create reports collection (by submitting a report)
4. ✅ Create requests collection (by submitting a request)
5. ✅ Set up all indexes
6. ✅ Test full app flow

**Remember:** Collections are created automatically when your app writes data. You only need to create them manually if you want to see the structure first!



