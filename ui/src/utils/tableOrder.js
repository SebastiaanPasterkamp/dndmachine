import sortMethod from './sortMethod';

export default function tableOrder(a, b, sortFields) {
  var i, field;
  for (i = 0, field = sortFields[i]; i < sortFields.length; i++, field = sortFields[i]) {
    const cmp = field in sortMethod
      ? sortMethod[field]
      : sortMethod.default;

    const sort = cmp(a[field], b[field]);
    if (sort === 0) {
      continue;
    }

    return sort
  }

  return 0;
}
