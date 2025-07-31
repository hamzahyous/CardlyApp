# CardlyApp

I designed Cardly with the intent of making it easier to pull rewards information for cards that a user had. The goal was that upon entering a store, Cardly would automatically reccomend the optimal card for a transaction. This would involve storing user cards, along comprehensive database of all cards to pick from, and their rewards information. I also integrated Apple Vision for OCR, pulling scanned card numbers and extracting the bin for use. The goal is to expand the app further, building a full-featured platform for managing cards and maximizing rewards.

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
