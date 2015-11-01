# Hsin-Chu-Movie-Web-Service [ ![Codeship Status for SOAupstart2/Hsin-Chu-Movie-Web-Service](https://codeship.com/projects/e9879d20-6210-0133-a4af-7e706f11b58d/status?branch=master)](https://codeship.com/projects/112582)
A simple version of a web service that scrapes cinema show times in Hsinchu using the [kandianying](https://github.com/SOAupstart2/Hsinchu_Movie) gem.

Handles:
- GET /
  - Returns message indicating server is alive and with links to Github repo.
- GET /api/v1/cinema/:theater_id/movies
  - Takes theater_id (Test with '5' & '12' for cinemas in Hsinchu)
  - Returns a list of current films on display at specified cinema.
- GET /api/v1/cinema/:theater_id.json
  - Takes theater_id (Test with '5' & '12' for cinemas in Hsinchu)
  - Returns JSON object representing specified cinema, with information about current films on display and show times.
