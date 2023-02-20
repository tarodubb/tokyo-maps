import { Controller, ValueListObserver } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    apiKey: String,
    areas: Array,
  };
  static targets = ["globus"];
  map = null;
  hoveredStateId = null;

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;
    this.map = new mapboxgl.Map({
      container: this.globusTarget,
      style: 'mapbox://styles/timchap96/cle9d1pes000201ltisdfvwnm',
      zoom: 1,
      center: [139.697888, 35.685098],
      projection: "globe",
    });
    this.hoveredStateId = null;

    this.map.on("load", () => {
      this.map.addSource('wards', {
        type: 'geojson',
        data: 'tokyo.geojson',
      });
      console.log('success')
      this.map.addLayer(
        {
          'id': 'wards-fill',
          'type': 'fill',
          'source': 'wards',
          'layout': {},
          'paint': {
            'fill-color': '#f08',
            'fill-opacity': [
              'case',
              ['boolean', ['feature-state', 'hover'], false],
              1,
              0.4
            ]
          }
        });
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
      this.map.on("click", "wards-fill", (e) => {
        let ward_name = e.features[0].properties.ward_en;
        areasValue.forEach((area) => {
          if (ward_name.toLowerCase() === area.name) {
            window.location.href = `http://localhost:3000/wards/${area.id}`;
          }
        });
      });

      this.map.on("mousemove", "wards-fill", (e) => {
        if (e.features.length > 0) {
          if (this.hoveredStateId !== null) {
            this.map.setFeatureState(
              { source: "wards", id: this.hoveredStateId },
              { hover: false }
            );
          }
          this.hoveredStateId = e.features[0].id;
          this.map.setFeatureState(
            { source: "wards", id: this.hoveredStateId },
            { hover: true }
          );
        }
      });

      this.map.on("mouseleave", "wards-fill", () => {
        if (this.hoveredStateId !== null) {
          this.map.setFeatureState(
            { source: "wards", id: this.hoveredStateId },
            { hover: false }
          );
        }
        this.hoveredStateId = null;
      });

    });
  }
  flyTokyo() {
    console.log("hello");
    this.map.flyTo({
      center: [139.697888, 35.685098],
      zoom: 10,
      pitch: 45,
    });
  }
  reset() {
    this.map.flyTo({
      center: [139.697888, 35.685098],
      zoom: 1,
      pitch: 0,
    });
  }
}
