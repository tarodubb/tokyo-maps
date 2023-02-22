import { Controller, ValueListObserver } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    apiKey: String,
    areas: Object,
  };
  static targets = ["globus"];
  map = null;
  hoveredStateId = null;
  connect() {
    mapboxgl.accessToken = this.apiKeyValue;
    this.map = new mapboxgl.Map({
      container: this.globusTarget,
      style: 'mapbox://styles/mapbox/light-v11',
      zoom: 11,
      center: [this.areasValue.longitude, this.areasValue.latitude],
      projection: "globe",
    });
    this.map.on("load", () => {

      //Add source for ward shapes
      this.map.addSource('wards', {
        type: 'geojson',
        data: '../tokyo.geojson'
      });
      //Add source for ward labels
      this.map.addSource('ward-labels', {
        type: 'geojson',
        data: '../labels.geojson'
      })

      //Fill each ward with color

      this.map.addLayer(
        {
          'id': 'wards-fill',
          'type': 'fill',
          'source': 'wards',
          'layout': {},
          'paint': {
            'fill-color': '#FF99AF',
            'fill-opacity': 1
          }
        });
      //Set the border
      this.map.addLayer({
        id: "wards-outline",
        type: "line",
        source: "wards",
        layout: {},
        paint: {
          "line-color": "#000",
          "line-width": 3,
          "line-opacity": 0.7,
        },
      });
    });

  }
  findWard() {
    wards_geojson = File.read("../tokyo.geojson")
    wards_parsed_geojson = JSON.parse(wards_geojson)
    wards_parsed_geojson["feature"].forEach((ward) => {
      if (ward["properties"]["ward_en"].downcase === this.areasValue.name) {
        return ward;
      }
    });
  }
}
