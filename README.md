# 🃏 Multiplayer Card Game

A scalable Flutter application demonstrating a **real-time multiplayer card game** with offline AI support, secure backend validation, and cross-platform gameplay using **Flutter**, **GetX**, **Supabase Realtime**, and **PostgreSQL**.

---

## ✨ Features

### 🎮 Gameplay

- Real-time multiplayer game rooms
- Offline mode with intelligent AI players
- Automatic card shuffling and dealing
- Hidden Joker mechanic
- Draw from Open or Closed pile
- Drag & Drop card interactions
- Smart card grouping
- Automatic card sorting
- Turn timer
- Winner validation

---

### 🃏 Card Rules

Players must arrange **13 cards** into:

```
3 Cards
3 Cards
3 Cards
4 Cards
```

Game uses **Sets only**.

A valid set consists of cards having the **same rank**.

Example

```
8♠ 8♥ 8♦
```

or

```
K♠ K♥ K♦ K♣
```

Unlock the **Hidden Joker** by revealing a natural **Four-of-a-Kind**.

---

### 🤖 AI Players

- Smart draw decisions
- Intelligent discard strategy
- Rank-based set detection
- Automatic grouping
- Human-like gameplay

---

### 🌐 Multiplayer

- Supabase Realtime synchronization
- Private game rooms
- Live player status
- Turn synchronization
- Reconnect support
- Live rankings

---

### 🔒 Secure Backend

- PostgreSQL RPC Functions
- Row Level Security (RLS)
- Server-side winner validation
- Secure game state management
- Cheat prevention

---

## 🧠 Architecture

This project follows a **Feature-First Clean Architecture** with **GetX** for scalable state management.

### 🔁 Application Flow

```
Flutter UI
      │
GetX Providers
      │
Repositories
      │
Supabase Services
      │
Realtime + PostgreSQL RPC
```

---

## 🛠 Tech Stack

- **Flutter**
- **Dart**
- **GetX**
- **Supabase**
- **PostgreSQL**
- **Supabase Realtime**
- **Supabase Auth**

---

## ⚡ Key Highlights

- Cross-platform (Android, iOS)
- Real-time multiplayer gameplay
- Intelligent offline AI opponents
- Secure backend validation
- Drag & Drop card interactions
- Hidden Joker gameplay mechanic
- Feature-First Clean Architecture
- Responsive UI with smooth animations

---

## ▶️ Getting Started

```bash
git clone https://github.com/YOUR_USERNAME/card-game.git

cd card-game

flutter pub get

flutter run
```

---

## 🎯 What This Project Demonstrates

- Real-time multiplayer game development
- Game state synchronization
- Complex game logic implementation
- AI decision-making algorithms
- PostgreSQL RPC & Row Level Security
- GetX state management
- Responsive Flutter UI
- Feature-based project architecture

---

## 📌 Future Improvements

- Tournament mode
- Friends & Invitations
- Voice chat
- Spectator mode
- Replay system
- Player statistics
- Achievements
- Matchmaking

---

## 👨‍💻 Author

**Vijay Pamu**

- GitHub: https://github.com/Vjy-p
- LinkedIn: https://www.linkedin.com/in/vijay-p-018930115/

---

## ⭐ Support

If you found this project interesting, consider giving it a ⭐ on GitHub!
