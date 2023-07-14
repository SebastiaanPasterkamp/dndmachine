import { useState } from 'react';

export default function useFormHelper(initialValues, validate, validateOnChange = false) {
  const [values, setValues] = useState(initialValues);
  const [errors, setErrors] = useState({});

  const isValid = async (newValues = values) => {
    const newErrors = await validate(newValues);
    setErrors({ ...errors, ...newErrors });
    return Object.values(newErrors).every(f => !f);
  }

  const handleChangeCallback = async (field, callback) => setValues((values) => {
    const { [field]: original } = values;
    const update = callback(original);

    if (validateOnChange) {
      const newErrors = validate({ [field]: update });
      setErrors((errors) => ({ ...errors, ...newErrors }));
    }

    return {
      ...values,
      [field]: update,
    };
  });

  const handleInputChange = async (e) => {
    if (e.preventDefault) e.preventDefault();
    const { name, value } = e.target;

    setValues((values) => ({
      ...values,
      [name]: value,
    }));

    if (validateOnChange) {
      const newErrors = await validate({ [name]: value });
      setErrors((errors) => ({ ...errors, ...newErrors }));
    }
  }

  const resetForm = () => {
    setValues(initialValues);
    setErrors({});
  }

  return {
    values,
    setValues,
    errors,
    setErrors,
    handleChangeCallback,
    handleInputChange,
    isValid,
    resetForm,
  }
}
