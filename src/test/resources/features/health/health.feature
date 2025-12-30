Feature: Health check

  Scenario: GET /health returns UP
    * url baseUrl
    * path 'health'
    * headers commonHeaders
    * method get
    * status 200
    * match response == { status: 'UP' }
