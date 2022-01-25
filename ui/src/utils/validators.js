const minLength = function (field, length) {
  if (field && field.length < length) {
    return `This field should be at least ${length} characters.`
  }
}

const maxLength = function (field, length) {
  if (field && field.length > length) {
    return `This field can be at most ${length} characters.`
  }
}

const numeric = function (field) {
  if (field && !field.match(/^\d+$/)) {
    return `This field can only contain numeric values.`
  }
}

const requiredString = function (field) {
  if ((
    field === null
    || field === undefined
    || field.trim().length === 0
  )) {
    return "This field is required."
  }
}

const validEmail = function (address) {
  if (address && !/^\w+(?:[.-]\w+)*(?:\+\w+(?:[.-]\w+)*)*@\w+(?:[.-]\w+)*(?:\.\w{2,3})+$/.test(address)) {
    return "This email address is invalid."
  }
}

export {
  maxLength,
  minLength,
  numeric,
  requiredString,
  validEmail,
}