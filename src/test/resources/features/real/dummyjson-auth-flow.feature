@real @workflow
Feature: DummyJSON real workflow (auth + chaining)

  Background:
    * url baseUrl
    * configure headers = commonHeaders

  Scenario: Login -> /auth/me -> /users/{id}
    # 1) Login (real)
    Given path 'auth', 'login'
    And request { username: 'emilys', password: 'emilyspass', expiresInMins: 30 }
    When method post
    Then status 200

    # DummyJSON returns accessToken in the response
    * def token = response.accessToken
    * match token != null

    # 2) Call protected endpoint using Bearer token
    * configure headers = karate.merge(commonHeaders, { Authorization: 'Bearer ' + token })

    Given path 'auth', 'me'
    When method get
    Then status 200

    * def userId = response.id
    * match userId != null

    # 3) Use extracted data (id) in the next endpoint (chaining)
    Given path 'users', userId
    When method get
    Then status 200
    * match response.id == userId
