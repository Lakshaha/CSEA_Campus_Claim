# 🚗 Campus Commute

Campus Commute is a Flutter + Firebase application designed to help campus users share and request rides efficiently.  
Users can create ride requests, express interest in available rides, and manage their own ride listings with real-time updates.

---

## ✨ Features

### 🔍 Browse Ride Requests
- View all upcoming ride requests
- Only shows rides with available capacity
- Sorted by departure time

### 🙋 Mark Interest
- Users can mark themselves as *Interested* in a ride
- Interested users are stored in a Firestore subcollection
- Prevents duplicate interest entries

### 🧑‍💼 My Requests (Owner View)
- View only the ride requests created by the logged-in user
- See all interested users for each request
- Real-time updates using Firestore streams

### ⏱️ Auto-hide Past Rides
- Requests automatically disappear after the departure time
- No manual deletion required
- Keeps Firestore data intact for future history features

### 🔐 Authentication
- Firebase Authentication (Google Sign-In supported)
- Secure user identification using UID

---

## 🛠️ Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase Firestore
- **Authentication:** Firebase Auth
- **State Management:** StreamBuilder (real-time updates)
- **Date Formatting:** `intl` package

---
