# Hsin-Chu-Movie-Web-Service [ ![Codeship Status for SOAupstart2/Hsin-Chu-Movie-Web-Service-Dynamo](https://codeship.com/projects/55707910-82eb-0133-c213-7676354306ac/status?branch=master)](https://codeship.com/projects/121690)
A simple version of a web service that scrapes cinema show times in Hsinchu using the [kandianying](https://github.com/SOAupstart2/Hsinchu_Movie) gem.

Handles:
- GET `/` or `/api/v1`
  - Returns message indicating server is alive and with links to Github repo.
- GET `/api/v1/:cinema/:language/:theater_id/movies`
  - Takes a `:cinema:`, one of `ambassador` or `vieshow`
  - Takes a `:language`, either `english` or `chinese`
  - Takes a `:theater_id`
    - If `:cinema` == `vieshow`
      - `:theater_id` ranges from `1` to `14`. For a cinema located in Hsinchu, use `5` or `12`.
    - If `:cinema` == `ambassador`
      - `:theater_id`'s are unique. For the Ambassador cinema in Hsinchu, use `38897fa9-094f-4e63-9d6d-c52408438cb6` or a substring of that.
  - Returns a list of current films on display at specified cinema in the language requested.
- GET `/api/v1/:cinema/:language/:theater_id.json`
  - `:cinema`, `:language`, `:theater_id` are same as above.
  - Returns JSON object representing specified cinema, with information about current films on display and show times in the language requested.
- POST `/api/v1/users`
  - Store the location and language preference for user.
  - Redirect to the page which shows the data input.
  - Example: curl -v -d '{"location":"hsinchu","language":"english"}' http://localhost:9292/api/v1/users
- GET `/api/v1/users/:id`
  - You get your `:id` after the post request to `/api/v1/users`.
  - You can specify a `film_name` or `date_time` as part of your request.
  - Sample `film_name` request:
    - GET `/api/v1/users/1?film_name=007`
      - This would return the viewing times for the found film in the language you saved and at the cinemas in the location saved.
  - Sample `date_time` request:
    - GET `/api/v1/users/1?date_time=Dec 13 18:00`
      - This would return the viewing times for films shown after the specified time on specified date in the language you saved and at the cinemas in the location saved.
    - GET `/api/v1/users/1?date_time=18:00`
      - This would return the viewing times for films shown after the specified time on current date in the language you saved and at the cinemas in the location saved.
