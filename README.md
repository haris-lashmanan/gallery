# gallery

View random images and add your favourites

## Getting Started

In this project we use open source api to get random images with id and pagination.
- Source: https://pixabay.com/api/docs/

## Architecture & State Management
This project utilizes a MVVM (Model-View-ViewModel) architecture:
- **State Management:** `Provider` with `ChangeNotifier` 
- **Routing:** `go_router`
- **Networking:** `dio` 
- **Pagination:** `infinite_scroll_pagination`
- **Local Persistence:** `shared_preferences`

## API Key Setup
This project uses compile-time environment variables for security. You must provide a Pixabay API key to run the app.

1. Create a file named `.env.dev` in the root of the project for dev and `.env.prod` for production environment
2. Add your Pixabay API key:
   ```env
   API_URL=[https://pixabay.com/api/](https://pixabay.com/api/)
   API_KEY=your_actual_api_key_here
   IS_PROD=false
   
## Permission handler
We are using permission handler for saving the images locally.

## flutter_launcher_icons
With the above package updated static app icon with mine.

## Network handler
We also handle no-internet stage