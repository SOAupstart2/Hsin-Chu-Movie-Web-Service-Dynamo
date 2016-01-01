# Hsin-Chu-Movie-Web-Service [ ![Codeship Status for SOAupstart2/Hsin-Chu-Movie-Web-Service-Dynamo](https://codeship.com/projects/55707910-82eb-0133-c213-7676354306ac/status?branch=master)](https://codeship.com/projects/121690)
A simple version of a web service that scrapes cinema show times in Taiwan using the [kandianying](https://github.com/SOAupstart2/Hsinchu_Movie) gem.

## Routes

Handles:
- GET `/` or `/api/v1`
  - Returns message indicating server is alive and with links to Github repo.
- GET `/api/v1/:cinema/:language/:theater_id/movies`
  - Takes a `:cinema:`, one of `ambassador` or `vieshow`
  - Takes a `:language`, either `english` or `chinese`
  - Takes a `:theater_id`: See [below](#locations) for details.
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
  - You can specify a `name` or `time` as part of your request.
  - Sample `name` request:
    - GET `/api/v1/users/3a4265e2-1ab8-463e-acce-c98d525867c0?name=007`
      - This would return the viewing times for the found film in the language you saved and at the cinemas in the location saved.
  - Sample `time` requests:
    - GET `/api/v1/users/3a4265e2-1ab8-463e-acce-c98d525867c0?time=Dec 13 18:00`
      - This would return the viewing times for films shown after the specified time on specified date in the language you saved and at the cinemas in the location saved.
    - GET `/api/v1/users/3a4265e2-1ab8-463e-acce-c98d525867c0?time=18:00`
      - This would return the viewing times for films shown after the specified time on current date in the language you saved and at the cinemas in the location saved.

## Locations

Location          | Vieshow Codes    | Ambassador Codes (Use full code or substring)
----------------- | ---------------- | ----------------------------------------------
`hsinchu`         | `05`, `12`       | `38897fa9-094f-4e63-9d6d-c52408438cb6`
`kaohsiung`       | `01`             | `ec07626b-b382-474e-be39-ad45eac5cd1c`
`kinmen`          | -                | `65db51ce-3ad5-48d8-8e32-7e872e56aa4a`
`new taipei city` | `10`             | `357633f4-36a4-428d-8ac8-dee3428a5919`, `3301d822-b385-4aa8-a9eb-aa59d58e95c9`
`pingtung`        | -                | `41aae717-4464-49f4-ac26-fec2d16acbd6`
`taichung`        | `02`, `03`, `11` | -
`tainan`          | `04`, `13`       | `ace1fe19-3d7d-4b7c-8fbe-04897cbed08c`
`taipei`          | `06`, `08`, `09` | `84b87b82-b936-4a39-b91f-e88328d33b4e`, `5c2d4697-7f54-4955-800c-7b3ad782582c`, `453b2966-f7c2-44a9-b2eb-687493855d0e`, `9383c5fa-b4f3-4ba8-ba7a-c25c7df95fd0`
`toufen`          | `14`             | -
