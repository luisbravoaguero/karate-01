@real @parallel @dateformats
Feature: Postman Echo - Scenario Outline for date formats (today + months)

  Background:
    * url baseUrl
    * configure headers = commonHeaders
    * def random = call read('classpath:helpers/random-utils.js')
    * def dates = call read('classpath:helpers/date-utils.js')

  Scenario Outline: Big payload with format <pattern> and period <monthsToAdd> months
    # Unique values per scenario iteration (parallel safe)
    * def correlationId = random.correlationId('echo')
    * def personId = random.digits(8)

    # Start date = today (computed once per scenario)
    * def startObj = dates.today()

    # End date = start + months (controlled by example row)
    * def endObj = dates.addMonths(startObj, <monthsToAdd>)

    # Derived date = start + derived months (controlled by example row)
    * def derivedObj = dates.addMonths(startObj, <derivedMonthsToAdd>)

    # Format them (controlled by example row)
    * def startDate = dates.format(startObj, '<pattern>')
    * def endDate = dates.format(endObj, '<pattern>')
    * def derivedDate = dates.format(derivedObj, '<pattern>')

    # Load big JSON template (fresh copy per scenario)
    * def payload = read('classpath:payloads/echo/big-request.json')

    # Inject dynamic values
    * set payload.correlationId = correlationId
    * set payload.customer.idNumber = personId
    * set payload.policy.startDate = startDate
    * set payload.policy.endDate = endDate
    * set payload.policy.derivedDate = derivedDate
    * set payload.meta.tags[0] = '<pattern>'

    Given path 'post'
    And request payload
    When method post
    Then status 200

    # Validate echo
    * match response.json.correlationId == correlationId
    * match response.json.customer.idNumber == personId
    * match response.json.policy.startDate == startDate
    * match response.json.policy.endDate == endDate
    * match response.json.policy.derivedDate == derivedDate

    Examples:
      | pattern     | monthsToAdd | derivedMonthsToAdd |
      | yyyy-MM-dd  | 12          | 3                  |
      | dd/MM/yyyy  | 6           | 1                  |
      | yyyyMMdd    | 24          | 18                 |
