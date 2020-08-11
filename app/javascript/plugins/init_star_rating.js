const initStarRating = () => {	
	const handleMouseOver = (event) => {
		const stars = document.querySelectorAll('.star')
		stars.forEach((star) => {
			if (Number(star.dataset.stars) <= Number(event.currentTarget.dataset.stars)) {
				star.classList.remove('far')
				star.classList.add('fas')
			}
		})
	}
	
	const handleMouseOut = (event) => {
		const stars = document.querySelectorAll('.star')
		stars.forEach((star) => {
			if (Number(star.dataset.stars) <= Number(event.currentTarget.dataset.stars)) {
				star.classList.remove('fas')
				star.classList.add('far')
			}
		})
	}

	const handleClick = (event) => {
		const stars = document.querySelectorAll('.star')
		stars.forEach((star) => {
			star.classList.remove('fas')
			star.classList.add('far')
			if (Number(star.dataset.stars) <= Number(event.currentTarget.dataset.stars)) {
				star.classList.remove('far')
				star.classList.add('fas')
			}
			star.removeEventListener('mouseover', handleMouseOver )
			star.removeEventListener('mouseout', handleMouseOut )
		})
		document.getElementById('review_rating').value = Number(event.currentTarget.dataset.stars)
	}



	const rating = document.getElementById('rating')
	if (rating) {	
		const stars = document.querySelectorAll('.star')			
		stars.forEach((star) => {			
			star.addEventListener('mouseover', handleMouseOver )
			star.addEventListener('mouseout', handleMouseOut )
			star.addEventListener('click', handleClick )
		})
	}
}

export { initStarRating }