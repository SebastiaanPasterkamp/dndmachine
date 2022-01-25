import { useState } from 'react'

export default function useFormHelper(initialValues, validate, validateOnChange = false) {
  const [values, setValues] = useState(initialValues);
  const [errors, setErrors] = useState({});

  const isValid = async (newValues = values) => {
    const newErrors = await validate(newValues);
    setErrors({ ...errors, ...newErrors });
    return Object.values(newErrors).every(f => !f);
  }

  const handleInputChange = async (e) => {
    const { name, value } = e.target
    setValues({
      ...values,
      [name]: value,
    })
    if (validateOnChange) {
      const newErrors = await validate({ [name]: value });
      setErrors({ ...errors, ...newErrors });
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
    handleInputChange,
    isValid,
    resetForm,
  }
}
