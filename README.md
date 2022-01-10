# Elibrary

## Features

  1. List of Labels is seeded in DB with 20 labels+. User cannot change the labels table.
  2. User can create new Book, new Song.
  3. User can tag a label to any books, 1 book can only be tagged to 1 label, existing tagged label of the book need to be replaced.
  4. User can tag a label to any songs, 1 song can only be tagged to 1 label, existing tagged label of the song need to be replaced.
  5. User can tag a label to any combo book+song, 1 combo book+song can only be tagged to 1 label, existing tagged label of the combo need to be replaced (shouldn’t replace the label of individual book or individual song).
  6. A label can be reused multiple times.
  7. A search page: User can select a book, a song, or both to search for the label. There should be only 1 label or no label in the result. (It’s a label of individual book or individual song, or the label of a combo).
  8. List 10 most popular labels that are used to tag most.
  9. Lower case `name` is unique for each tables.
  10. `name` has max 100 characters, `description` is optional and has max 200 characters.
  11. No authentication required, anyone can use the webapp.
  12. No need the update or delete function for books, songs.

## Tech Stack Used

  * Phoenix framework v1.5.13 + Elixir/Erlang (Elixir 1.12.1 with Erlang/OTP 22).
  * Phoenix LiveView v0.17.5.
  * Gigalixir for releasing live production (built on top of Heroku).
  * PostgreSQL version 10.17.

## To start your Phoenix server

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `iex -S mix phx.server`
  * Run unit tests: `mix test`

## Database Design

  ![alt text](../main/assets/static/images/system_design.JPG)

  * Size per label:
    * id: 8 bytes
    * name: 100 bytes
    * description: 200 bytes
    * Total: ~0.3 kb

  * Size per song:
    * id: 8 bytes
    * name: 100 bytes
    * description: 200 bytes
    * label_id: 8 bytes
    * Total: ~0.3 kb

  * Size per book:
    * id: 8 bytes
    * name: 100 bytes
    * description: 200 bytes
    * label_id: 8 bytes
    * Total: ~0.3 kb

  * Size per combo:
    * id: 8 bytes
    * name: 100 bytes
    * song_id: 8 bytes
    * book_id: 8 bytes
    * label_id: 8 bytes
    * Total: ~0.13 kb

## System Design

  * Monolithic Architecture

  ![alt text](../main/assets/static/images/db_design.JPG)

  * Why using this architecture?

    * Advantage:
      - Easier and Faster Development.

    * Disadvantage:
      - Development speed go down when get large.
      - Hard to scale.

## Search engine

  * I decide to design a search engine directly from database because some reasons:
    - Ensure data consistency.
    - Fast when using with index.

  * So, first of all, we have to choose an index type fit with searching, `Inverted Index` is the best choice for searching.
    - `Gin`: fast when query, slower when modify data.
    - `Gist`: slower than `gin` when query and faster when modify data.

  * And we've got some functions work well when using with gin index:
    * `gin` + `string_to_array`: has some disadvantage
      - Only work with searching word by word and 
      - Not work with stop-word such as: `and`, `or`, `the` and stemming word such as: `teach` `teaching` `teaches`.
    * `gin` + `to_tsvector`: more better
      - work well with stop-word and stemming
      - But only work when searching word by word.
    * `gin` + `pg_trgm` + `Like` operator: best solution
      - Work well with stop-word and stemming.
      - Work without a complete word.
      - Have a few functions for supporting to calculate matching rate.

  * Summary, we have `Gin` + `pg_trgm` + `Like` operator for searching engine.

## Scale Solutions

  * Horizontal scaling or Vertical scaling with cloud elasticity.
    * Choosing the appropriate solution for the situation.

  * Finding the bottlenecks:
    * `High traffic`: Traffic is not evenly distributed
      -> using `load balancer` to balance the number of request to server, but it only works with multiple server.

    * `At the code level` and `Config and Set up` level: Optimized code, fix config and set up.

    * `Query Performance`: Have some solutions:
      * Using `caching` strategy fit with the situation:
        - `Cache aside`: read from cache, write directly to db -> work best with read heavy but data in cache inconsistency.
        - `Read-through`:  read from cache, write to cache -> data inconsistency between cache and database.
        - `Write-through`: write cache first -> work best with wite heavy but data inconsistency between cache and database.
        - `Write-back`: write to cache after delay write to db -> data inconsistency between cache and database.
      * Using NoSQL
        - work well only with read and write
        - But lost ACID and data consistency of RDBMS.

    * `Application architecture`
      * Change from Monolithic to Microservice  architecture.
        - Better scalability.
        - Fit with large project.
        - `High availability`.
        - Flexibility in choosing the technology

  * Trade off between `Performance` and  `Asynchronous`:
    * Using message queue (RabbitMQ recommended for elixir application) to have an asynchronism.