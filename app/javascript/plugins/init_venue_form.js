const initVenueForm = () => {
	const newVenuePerks = document.getElementById('new-venue-perks')
	if (newVenuePerks) {
	  document.addEventListener('click', (event) => {
	  	if (event.target.classList.contains('toggle-catch')) {
	  		event.target.closest('label').classList.toggle('active')
	  	}
	  })
	}
}

export { initVenueForm };