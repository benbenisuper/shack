const initCalendar = () => {

	const weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	const wdayFull = ["Sundays", "Mondays", "Tuesdays", "Wednesdays", "Thursdays", "Fridays", "Saturdays"]
	const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	const calendar = document.getElementById('venue-calendar')
	const dayForm = document.getElementById('day-form')
	const venueTimes = document.getElementById('venue-times')
	const bookingForm = document.getElementById('booking-form')
	const calendarWrapper = document.getElementById('calendar-wrapper')

	function fetchDay(id) {
		fetch(`/api/v1/days/${id}`)
		.then(response => response.json())
		.then((data) => {

			let DOMhours = ``
			data.hours.forEach((hour, index) => {
				let disabled = `disabled`
				if (hour.available) {
					disabled = ``
				}
				venueTimes.dataset.dayPrice = Number(data.day.day_price_cents) / 100
				venueTimes.dataset.hourPrice = Number(data.day.hour_price_cents) / 100
				DOMhours = DOMhours + `
				<div class="hour rounded text-center font-weight-bolder ${disabled}" 
				data-day="${data.day.day}" 
				data-hour="${hour.hour}"
				>
				<span>${hour.hour}:00</span>
				</div>
				`
			})
			venueTimes.innerHTML = DOMhours
			venueTimes.dataset.year = data.day.year
			venueTimes.dataset.month = data.day.month
			venueTimes.dataset.day = data.day.day
			venueTimes.classList.add('active')
		})
	}
	
	function fetchCalendar(year, month) {
		fetch(`/api/v1/calendars/${calendar.dataset.id}?year=${year}&month=${month}`)
		.then(response => response.json())
		.then((data) => {
			console.log(data.days)
			const calendar = document.getElementById('venue-calendar')
			let DOMweekdays = ``
			weekdays.forEach((weekday, index) => {
				DOMweekdays = DOMweekdays + `<div class="weekday d-flex justify-content-center align-items-center">
					<strong class="text-center">${ weekday }</strong>
				</div>`
			})
			let DOMdays = ``
			data.days.forEach((day, index) => {
				DOMdays = DOMdays + `<div 
						class="day d-flex flex-column justify-content-center align-items-center ${ data.day_colors[index] }"
						id="${ day.id }"
						data-year="${ day.year }"
						data-month="${ day.month }"
						data-day="${ day.day }"
						data-wday="${ day.wday }"
						data-wNum="${ day.wnum }"
						data-day-price="${ day.day_price_cents }"
						data-hour-price="${ day.hour_price_cents }"
						>
						
							<span class="text-center">${ day.day }</span>
							<span class="d-flex">
								<span class="text-center" style="font-size: 10px; color: rgba(255,0,0, 0.5);">
									${ Math.round(Number(day.day_price_cents)/100) }
								</span>
								<span class="text-center ml-2" style="font-size: 10px; color: rgba(0,0,255, 0.5);">
									[${ Math.round(Number(day.hour_price_cents)/100) }]
								</span>
							</span>
						</div>`
			})
			let prevMonth = `<div id="previous-month" class="col-3 text-center"><<</div>`
			if (`${month}/${year}` == data.date_limits.first) {
				prevMonth = `<div id="" class="col-3 text-center"></div>`
			}
			let nextMonth = `<div id="next-month" class="col-3 text-center">>></div>`
			if (`${month}/${year}` == data.date_limits.last) {
				nextMonth = `<div id="" class="col-3 text-center"></div>`
			}
			calendarWrapper.innerHTML = `
				<div id="calendar-header" class="row align-items-center">
					${prevMonth}
					<div id="calendar-month" class="col-6 text-center"><strong>${ months[month - 1] } ${year}</strong></div>
					${nextMonth}
				</div>
				<div id="venue-calendar" class=""  data-id="${calendar.dataset.id}" data-year="${year}" data-month="${month}">
					${DOMweekdays}
					${DOMdays}
				</div>`
		})
	}

	const handleMouseover = (event) => {
		const ableHours = document.querySelectorAll('.hour:not(.disabled)')
		const hour = event.currentTarget
		ableHours.forEach((hr) => {
			if (Number(hr.dataset.hour) <= Number(hour.dataset.hour)) {
				hr.classList.add('active')
			}
		})
	}

	const handleMouseout = (event) => {
		const ableHours = document.querySelectorAll('.hour:not(.disabled)')
		const hour = event.currentTarget
		ableHours.forEach((hr) => {
			if (Number(hr.dataset.hour) <= Number(hour.dataset.hour)) {
				hr.classList.remove('active')
			}
		})
	}
						
	if (calendar) {
		window.addEventListener('click', (event) => {
			if (calendar.dataset.type == "host") {
				const days = document.querySelectorAll('.day:not(.disabled)')
				const calendar = document.getElementById('venue-calendar')
				const calendarForm = document.getElementById('calendar-form')
				const monthNum = Number(calendar.dataset.month)
				const yearNum = Number(calendar.dataset.year)
				const div = event.target.closest('div')
				console.log(div)

				if (event.target.id == 'calendar-form-submit') {
					calendarForm.submit()
				}

				// WHEN I CLICK ON PREVIOUS MONTH ( << )
				if (event.target.id == 'previous-month') {
					let month
					let year = yearNum
					if (monthNum == 1) {
						month = 12
						year = yearNum - 1
					} else {
						month = monthNum - 1
					}
					fetchCalendar(year, month)
				}		

				// WHEN I CLICK ON NEXT MONTH ( >> )
				if (event.target.id == 'next-month') {
					let month
					let year = yearNum
					if (monthNum == 12) {
						month = 1
						year = yearNum + 1
					} else {
						month = monthNum + 1
					}
					fetchCalendar(year, month)
				}

				// WHEN I CLICK ON DAY THAT IS NOT DISABLED OR THE CALENDAR FORM
				if (div.classList.contains('day') && !div.classList.contains('disabled') || (event.target.closest('#day-form') == dayForm && dayForm)) {
					if (div.classList.contains('day')) {
						days.forEach((day) => {
							day.classList.remove('active')
						})
						const dayString = `{"type":"day","value":"${div.dataset.day}/${div.dataset.month}/${div.dataset.year}"}`
						const wdayString = `{"type":"weekday","value":"${div.dataset.wday}"}`
						const wdayStringValue = wdayFull[div.dataset.wday]
						const wnumString = `{"type":"weeknum","value":"${div.dataset.wnum}"}`
						const monthString = `{"type":"month","value":"${div.dataset.month}"}`
						const monthStringValue = months[div.dataset.month - 1]
						const csrfToken = document.querySelector('meta[name="csrf-token"]').attributes.content.value;
						if (dayForm) {
							dayForm.innerHTML = `
						<div class="wrapper">
							<form novalidate="novalidate" class="simple_form /venues/${dayForm.dataset.venueId}" action="/venues/${dayForm.dataset.venueId}" accept-charset="UTF-8" data-remote="true" method="post" id="calendar-form">
								<input type="hidden" name="_method" value="patch">
								<input type="hidden" name="authenticity_token" value="${csrfToken}">
		              
		                		<input type="hidden" name="day[option]" value="">
		                		<input type="hidden" name="day[calendar]" value="${calendar.dataset.id}">
		                		<input type="hidden" name="day[month]" value="${div.dataset.month}">
		                		<input type="hidden" name="day[year]" value="${div.dataset.year}">
		                		<div class="row">
		                			<div class="col-7 border-right">
			                			<div class="form-group integer day_day_price">
				                			<label class="integer" for="day_day_price">
				                				Day price:
				                			</label>
				                			<div class="input-group input-group-merge">
					                			<span class="input-group-text only-rounded-left" ><strong>CHF</strong></span>
					                			<input class="form-control numeric integer form-control-prepend" type="number" step="1" name="day[day_price]" id="day_day_price" value="${Number(div.dataset.dayPrice)/100}" style="font-size: 1rem;">
				                			</div>
			                			</div>
			                			<div class="form-group integer day_hour_price active">
				                			<label class="integer" for="day_hour_price">
				                				Hour price:
				                			</label>
				                			<div class="input-group input-group-merge">
					                			<span class="input-group-text only-rounded-left" ><strong>CHF</strong></span>
					                			<input class="form-control numeric integer form-control-prepend" type="number" step="1" name="day[hour_price]" id="day_hour_price" value="${Number(div.dataset.hourPrice)/100}" style="font-size: 1rem;">
				                			</div>
			                			</div>
		                			</div>
		                			<div class="col-5">
				                		<div class="d-flex flex-column justify-content-between h-100">Apply on:
					                		<span>
						                		<input type="radio" value=${dayString} name="day[option]" id="day_option_day">
						                		<label class="collection_radio_buttons" for="day_option_day">Selected day</label>
					                		</span>
					                		<span>
						                		<input type="radio" value=${wdayString} name="day[option]" id="day_option_weekday">
						                		<label class="collection_radio_buttons" for="day_option_weekday">${wdayStringValue}</label>
					                		</span>
					                		<span>
						                		<input type="radio" value=${wnumString} name="day[option]" id="day_option_week">
						                		<label class="collection_radio_buttons" for="day_option_week">Week</label>
					                		</span>
					                		<span>
						                		<input type="radio" value=${monthString} name="day[option]" id="day_option_month">
						                		<label class="collection_radio_buttons" for="day_option_month">${monthStringValue}</label>
					                		</span>
				                		</div>
				                	</div>
		                		</div>
							</form>
							<div class="d-flex pt-3 border-top">
								<button class="btn btn-secondary ml-auto" id="calendar-form-submit">Modify</button>
							</div>
						</div>
						`
						}
						
					}
					
					div.classList.toggle('active')
					if (dayForm) { dayForm.classList.add('active') }
				} else {
					days.forEach((day) => {
						day.classList.remove('active')
					})
					if (dayForm) { dayForm.classList.remove('active') }
				}
			}

			if (calendar.dataset.type == "guest") {
				const days = document.querySelectorAll('.day:not(.disabled)')
				const calendar = document.getElementById('venue-calendar')
				const monthNum = Number(calendar.dataset.month)
				const yearNum = Number(calendar.dataset.year)
				const div = event.target.closest('div')

				if (event.target.id == 'calendar-form-submit') {
					calendarForm.submit()
				}

				// WHEN I CLICK ON PREVIOUS MONTH ( << )
				if (event.target.id == 'previous-month') {
					let month
					let year = yearNum
					if (monthNum == 1) {
						month = 12
						year = yearNum - 1
					} else {
						month = monthNum - 1
					}
					fetchCalendar(year, month)

				}

				// WHEN I CLICK ON NEXT MONTH ( >> )
				if (event.target.id == 'next-month') {
					let month
					let year = yearNum
					if (monthNum == 12) {
						month = 1
						year = yearNum + 1
					} else {
						month = monthNum + 1
					}
					fetchCalendar(year, month)
				}
				
				if (div.classList.contains('day') && !div.classList.contains('disabled') || (event.target.closest('#venue-times') == venueTimes && venueTimes) || (event.target.closest('#booking-form') == bookingForm && bookingForm)) {

					if (div.classList.contains('day')) {
						days.forEach((day) => {
							day.classList.remove('active')
						})
						const csrfToken = document.querySelector('meta[name="csrf-token"]').attributes.content.value;
						fetchDay(div.id)
						div.classList.toggle('active')
						venueTimes.dataset.stage = 'start'
					}

					const hours = document.querySelectorAll('.hour')

					if (venueTimes.dataset.stage == "end") {

						if (div.classList.contains('hour') && !div.classList.contains('disabled')) {
							const ableHours = document.querySelectorAll('.hour:not(.disabled)')
							for (let hour of ableHours) {
								if (Number(hour.dataset.hour) > Number(div.dataset.hour)) {
									hour.classList.add('disabled')
								} else {
									hour.classList.add('active')
								}
							}
							ableHours.forEach((hour) => {
								hour.removeEventListener('mouseover', handleMouseover)
								hour.removeEventListener('mouseout', handleMouseout)
							})
							venueTimes.dataset.stage = 'submit'
							const endDate = `${venueTimes.dataset.day}/${venueTimes.dataset.month}/${venueTimes.dataset.year} at ${Number(div.dataset.hour) + 1}:00 hs`
							const endValue = `${venueTimes.dataset.month}/${venueTimes.dataset.day}/${venueTimes.dataset.year} ${Number(div.dataset.hour) + 1}:00`
							const startDate = document.getElementById('booking_start_date').value
							const totalHours = (new Date(endValue) - new Date(bookingForm.dataset.startValue)) / 3600000
							const amount = totalHours * Number(venueTimes.dataset.hourPrice)


							document.getElementById('end-date').insertAdjacentHTML('afterbegin', `<span> To: ${endDate}</span>`)
							document.getElementById('booking_end_date').value = endDate
							document.getElementById('booking_amount').value = amount
							document.getElementById('total-hours').insertAdjacentHTML('afterbegin', `<span> Total Hours:  ${totalHours} hs</span>`)
							document.getElementById('total-price').insertAdjacentHTML('afterbegin', `<span>CHF ${amount}</span>`)
							
						}
					}

					if (venueTimes.dataset.stage == "start") {

						if (div.classList.contains('hour') && !div.classList.contains('disabled')) {
							let pass = 0
							for (let hour of hours) {
								hour.classList.remove('active')
								if (hour.classList.contains('disabled') && Number(hour.dataset.hour) > Number(div.dataset.hour)) {
									pass = 1
								}
								if (Number(hour.dataset.hour) < Number(div.dataset.hour) || pass == 1) {
									hour.classList.add('disabled')
								}
							}
							div.classList.toggle('active')
							venueTimes.dataset.stage = "end"
							const ableHours = document.querySelectorAll('.hour:not(.disabled)')
							ableHours.forEach((hour) => {
								hour.addEventListener('mouseover', handleMouseover )
								hour.addEventListener('mouseout', handleMouseout )
							})
							bookingForm.classList.add('active')
							const startDate = `${venueTimes.dataset.day}/${venueTimes.dataset.month}/${venueTimes.dataset.year} at ${div.innerText} hs`
							const startValue = `${venueTimes.dataset.month}/${venueTimes.dataset.day}/${venueTimes.dataset.year} ${div.innerText}`
							
							document.getElementById('start-date').insertAdjacentHTML('afterbegin', `<span> From: ${startDate}</span>`)
							document.getElementById('booking_start_date').value = startDate
							bookingForm.dataset.startValue = startValue

						}
					}

				} else {
					days.forEach((day) => {
						day.classList.remove('active')
					})
					if (venueTimes) { 
						venueTimes.classList.remove('active')
						venueTimes.dataset.stage = 'start'
					}
					document.getElementById('start-date').innerHTML = ``
					document.getElementById('end-date').innerHTML = ``
					document.getElementById('total-hours').innerHTML = ``
					document.getElementById('total-price').innerHTML = ``
					bookingForm.classList.remove('active')
				}
			}
		})	
	}
}

export { initCalendar }