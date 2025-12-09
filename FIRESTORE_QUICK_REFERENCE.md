# Firestore Quick Reference Card

## 🗂️ Collections Overview

### 1. `users` Collection
**Purpose:** Store user profiles (Citizens & Officials)

**Key Fields:**
- `uid` (string) - Firebase Auth User ID
- `name` (string) - Full name
- `email` (string) - Email address
- `username` (string) - Unique username ⚠️ **Indexed**
- `role` (string) - "citizen" or "official"
- `position` (string) - Official position (for officials)
- `address`, `contact`, `barangay`, `age` (strings) - Optional user info
- `createdAt`, `updatedAt` (timestamps)

**Document ID:** Firebase Auth UID

---

### 2. `reports` Collection
**Purpose:** Store citizen reports/issues

**Key Fields:**
- `reportId` (string) - Report ID
- `title` (string) - Report title
- `description` (string) - Detailed description
- `category` (string) - Category: "Garbage", "Noise", "Water", "Safety", "Road Damage", "Illegal Activities", "Other"
- `photos` (array) - Array of photo URLs
- `status` (string) - "Pending", "In Progress", "Solved"
- `createdBy` (string) - User UID ⚠️ **Indexed with createdAt**
- `createdAt`, `updatedAt` (timestamps)

**Document ID:** Auto-generated

**Indexes Needed:**
- `createdBy` + `createdAt` (descending)
- `createdAt` (descending)

---

### 3. `requests` Collection
**Purpose:** Store citizen requests (certificates, IDs, etc.)

**Key Fields:**
- `requestId` (string) - Request ID
- `type` (string) - Request type: "Barangay Certificate", "Barangay ID", "Clearance", "Indigency Certificate", "Business Permit", "Other"
- `purpose` (string) - Purpose of request
- `fullName` (string) - Requester's full name
- `proofUrl` (string) - Proof document image URL
- `status` (string) - "Pending", "Approved", "Rejected"
- `createdBy` (string) - User UID ⚠️ **Indexed with createdAt**
- `createdAt`, `updatedAt` (timestamps)

**Document ID:** Auto-generated

**Indexes Needed:**
- `createdBy` + `createdAt` (descending)
- `createdAt` (descending)

---

### 4. `announcements` Collection
**Purpose:** Store barangay announcements (created by officials)

**Key Fields:**
- `announcementId` (string) - Announcement ID
- `title` (string) - Announcement title
- `body` (string) - Announcement content
- `createdBy` (string) - Official's UID
- `createdAt` (timestamp) ⚠️ **Indexed**

**Document ID:** Auto-generated

**Indexes Needed:**
- `createdAt` (descending)

---

### 5. `notifications` Collection
**Purpose:** Store user notifications

**Key Fields:**
- `notificationId` (string) - Notification ID
- `toUid` (string) - Recipient's UID ⚠️ **Indexed with createdAt**
- `message` (string) - Notification message
- `type` (string) - "report_update" or "request_update"
- `read` (boolean) - Read status
- `createdAt` (timestamp)

**Document ID:** Auto-generated

**Indexes Needed:**
- `toUid` + `createdAt` (descending)

---

## 🔗 Field Mapping: Code ↔️ Firestore

### Registration Form → Users Collection

| Form Field | Firestore Field | Type |
|------------|-----------------|------|
| Full Name | `name` | string |
| Email | `email` | string |
| Username | `username` | string |
| Password | *(stored in Firebase Auth)* | - |
| Age | `age` | string |
| Contact | `contact` | string |
| Address | `address` | string |
| Barangay | `barangay` | string |
| Position (Official) | `position` | string |

### Report Form → Reports Collection

| Form Field | Firestore Field | Type |
|------------|-----------------|------|
| Category | `category` | string |
| Description | `description` | string |
| Photos | `photos` | array |
| User UID | `createdBy` | string |
| Status | `status` | string |

### Request Form → Requests Collection

| Form Field | Firestore Field | Type |
|------------|-----------------|------|
| Request Type | `type` | string |
| Purpose | `purpose` | string |
| Full Name | `fullName` | string |
| Proof Image | `proofUrl` | string |
| User UID | `createdBy` | string |
| Status | `status` | string |

---

## 🚀 Quick Setup Checklist

- [ ] Create Firestore Database
- [ ] Set up Security Rules (from FIREBASE_SETUP.md)
- [ ] Enable Authentication → Email/Password
- [ ] Create indexes (or let Firestore prompt you)
- [ ] Test registration → Check `users` collection
- [ ] Test report submission → Check `reports` collection
- [ ] Test request submission → Check `requests` collection

---

## 📊 Data Flow

```
User Registration
    ↓
Firebase Auth (creates user)
    ↓
Firestore: users/{uid} (creates profile)

User Submits Report
    ↓
Firestore: reports/{autoId} (creates report)

Official Updates Report Status
    ↓
Firestore: reports/{id} (updates status)
    ↓
Firestore: notifications/{autoId} (creates notification)

User Submits Request
    ↓
Firestore: requests/{autoId} (creates request)

Official Approves/Rejects Request
    ↓
Firestore: requests/{id} (updates status)
    ↓
Firestore: notifications/{autoId} (creates notification)
```

---

## ⚠️ Common Issues & Solutions

**Issue:** "Missing or insufficient permissions"
- **Solution:** Check Firestore Security Rules

**Issue:** "Index required" error
- **Solution:** Click the link in the error message to create the index automatically

**Issue:** Collections not appearing
- **Solution:** Collections are created automatically when data is written. Register a user first.

**Issue:** Username already exists error
- **Solution:** Check `users` collection for existing username. The app checks this automatically.

---

## 🔍 How to View Data in Firebase Console

1. Go to Firebase Console → Your Project
2. Click **"Firestore Database"** → **"Data"** tab
3. You'll see all collections listed
4. Click on a collection to see documents
5. Click on a document to see fields

**Tip:** Use the search bar to filter documents!


