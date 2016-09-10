# Todox API [![Build Status](https://travis-ci.org/saulecabrera/todox.svg?branch=master)](https://travis-ci.org/saulecabrera/todox)
Root `https://todoxapi.herokuapp.com/api`

## Registration

#### Endpoint

`POST /register`

#### Parameters

A `user` object composed of:

`username: String`
  - must be unique
  - can't be blank
  - can only be composed of letters, digits and _

`password: String`
  - can't be blank
  - should be at least 8 characters long

#### Example

  ```json
  "user": {
    "username": "some_username",
    "password": "strongpw1234"
  }
  ```
