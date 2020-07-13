require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap";
import "@fortawesome/fontawesome-free/css/all.min.css"
import $ from "jquery"
import "popper.js"
import "../plugins/flatpickr";
import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!

import { initMapbox } from '../plugins/init_mapbox';
import { initAutocompleteLocation } from "../plugins/init_autocomplete";
import { initAutocompleteCity } from "../plugins/init_autocomplete";
import { initChatbox } from "../plugins/init_chatbox";
import { initVenueForm } from "../plugins/init_venue_form";
import { scrollLastMessageIntoView } from '../components/scroll';
import "../plugins/input-spinner";



initAutocompleteLocation();
initAutocompleteCity();
initMapbox();
initChatbox();
initVenueForm();


  $('[data-toggle="popper"]').popover({
      delay: 0
  })

  $('[data-toggle="modal"]').popover({
      delay: 0
  })


window.scrollLastMessageIntoView = scrollLastMessageIntoView;
scrollLastMessageIntoView();
