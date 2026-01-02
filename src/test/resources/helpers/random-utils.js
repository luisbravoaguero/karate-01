function fn() {

  function uuid() {
    return java.util.UUID.randomUUID() + '';
  }

  function digits(length) {
    var s = '';
    for (var i = 0; i < length; i++) {
      s += Math.floor(Math.random() * 10);
    }
    return s;
  }

  function alphaNum(length) {
    var chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    var out = '';
    for (var i = 0; i < length; i++) {
      out += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return out;
  }

  // Useful for uniqueness across parallel runs
  function correlationId(prefix) {
    prefix = prefix || 'corr';
    return prefix + '-' + uuid();
  }

  return {
    uuid: uuid,
    digits: digits,
    alphaNum: alphaNum,
    correlationId: correlationId
  };
}
