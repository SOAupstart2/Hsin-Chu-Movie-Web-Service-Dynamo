# Hsin-Chu-Movie-Web-Service
A simple version of a web service that scrapes cinema show times in Hsinchu using the [kandianying](https://github.com/SOAupstart2/Hsinchu_Movie) gem.

Handles:
- GET /
  - Returns message indicating server is alive and links to Github repo.
- GET /api/v1/list-movies/
  - Returns JSON array with each element representing a cinema, with information about current films on display and show times.
- GET /api/v1/list-movies/:cinema_id.json
  - Takes cinema_id (Test with '0005' & '0012' for cinemas in Hsinchu)
  - Returns JSON object representing specified cinema, with information about current films on display and show times.
