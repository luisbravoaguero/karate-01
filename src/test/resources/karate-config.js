/*function fn() {
  // Select env with: -Dkarate.env=dev  (default is dev)
  var env = karate.env || 'dev';

  // Load env config JSON: classpath:config/dev.json (or qa.json)
  var config = karate.read('classpath:config/' + env + '.json');

  // Expose env name
  config.env = env;

  // Configure timeouts
  karate.configure('connectTimeout', config.timeouts && config.timeouts.connect ? config.timeouts.connect : 5000);
  karate.configure('readTimeout', config.timeouts && config.timeouts.read ? config.timeouts.read : 15000);

  // Configure pretty logging
  var prettyReq = config.logging && typeof config.logging.prettyRequest === 'boolean' ? config.logging.prettyRequest : true;
  var prettyRes = config.logging && typeof config.logging.prettyResponse === 'boolean' ? config.logging.prettyResponse : true;
  karate.configure('logPrettyRequest', prettyReq);
  karate.configure('logPrettyResponse', prettyRes);

  // Global default headers
  config.commonHeaders = {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  };

  // Fail fast if baseUrl is missing
  if (!config.baseUrl) {
    karate.fail('baseUrl is missing for env=' + env + '. Check config/' + env + '.json');
  }

  return config;
}
*/
/*
function fn() {
  var env = karate.env || 'dev';

  // Base config per env
  var config = read('classpath:config/' + env + '.json');

  // If mock server is running, override baseUrl dynamically
  var mockPort = karate.properties['mock.port'];
  if (mockPort) {
    config.baseUrl = 'http://localhost:' + mockPort;
  }

  // common headers used by tests
  config.commonHeaders = {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  };

  return config;
}*/

function fn() {
  var env = karate.env || 'dev';

  // Load env config JSON
  var config = karate.read('classpath:config/' + env + '.json');
  config.env = env;

  // If mock server is running, override baseUrl dynamically
  var mockPort = karate.properties['mock.port'];
  if (mockPort) {
    config.baseUrl = 'http://localhost:' + mockPort;
  }

  // Fail fast (future-proof): we always require a baseUrl
  if (!config.baseUrl) {
    karate.fail('baseUrl is missing. Set it in config/' + env + '.json or start mock server.');
  }

  // common headers used by tests
  config.commonHeaders = {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  };

  return config;
}
