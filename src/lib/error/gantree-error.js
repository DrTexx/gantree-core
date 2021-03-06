const _error_meta = require('./error-meta.json')

const { BaseError } = require('make-error-cause')

const generic_error = _error_meta.errors.generic_error

class GantreeError extends BaseError {
  constructor(
    code = generic_error.code,
    message = generic_error.message,
    cause = undefined
  ) {
    super(message, cause)

    this.code = code
  }
}

const ErrorTypes = {}
for (const error_name of Object.keys(_error_meta.errors)) {
  ErrorTypes[error_name] = error_name
}

module.exports = {
  GantreeError,
  ErrorTypes
}
