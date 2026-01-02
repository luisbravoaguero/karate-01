Feature: Postman Echo - big request body example
  @real @bigbody @postman
  Scenario: Send a big JSON body and validate echo
    * url baseUrl

  # Optional: reduce noise when the body is large
    * configure logPrettyRequest = false
    * configure logPrettyResponse = true

    * def correlationId = java.util.UUID.randomUUID() + ''
    * def randomId = '' + (10000000 + Math.floor(Math.random() * 90000000))
    * def startDate = '2026-01-01'
    * def endDate = '2026-12-31'

    * def payload = read('classpath:payloads/echo/big-request.json')

    Given path 'post'
    And request payload
    When method post
    Then status 200

  # Postman Echo returns your sent body inside response.json
    * match response.json.correlationId == correlationId
    * match response.json.customer.idNumber == randomId
    * match response.json.policy.startDate == startDate
