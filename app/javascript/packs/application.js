require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap";
import $ from "jquery"
import "popper.js"
import "../plugins/flatpickr";
import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!

import { initMapbox } from '../plugins/init_mapbox';

initMapbox();

import { initAutocompleteLocation } from "../plugins/init_autocomplete";
import { initAutocompleteCity } from "../plugins/init_autocomplete";
initAutocompleteLocation();
initAutocompleteCity();


  $('[data-toggle="popper"]').popover({
      delay: 0
  })

  $('[data-toggle="modal"]').popover({
      delay: 0
  })
