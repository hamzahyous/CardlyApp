# CardlyApp

CardlyApp is an iOS application focused on simplifying how users recognize and manage their credit cards. The app is built to automatically detect cards using BIN recognition and Apple Vision, retrieve details such as issuer, network, and tier, and organize this information in an intuitive way. Backed by a Vapor API and PostgreSQL, CardlyApp is designed to evolve into a full-featured platform for managing cards and maximizing rewards.

## Current Capabilities
- Detects card BINs using camera input and Apple Vision for enhanced scanning  
- Retrieves and displays metadata (issuer, network, tier)  
- Stores user-added cards and links them to backend data  
- Uses a Vapor backend with PostgreSQL to handle card data and metadata lookups  
- Integrates with BIN lookup APIs for verification  

## Tech Stack
- **Frontend:** Swift, SwiftUI, Apple Vision  
- **Backend:** Vapor (Swift)  
- **Database:** PostgreSQL (Fluent ORM)  
- **APIs:** BIN Lookup API integration  

## Future Goals
- Add detailed rewards tracking and personalized recommendations  
- Build a polished dashboard for card management and usage insights  
- Implement user authentication to enable multi-device syncing  
- Introduce real-time analytics and dynamic card offers  
- Deploy backend to a scalable cloud environment for production use  

## Getting Started
1. Clone the repository:
   ```bash
   git clone https://github.com/hamzahyous/CardlyApp.git
   cd CardlyApp
