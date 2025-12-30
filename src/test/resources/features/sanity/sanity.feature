Feature: Sanity check

  Scenario: Config + mock baseUrl are available
    * print 'env =', env
    * print 'baseUrl =', baseUrl
    * match env != null
    * match baseUrl contains 'http://localhost:'
