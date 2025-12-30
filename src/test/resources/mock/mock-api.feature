Feature: Mock API (training server)

  Background:
  # Runs ONCE when the mock server starts (state can live in memory)
    * configure cors = true
    * def uuid = function(){ return java.util.UUID.randomUUID() + '' }

  # In-memory "database"
    * def tokens = {}              # token -> username
    * def serialByToken = {}       # token -> serialNumber
    * def semiBySerial = {}        # serialNumber -> semiPolicyNumber
    * def policyBySemi = {}        # semiPolicyNumber -> policyNumber

  Scenario: pathMatches('/health') && methodIs('get')
    * def response = { status: 'UP' }

  Scenario: pathMatches('/auth/login') && methodIs('post')
    * if (!request.username || !request.password) karate.fail('Missing username/password')
    * def token = 'tok-' + uuid()
    * tokens[token] = request.username
    * def response =
    """
    {
      "access_token": "#(token)",
      "token_type": "Bearer"
    }
    """

  Scenario: pathMatches('/insured-code') && methodIs('get')
    * def auth = karate.request.header('authorization')
    * if (!auth || !auth.startsWith('Bearer ')) karate.fail('Missing Bearer token')
    * def token = auth.substring(7)
    * if (!tokens[token]) karate.fail('Invalid token')

    * def serial = 'SER-' + uuid()
    * serialByToken[token] = serial
    * def response = { serialNumber: "#(serial)" }

  Scenario: pathMatches('/simulation') && methodIs('post')
    * def auth = karate.request.header('authorization')
    * if (!auth || !auth.startsWith('Bearer ')) karate.fail('Missing Bearer token')
    * def token = auth.substring(7)
    * if (!tokens[token]) karate.fail('Invalid token')

    * if (!request.serialNumber) karate.fail('Missing serialNumber')
    * def semi = 'SEMI-' + uuid()
    * semiBySerial[request.serialNumber] = semi
    * def response = { semiPolicyNumber: "#(semi)" }

  Scenario: pathMatches('/policy/{semi}') && methodIs('get')
    * def auth = karate.request.header('authorization')
    * if (!auth || !auth.startsWith('Bearer ')) karate.fail('Missing Bearer token')
    * def token = auth.substring(7)
    * if (!tokens[token]) karate.fail('Invalid token')

    * def semi = pathParams.semi
    * def existing = policyBySemi[semi]
    * def policy = existing ? existing : 'POL-' + uuid()
    * policyBySemi[semi] = policy
    * def response = { policyNumber: "#(policy)" }

# Catch-all
  Scenario:
    * def responseStatus = 404
    * def response = { message: 'not found', path: requestPath, method: requestMethod }
