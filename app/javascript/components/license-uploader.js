const licenseUploader = () => {
  const fileInput = document.getElementById('license_photo');
  if (fileInput) {
    const reader = new FileReader();
    const img = document.getElementById('license-preview');
    reader.onload = e => {
      document.getElementById('upload-icon').classList.add('d-none')
      img.src = e.target.result;
    }
    fileInput.addEventListener('change', e => {
      const f = e.target.files[0];
      reader.readAsDataURL(f);
    })
  }
}

export { licenseUploader }