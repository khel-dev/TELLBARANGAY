# 🔥 Firestore Database Setup - Step by Step Guide (Tagalog)

## ⚠️ IMPORTANT: Bago mo i-run ang app, gawin muna ito!

Ang code ay tama na, pero **kailangan mo munang i-setup ang Firestore Security Rules** para makapag-save ng data.

---

## 📋 STEP 1: Pumunta sa Firebase Console

1. **Buksan ang browser** at pumunta sa: https://console.firebase.google.com/
2. **Piliin ang project mo** - "TellBarangay App" (o kung ano ang pangalan ng project mo)
3. Sa **left sidebar**, click ang **"Firestore Database"**

---

## 📋 STEP 2: I-check kung may Firestore Database na

### Kung WALA PA:
1. Click ang **"Create database"** button
2. Piliin ang **"Start in test mode"** (para sa development/testing)
3. Piliin ang **location** (pinakamalapit sa users mo - example: `asia-southeast1` para sa Philippines)
4. Click **"Enable"**
5. Hintayin na matapos ang setup (mga 1-2 minutes)

### Kung MAYROON NA:
- Skip to STEP 3

---

## 📋 STEP 3: I-setup ang Security Rules (ITO ANG PINAKA-IMPORTANTE!)

**Bakit kailangan?** 
- Para payagan ang app mo na mag-save ng reports at requests sa Firestore
- Kung hindi mo ito gawin, hindi makakapag-save ang app mo

### Paano gawin:

1. Sa Firestore Database page, **click ang "Rules" tab** (sa taas, katabi ng "Data" tab)

2. **I-copy ang code na ito** (lahat):

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

3. **I-delete ang lahat ng text** sa Rules editor
4. **I-paste ang code** na kinopya mo
5. **Click ang "Publish" button** (sa taas ng editor)
6. Hintayin na mag-load (mga 10-30 seconds)
7. Dapat may message na **"Rules published successfully"**

---

## 📋 STEP 4: I-check ang Authentication

1. Sa **left sidebar**, click ang **"Authentication"**
2. Click ang **"Sign-in method"** tab
3. **I-check kung naka-enable ang "Email/Password"**:
   - Kung naka-enable na (may checkmark) → OK, skip to STEP 5
   - Kung hindi pa → Click ang "Email/Password" → Toggle "Enable" to ON → Click "Save"

---

## 📋 STEP 5: I-verify na tama ang setup

### Option A: Manual Check
1. Sa Firestore Database, click ang **"Data" tab**
2. Dapat makita mo ang **"users" collection** (kung may nag-register na)
3. Dapat walang error message

### Option B: Test sa App
1. **I-run ang app mo**: `flutter run`
2. **Mag-register** ng bagong user
3. **Mag-login** gamit ang credentials
4. **Mag-submit ng report** o **request**
5. **Bumalik sa Firebase Console** → Firestore Database → Data tab
6. **I-refresh ang page** (F5)
7. Dapat makita mo:
   - **"users" collection** - may document na may UID ng user
   - **"reports" collection** - may document kung nag-submit ka ng report
   - **"requests" collection** - may document kung nag-submit ka ng request

---

## ❌ TROUBLESHOOTING: Kung hindi nag-save ang data

### Problem 1: "Permission denied" error
**Solution:**
- Bumalik sa STEP 3
- I-verify na na-publish mo ang Security Rules
- I-check na tama ang code (walang typo)

### Problem 2: Walang lumalabas na data sa Firestore
**Solution:**
1. I-check kung naka-login ka sa app
2. I-check kung may internet connection
3. I-refresh ang Firebase Console page (F5)
4. I-check ang "Data" tab (hindi "Rules" tab)

### Problem 3: "Index needed" error
**Solution:**
- Kapag nag-run ka ng app at may error na "index needed", click ang link sa error message
- I-automatically mag-create ang Firebase ng index
- Hintayin na matapos (mga 1-5 minutes)
- I-run ulit ang app

### Problem 4: Hindi makapag-upload ng images
**Solution:**
1. Sa Firebase Console, click ang **"Storage"** sa left sidebar
2. Kung wala pa, click **"Get started"**
3. Piliin ang **"Start in test mode"**
4. Click **"Done"**

---

## ✅ CHECKLIST: Bago mo i-test ang app

- [ ] May Firestore Database na (created o existing)
- [ ] Na-setup ang Security Rules (STEP 3)
- [ ] Na-publish ang Security Rules
- [ ] Naka-enable ang Email/Password authentication
- [ ] Na-run ang `flutter pub get` (para sa image_picker package)
- [ ] May internet connection

---

## 🎯 Ano ang mangyayari kapag tama na lahat:

1. **Kapag nag-register ka:**
   - Makikita mo sa Firestore → Data tab → `users` collection → may bagong document

2. **Kapag nag-submit ka ng report:**
   - Makikita mo sa Firestore → Data tab → `reports` collection → may bagong document
   - May fields: `title`, `description`, `category`, `photos`, `status`, `createdBy`, etc.

3. **Kapag nag-submit ka ng request:**
   - Makikita mo sa Firestore → Data tab → `requests` collection → may bagong document
   - May fields: `type`, `purpose`, `fullName`, `proofUrl`, `status`, `createdBy`, etc.

---

## 📝 IMPORTANT NOTES:

1. **Collections ay auto-created** - Hindi mo kailangan manually gumawa ng collections. Gagawin ito ng app kapag nag-save ka ng data.

2. **Security Rules ay CRITICAL** - Kung hindi mo ito gawin, hindi makakapag-save ang app mo.

3. **Test Mode** - Ang security rules na binigay ko ay para sa development/testing. Bago mo i-deploy sa production, i-review at i-tighten ang rules.

4. **Indexes** - Kapag may error na "index needed", click lang ang link at auto-create ng Firebase.

---

## 🆘 Kung may problema pa rin:

1. I-check ang console logs sa app (para makita ang exact error)
2. I-check ang Firebase Console → Firestore Database → Usage tab (para makita kung may errors)
3. I-verify na tama ang `firebase_options.dart` file mo
4. I-try mag-logout at mag-login ulit sa app

---

**Good luck! 🚀**


