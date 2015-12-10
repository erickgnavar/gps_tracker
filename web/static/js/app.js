// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

import L from 'leaflet'

let channel = socket.channel('tracking:home', {})
channel.join()
  .receive('ok', resp => { console.log('Joined successfully', resp) })
  .receive('error', resp => { console.log('Unable to join', resp) })

let map = L.map('map', {}).setView([-12.043333, -77.028333], 12)
let markers = {}

L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
}).addTo(map)

function putMarker(data) {
  if (typeof data.vehicle_id === 'undefined') {
    return
  }
  let key = data.vehicle_id.toString()
  if (Object.keys(markers).indexOf(key) !== -1) {
    markers[key].setLatLng([data.latitude, data.longitude])
  } else {
    let icon = L.icon({
      iconUrl: '/images/car.png'
    })
    let marker = L.marker([data.latitude, data.longitude], {
      icon: icon
    })
    marker.addTo(map)
    marker.on('click', e => {
      L.popup()
        .setLatLng(e.latlng)
        .setContent(`
          Vehicle ${data.vehicle_id} latlng: (${data.latitude}, ${data.longitude})
        `)
        .openOn(map)
    })
    markers[key] = marker
  }
}

channel.on('new_location', payload => {
  putMarker(payload)
})
