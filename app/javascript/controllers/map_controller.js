

import { Controller } from "@hotwired/stimulus"
// import geojson from "/geocode/toyko.geojson"

export default class extends Controller {
  static values = {
    apiKey: String,
    areas: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    // let list = JSON.parse("../../assets/geocode/tokyo.json")
    // console.log(list)
    // fetch("../../assets/geocode/tokyo.geojson").then(res => console.log(res))
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })
    this.map.on('load', () => {
      this.areasValue.forEach((area)=> {

        const geojson ={
          'type': 'geojson',
          'data': {
              'type': 'Feature',
              'geometry': area.geojson
          }
        }
        console.log(geojson, area.name)
        this.map.addSource(area.name, geojson)
      });
    })
  }
}
