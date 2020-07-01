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
          console.log(match)
          map.setZoom(12)
          map.setCenter([match.features[0].center[0], match.features[0].center[1]])
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
              const customImageTag = (venue) => {
                let result = ''
                if (venue["venue_images"].length > 0) {
                  result = `<img src=${venue['venue_images'][venue["venue_images"].length - 1]} alt="" class="d-block w-100 venue-carousel-image" />`
                } else {
                  result = `<img class="d-block w-100 venue-carousel-image" style="height: 230px;" src="https://images.unsplash.com/photo-1519226612673-73c0234437ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60" alt="Card image cap">`                       
                }
                return result           
              }
              const imageList = (venue) => {
                let result = ''
                venue["venue_images"].forEach((photo) => {
                  result = result + `\n <div class="carousel-item" data-interval="2000">
                  <img src="${photo}" class="d-block w-100 venue-carousel-image" />
                  </div>`})
                return result
              }
              const venueCard = `
                                  <div class="row shadow-sm bg-white rounded venue-card">
                                    <div class="col-12 col-lg-4 p-0 rounded-left overflow-hidden">  
                                      <div id="carouselExampleFade-${venue["id"]}" class="carousel slide carousel-fade rounded" data-ride="carousel">
                                        <div class="carousel-inner">
                                          <div class="carousel-item active" data-interval="10000">
                                            ${ customImageTag(venue) }
                                          </div>
                                          ${ imageList(venue) }
                                        </div>
                                        <a class="carousel-control-prev" href="#carouselExampleFade-${venue["id"]}" role="button" data-slide="prev">
                                          <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                          <span class="sr-only">Previous</span>
                                        </a>
                                        <a class="carousel-control-next" href="#carouselExampleFade-${venue["id"]}" role="button" data-slide="next">
                                          <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                          <span class="sr-only">Next</span>
                                        </a>
                                      </div>
                                    </div>
                                    <a href="/venues/${venue["id"]}" class="col-12 col-lg-8 venue-card-content">
                                      <div class="row venue-card-body p-3" style="height: 180px; overflow: hidden">
                                        <h6 class="card-title mb-1">${venue["name"]}</h6>
                                        <h7 class="card-text" style="color: black;">${venue["description"]}</h7>
                                      </div>
                                      <div class="row venue-card-footer rounded" style="height: 100px; overflow: hidden">
                                        <small class="col-9 text-muted"> 
                                          ${venue["category"]} ${venue["location"]}
                                          <i class="fas fa-map-marker-alt"></i>
                                        </small>
                                        <div class="col-3 d-flex justify-content-center align-items-center">
                                          <div class="venue-card-rating">
                                            <div class="d-flex"><i class="fas fa-star mr-1 my-auto"></i><p style="color: black;">${venue["average_rating"]}</p></div>
                                            <p style="color: black;">(${venue["reviews"].length})</p>
                                          </div>
                                        </div>
                                      </div>
                                    </a>
                                  </div>
                                <hr class="divider divider-fade" />`

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
            map.setZoom(12)
            map.panTo([match.features[0].center[0],match.features[0].center[1]])
          });
          setTimeout(apiSearch, 500)
        }
      }

      map.on('dragend', function(e) {
        setTimeout(apiSearch, 1000)
      })

      map.on('zoomend', function(e) {
        setTimeout(apiSearch, 1000)
      })


    } else {
      map.setZoom(12)
      map.setCenter({ "lng": markers[0].lng, "lat": markers[0].lat })
    }
  }




};

export { initMapbox };
