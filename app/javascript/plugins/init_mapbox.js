import mapboxgl from 'mapbox-gl';
import cloudinary from 'cloudinary-core';

const initMapbox = () => {
  const cl = new cloudinary.Cloudinary({cloud_name: "mhoare", secure: true });
  const mapElement = document.getElementById('map');

  if (mapElement) { // only build a map if there's a div#map to inject into
    const mbxGeocode = require('@mapbox/mapbox-sdk/services/geocoding');
    const geocodingClient = mbxGeocode({ accessToken: mapElement.dataset.mapboxApiKey });
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });
    
    //TEMP ----------------------------------------------
    // const ne = document.getElementById('ne')
    // const sw = document.getElementById('sw')
    // const zoom = document.getElementById('zoom')
    // map.on('drag', function(e) {
    //   let bounds = map.getBounds()
    //   ne.innerHTML = `[${bounds["_ne"]["lat"].toFixed(3)}] / [${bounds["_ne"]["lng"].toFixed(3)}]`
    //   sw.innerHTML = `[${bounds["_sw"]["lat"].toFixed(3)}] / [${bounds["_sw"]["lng"].toFixed(3)}]`
    // })
    // map.on('zoom', function(e) {
    //   let mapZoom = map.getZoom()
    //   zoom.innerHTML = `${mapZoom}`
    // })
    //TEMP ----------------------------------------------


    const markers = JSON.parse(mapElement.dataset.markers);
    markers.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.infoWindow);
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(map);
    });

    if (mapElement.dataset.page == "index") {


      let initfilter = JSON.parse(mapElement.dataset.filter)
      // Search for filter(location) information to set map to that location
      // console.log(`1- ${Date.now()}`)
      geocodingClient.forwardGeocode({
          query: initfilter["location"],
          limit: 1
        })
        .send()
        .then(response => {
          const match = response.body;
          // console.log(`2- ${Date.now()}`)
          map.setCenter([match.features[0].center[0],match.features[0].center[1]])
          map.setZoom(10)
        });
      // console.log(`3- ${Date.now()}`)



      // API SEARCH 
      const apiSearch = () => {
        let filter = JSON.parse(mapElement.dataset.filter)
        const venueList = document.getElementById('venue-list')
        const bounds = map.getBounds()
        // console.log(`4- ${Date.now()}`)
        const url = `/api/v1/venues?ne_lat=${bounds["_ne"]["lat"]}&ne_lng=${bounds["_ne"]["lng"]}&sw_lat=${bounds["_sw"]["lat"]}&sw_lng=${bounds["_sw"]["lng"]}&category=${filter["category"]}&activity=${filter["activity"]}`
        fetch(url)
          .then(response => response.json())
          .then((data) => {
            // console.log(`5- ${Date.now()}`)
            venueList.innerHTML = '';
            // console.log(`6- ${Date.now()}`)
            data["venues"].forEach((venue) => {
              const tag = cl.imageTag(venue["venue_image"], { crop: "pad", class: "venue-card-image"});
              const venueCard = `<a href="/venues/${venue["id"]}" class="col-12 col-sm-6 col-lg-4 text-decoration-none px-lg-4 px-xg-5 mt-2">
                                  <div class="card shadow-sm mb-5 bg-white rounded venue-card">
                                    <div class="card-category card-placeholder venue-card-image-container rounded-top d-flex justify-content-center">
                                      ${tag.toHtml()}
                                    </div>
                                    <div class="card-body p-3" style="height: 200px; overflow: hidden">
                                      <div class="venue-card-rating">
                                        <i class="fas fa-star mr-1"></i>
                                        <p style="color: black;">${venue["average_rating"]} (${venue["reviews"].length})</p>
                                      </div>
                                      <h5 class="card-title">${venue["name"]}</h5>
                                      <p class="card-text" style="color: black;">${venue["description"]}</p>
                                    </div>
                                    <div class="card-footer" style="height: 80px; overflow: hidden">
                                      <small class="text-muted"> ${venue["category"]} ${venue["location"]}  <i class="fas fa-map-marker-alt"></i></small>
                                    </div>
                                  </div></a>`
              venueList.insertAdjacentHTML("beforeend", venueCard)
            })
          }
        ); 
      }
      // console.log(`7- ${Date.now()}`)
      setTimeout(apiSearch, 2000)



      const filterBtn = document.getElementById('filter-btn')
      if (filterBtn) {    
        filterBtn.onclick = function() {
          let newLocation = document.getElementById('city').value
          if ( newLocation == "" ) {
            newLocation = document.getElementById('city').placeholder
          }
          let category = document.getElementById('_venues_category').value
          let activity = document.getElementById('_venues_activity').value
          let newFilter = `{ "category": "${category}", "activity": "${activity}" }`
          mapElement.setAttribute('data-filter', newFilter)
          geocodingClient.forwardGeocode({
            query: newLocation,
            limit: 1
          })
          .send()
          .then(response => {
            const match = response.body;
            map.setZoom(10)
            map.panTo([match.features[0].center[0],match.features[0].center[1]])
          });
          setTimeout(apiSearch, 500)
        }
      }


    } else {
      map.setCenter({ "lng": markers[0].lng, "lat": markers[0].lat })
      map.setZoom(10)
    }
  }




};

export { initMapbox };
