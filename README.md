# Todox API [![Build Status](https://travis-ci.org/saulecabrera/todox.svg?branch=master)](https://travis-ci.org/saulecabrera/todox)
Root `https://todoxapi.herokuapp.com/api`

## Registration

#### Endpoint

`POST /register`

#### Parameters

`user` object composed of:

`username: String`
  - must be unique
  - can't be blank
  - can only be composed of letters, digits and _

`password: String`
  - can't be blank
  - should be at least 8 characters long

#### Example

  ```javascript
  "user": {
    "username": "some_username",
    "password": "strongpw1234"
  }
  ```
#### Response

Status `201`

JSON of the form:

  ```javascript
  "data": {
    "id": "1",
    "username": "some_username",
    "jwt": "token",
    "exp": "jwt expiration date"
  } 
  ```
#### Errors

Status `422`

One or any combination of:

```javascript
"errors": {
  "username": [
    "can't be blank",
    "can only be composed of letters, digits and _",
    "has already been taken"
  ],
  "password": [
    "can't be blank",
    "should be at least 8 character(s)"
  ] 
}
```

## Login

#### Endpoint

`POST /login`

#### Parameters

`credentials` object composed of:

`username: String`

`password: String`

#### Example

  ```javascript
  "credentials": {
    "username": "some_username",
    "password": "the_password"
  }
  ```

#### Response

Status `200`

See `POST /register`

#### Errors

One of the following status:

`401` wrong credentials

`404` username/password combination not found
