# backend-instabug-task

This is a Ruby on Rails application that demonstrates how to build a messaging platform with Kafka for message queuing and Elasticsearch for full-text search capabilities. It includes Kafka consumers for processing messages, Elasticsearch indexing for search functionality, and RESTful API endpoints for managing applications, chats, and messages.

## Features

- **Kafka Integration**: Utilizes Kafka for message queuing, with consumers to process incoming messages asynchronously.
- **Elasticsearch Integration**: Implements Elasticsearch for powerful full-text search functionality on message content.
- **Redis Integration**: Utilizes Redis for ensuring uniqueness in message and chat numbering.
- **RESTful API**: Provides CRUD operations for managing applications, chats, and messages through API endpoints.
- **Docker Setup**: Containerized using Docker Compose for easy deployment and scalability.
- **MySQL Database**: Stores application data in a MySQL database for seamless integration with Rails.
- **Cron Job** : Job That Runs Every hour to sync the chat and messages counts from redis to the database

## Setup

1. **Clone the Repository**: `git clone https://github.com/zyadelhady/backend-instabug-task.git`

2. **Start Docker Services**: Run `docker compose up`

# Applications API

## Create an Application

Create a new application with a randomly generated token.

- **URL**
  `/applications`

- **Method:**
  `POST`
- **Data Params**
  {
  "application": {
  "name": "Example Application"
  }
  }

- **Success Response:**
- **Code:** 200 OK <br />
  **Content:**

  ```json
  {
    "data": {
      "name": "Example Application",
      "token": "aa6b3b8b-9c78-49ee-8b28-3c14f139c27a",
      "chats_count": 0,
      "created_at": "2024-02-17T14:02:53.265Z",
      "updated_at": "2024-02-17T14:02:53.265Z"
    }
  }
  ```

- **Error Response:**
- **Code:** 422 Unprocessable Entity <br />
  **Content:**
  ```json
  {
    "errors": {
      "name": ["can't be blank"]
    }
  }
  ```

## Get All Applications

Retrieve a list of all applications.

- **URL**
  `/applications`

- **Method:**
  `GET`

- **Success Response:**
- **Code:** 200 OK <br />
  **Content:**
  ```json
  {
    "data": [
      {
        "name": "Application 1",
        "token": "aa6b3b8b-9c78-49ee-8b28-3c14f139c27a",
        "chats_count": 5,
        "created_at": "2024-02-17T14:02:53.265Z",
        "updated_at": "2024-02-17T14:02:53.265Z"
      },
      {
        "name": "Application 2",
        "token": "b3e4872f-cdd1-4bb9-a51e-f39e3f4a67e1",
        "chats_count": 66,
        "created_at": "2024-02-17T14:02:53.265Z",
        "updated_at": "2024-02-17T14:02:53.265Z"
      }
    ]
  }
  ```

## Get Application by Token

Retrieve a specific application by its token.

- **URL**
  `/applications/:token`

- **Method:**
  `GET`

- **URL Params**
  **Required:**
  `token=[string]`

- **Success Response:**
- **Code:** 200 OK <br />
  **Content:**

  ```json
  {
    "data": {
      "name": "Example Application",
      "token": "aa6b3b8b-9c78-49ee-8b28-3c14f139c27a",
      "chats_count": 0,
      "created_at": "2024-02-17T14:02:53.265Z",
      "updated_at": "2024-02-17T14:02:53.265Z"
    }
  }
  ```

- **Error Response:**
- **Code:** 404 Not Found <br />
  **Content:**
  ```json
  {
    "errors": "Application not found"
  }
  ```

## Update an Application

Update an existing application.

- **URL**
  `/applications/:token`

- **Method:**
  `PUT`

- **URL Params**
  **Required:**
  `token=[string]`

- **Data Params**
  {
  "application": {
  "name": "New Name"
  }
  }

- **Success Response:**
- **Code:** 200 OK <br />
  **Content:**

  ```json
  {
    "data": {
      "name": "New Name",
      "token": "aa6b3b8b-9c78-49ee-8b28-3c14f139c27a"
      "chats_count": 0,
      "created_at": "2024-02-17T14:02:53.265Z",
      "updated_at": "2024-02-17T14:02:53.265Z"
    }
  }
  ```

- **Error Response:**
- **Code:** 400 Bad Request <br />
  **Content:**
  ```json
  {
    "errors": {
      "name": ["can't be blank"]
    }
  }
  ```

## Delete an Application

Delete an existing application.

- **URL**
  `/applications/:token`

- **Method:**
  `DELETE`

- **URL Params**
  **Required:**
  `token=[string]`

- **Success Response:**
- **Code:** 204 No Content

- **Error Response:**
- **Code:** 404 Not Found <br />
  **Content:**
  ```json
  {
    "errors": "Application not found"
  }
  ```

# Chats API Documentation

This API allows interaction with chat resources.

## Create a Chat

Creates a new chat for a given application.

- **URL**

  `/api/v1/applications/:application_token/chats`

- **Method:**

  `POST`

- **URL Params**

  **Required:**

  `application_token=[string]`

- **Data Params**

  None

- **Success Response:**

  - **Code:** 200 <br />
    **Content:** `{ data: { number: 1, messages_count: 0 } }`

- **Error Response:**

  - **Code:** 404 NOT FOUND <br />
    **Content:** `{ errors: "No Application Found" }`

- **Sample Call:**

  ```ruby
  POST /api/v1/applications/7784bd17-d91f-413a-ba9a-0f54f23dba4a/chats
  ```

### List Chats

Retrieve a list of chats for a specific application.

- **URL**

  `/api/v1/applications/:application_token/chats`

- **Method:**

  `GET`

- **URL Params**

  **Required:**

  `application_token=[string]`

- **Success Response:**

  - **Code:** 200 <br />
    **Content:**
    ```json
    {
      "data": [
        {
          "number": 1,
          "messages_count": 0
        },
        {
          "number": 2,
          "messages_count": 5
        }
      ]
    }
    ```

- **Error Response:**

  - **Code:** 404 NOT FOUND <br />
    **Content:**
    ```json
    {
      "errors": "No Chats Found"
    }
    ```

### Show Chat Details

Retrieve details of a specific chat for a given application.

- **URL**

  `/api/v1/applications/:application_token/chats/:number`

- **Method:**

  `GET`

- **URL Params**

  **Required:**

  `application_token=[string]`
  `number=[integer]`

- **Success Response:**

  - **Code:** 200 <br />
    **Content:**
    ```json
    {
      "data": {
        "number": 1,
        "messages_count": 0
      }
    }
    ```

- **Error Response:**

  - **Code:** 404 NOT FOUND <br />
    **Content:**
    ```json
    {
      "errors": "Chat not found"
    }
    ```

### Delete a Chat

Delete a specific chat for a given application.

- **URL**

  `/api/v1/applications/:application_token/chats/:number`

- **Method:**

  `DELETE`

- **URL Params**

  **Required:**

  `application_token=[string]`
  `number=[integer]`

- **Success Response:**

  - **Code:** 204 NO CONTENT <br />

- **Error Response:**

  - **Code:** 404 NOT FOUND <br />
    **Content:**
    ```json
    {
      "errors": "Chat not found"
    }
    ```

# Messages API Documentation

## Introduction

The Messages API allows users to manage messages within their chats.

## Endpoints

### List Messages

Retrieve a list of messages for a specific chat.

- **URL**

  `/api/v1/chats/:chat_number/messages`

- **Method:**

  `GET`

- **URL Params**

  **Required:**

  `chat_number=[integer]`
  `application_token=[string]`

- **Query Params**

  `content=[string]`

- **Success Response:**

  - **Code:** 200 <br />
    **Content:**
    ```json
    {
      "data": [
        {
          "content": "Hello World!",
          "number": 1
        },
        {
          "content": "How are you?",
          "number": 2
        }
      ]
    }
    ```

- **Error Response:**

  - **Code:** 404 NOT FOUND <br />
    **Content:**
    ```json
    {
      "errors": "No Messages Found"
    }
    ```

### Show Message Details

Retrieve details of a specific message for a given chat.

- **URL**

  `/api/v1/chats/:chat_number/messages/:number`

- **Method:**

  `GET`

- **URL Params**

  **Required:**

  `chat_number=[integer]`
  `application_token=[string]`
  `number=[integer]`

- **Success Response:**

  - **Code:** 200 <br />
    **Content:**
    ```json
    {
      "data": {
        "content": "Hello World!",
        "number": 1
      }
    }
    ```

- **Error Response:**

  - **Code:** 404 NOT FOUND <br />
    **Content:**
    ```json
    {
      "errors": "Message not found"
    }
    ```

### Create a Message

Create a new message for a specific chat.

- **URL**

  `/api/v1/chats/:chat_number/messages`

- **Method:**

  `POST`

- **URL Params**

  **Required:**

  `chat_number=[integer]`
  `application_token=[string]`

- **Data Params**

  ```json
  {
    "message": {
      "content": "Hello World!"
    }
  }
  ```

- **Success Response:**

  - **Code:** 200 <br />
    **Content:**
    ```json
    {
      "data": {
        "number": 3
      }
    }
    ```

- **Error Response:**

  - **Code:** 404 NOT FOUND <br />
    **Content:**
    ```json
    {
      "errors": "No Chat Found"
    }
    ```

### Update a Message

Update an existing message.

- **URL**

  `/api/v1/chats/:chat_number/messages/:number`

- **Method:**

  `PUT`

- **URL Params**

  **Required:**

  `chat_number=[integer]`
  `application_token=[string]`
  `number=[integer]`

- **Data Params**

  ```json
  {
    "message": {
      "content": "Updated message content"
    }
  }
  ```

- **Success Response:**

  - **Code:** 200 <br />
    **Content:**
    ```json
    {
      "data": {
        "content": "Updated message content"
        "number": 3
      }
    }
    ```

- **Error Response:**

  - **Code:** 404 NOT FOUND <br />
    **Content:**
    ```json
    {
      "errors": "Message not found"
    }
    ```
