# CardlyApp

CardlyApp is a modern iOS application designed to streamline card recognition and management. The project integrates a SwiftUI front end with a Vapor backend to provide a seamless experience for detecting, storing, and managing credit cards and their associated metadata.

## Features
- **Card Scanning** – Detects card BINs and retrieves issuer/network/tier details.
- **Vapor Backend** – Manages card data with a PostgreSQL database.
- **User Card Storage** – Allows users to add and manage their own cards.
- **API Integration** – Supports BIN metadata lookups and card verification.

## Tech Stack
- **Frontend:** Swift, SwiftUI
- **Backend:** Vapor (Swift)
- **Database:** PostgreSQL (via Fluent ORM)
- **APIs:** BIN Lookup API integration

## Getting Started

### Prerequisites
- Xcode 15+ (for the iOS app)
- Swift 6.0+
- PostgreSQL (for local backend development)
- Vapor toolbox (`brew install vapor`)

### Running the App
1. Clone this repository:
   ```bash
   git clone https://github.com/hamzahyous/CardlyApp.git
   cd CardlyApp
