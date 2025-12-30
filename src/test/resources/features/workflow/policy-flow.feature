@workflow
Feature: Policy creation workflow (training flow)

  Background:
    * url baseUrl
    * configure headers = commonHeaders

  Scenario: Login -> InsuredCode -> Simulation -> Policy
    # Step 1) Login -> token
    Given path 'auth', 'login'
    And request { username: 'demo', password: 'secret' }
    When method post
    Then status 200
    * def token = response.access_token
    * match token != null

    # ✅ Apply auth globally for the rest of the scenario
    * configure headers = karate.merge(commonHeaders, { Authorization: 'Bearer ' + token })

    # Step 2) InsuredCode
    Given path 'insured-code'
    When method get
    Then status 200
    * def serial = response.serialNumber
    * match serial != null

    # Step 3) Simulation (now it will include Authorization automatically)
    Given path 'simulation'
    And request { serialNumber: '#(serial)', requestedAt: '#(new java.util.Date().toString())' }
    When method post
    Then status 200
    * def semiPolicy = response.semiPolicyNumber
    * match semiPolicy != null

    # Step 4) Policy
    Given path 'policy', semiPolicy
    When method get
    Then status 200
    * def policyNumber = response.policyNumber
    * match policyNumber != null
