# Firebase Setup Guide for TellBarangay App

## Step 1: Create Firestore Database

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project "TellBarangay App"
3. Click on **"Firestore Database"** in the left sidebar
4. Click **"Create database"** button
5. Choose **"Start in test mode"** (for development)
6. Select your preferred location (choose closest to your users)
7. Click **"Enable"**

## Step 2: Set Up Firestore Security Rules

After creating the database, you need to set up security rules:

1. In Firestore Database, click on the **"Rules"** tab
2. Replace the default rules with the following:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - users can read their own data, write during registration
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
      allow create: if request.auth != null;
    }
    
    // Reports collection - authenticated users can create, read their own
    match /reports/{reportId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        (resource.data.createdBy == request.auth.uid || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'official');
    }
    
    // Requests collection - authenticated users can create, read their own
    match /requests/{requestId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        (resource.data.createdBy == request.auth.uid || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'official');
    }
    
    // Announcements collection - officials can create/update/delete, all can read
    match /announcements/{announcementId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'official';
    }
    
    // Notifications collection - users can read their own notifications
    match /notifications/{notificationId} {
      allow read: if request.auth != null && 
        resource.data.toUid == request.auth.uid;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        resource.data.toUid == request.auth.uid;
    }
  }
}
```

3. Click **"Publish"** to save the rules

## Step 3: Enable Authentication

1. In Firebase Console, click on **"Authentication"** in the left sidebar
2. Click **"Get started"** if you haven't enabled it yet
3. Go to the **"Sign-in method"** tab
4. Enable **"Email/Password"** authentication:
   - Click on "Email/Password"
   - Toggle "Enable" to ON
   - Click "Save"

## Step 4: Verify Your Setup

After completing the above steps:

1. **Run your Flutter app**: `flutter run`
2. **Try to register a new user**:
   - Go to Registration page
   - Fill in all required fields
   - Submit the form
3. **Check Firebase Console**:
   - Go to **Authentication** → **Users** tab - you should see the new user
   - Go to **Firestore Database** → **Data** tab - you should see a `users` collection with the user's profile

## Troubleshooting

### Error: "Registration failed: [firestore/permission-denied]"
- **Solution**: Make sure you've published the Firestore security rules (Step 2)

### Error: "Email is already registered"
- **Solution**: This is correct behavior - the email already exists in Firebase Auth. Try a different email or login with existing credentials.

### Error: "Username already exists"
- **Solution**: The username is already taken. Choose a different username.

### No data appears in Firestore after registration
- **Check**: Make sure you're looking at the correct project in Firebase Console
- **Check**: Refresh the Firestore Data view
- **Check**: Look for a `users` collection - it should be created automatically

### Network errors
- **Solution**: Make sure your device/emulator has internet connection
- **Solution**: Check if Firebase is properly initialized in your app (check `firebase_options.dart` exists)

## Collections Structure

Your Firestore database will have these collections:

- **users** - User profiles (created during registration)
- **reports** - Citizen reports (created when users submit reports)
- **requests** - Citizen requests (created when users submit requests)
- **announcements** - Barangay announcements (created by officials)
- **notifications** - User notifications (created automatically)

## Next Steps

Once registration works:
1. Test login functionality
2. Test creating reports/requests
3. Test official features (approving requests, updating report status)
4. Check that data appears correctly in Firestore

## Important Notes

- **Test Mode**: The initial rules allow all reads/writes for 30 days. After that, you must have proper security rules.
- **Production**: Before deploying to production, review and tighten security rules based on your needs.
- **Indexes**: If you get index errors, Firebase will provide a link to create the required indexes automatically.


