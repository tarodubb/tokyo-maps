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
      //Fill each ward with color
      this.map.addLayer(
        {
          'id': 'wards-fill',
          'type': 'fill',
          'source': 'wards',
          'layout': {},
          'paint': {
            'fill-color': '#FF99AF',
            'fill-opacity': [
              'case',
              ['boolean', ['feature-state', 'hover'], false],
              1,
              0.4
            ]
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
      //Extrusion when ward is hovered on
      // this.map.addLayer({
      //   'id': 'ward-extrusion',
      //   'type': 'fill-extrusion',
      //   'source': 'wards',
      //   'paint': {
      //     // Get the `fill-extrusion-color` from the source `color` property.
      //     'fill-extrusion-color': [
      //       'case',
      //       ['boolean', ['feature-state', 'hover'], false],
      //       '#FF99AF',
      //       '#FFD6DF'
      //     ],

      //     'fill-extrusion-height': [
      //       'case',
      //       ['boolean', ['feature-state', 'hover'], false],
      //       1000,
      //       1
      //     ],

      //     'fill-extrusion-base': 0,
      //     // "fill-extrusion-vertical-gradient": true,
      //     // Make extrusions slightly opaque to see through indoor walls.
      //     'fill-extrusion-opacity': [
      //       'case',
      //       ['boolean', ['feature-state', 'hover'], false],
      //       1,
      //       0.2
      //     ]
      //   }
      // });
      //Listener for ward click to go to the show page
      this.map.on("click", "wards-fill", (e) => {
        let ward_name = e.features[0].properties.ward_en;
        this.areasValue.forEach((area) => {
          if (ward_name.toLowerCase() === area.name) {
            window.location.href = `http://localhost:3000/wards/${area.id}`;
          }
        });
      });
      //When hovered on ward opacity will change
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
      //When not hovered opacity returns to normal
      this.map.on("mouseleave", "wards-fill", () => {
        if (this.hoveredStateId !== null) {
          this.map.setFeatureState(
            { source: "wards", id: this.hoveredStateId },
            { hover: false }
          );
        }
        this.hoveredStateId = null;
      });
      //Set space and globe fog colors
      this.map.setFog({
        color: 'rgb(186, 210, 235)', // Lower atmosphere
        'high-color': 'rgb(36, 92, 223)', // Upper atmosphere
        'horizon-blend': 0.02, // Atmosphere thickness (default 0.2 at low zooms)
        'space-color': 'rgb(11, 11, 25)', // Background color
        'star-intensity': 0.6 // Background star brightness (default 0.35 at low zoooms )
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
