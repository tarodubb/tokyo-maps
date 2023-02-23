import { Controller, ValueListObserver } from "@hotwired/stimulus";

export default class extends Controller {
  // Define the values that can be passed to the controller
  static values = {
    apiKey: String, // a string value for the API key
    areas: Array, // an array of areas
  };

  // Define the HTML elements to be targeted by the controller
  static targets = ["globus", "sortKey"];

  // Declare the class variables
  map = null;
  hoveredStateId = null;

  connect() { // Initial map on home page with fill, hover, and click to show page features
    let map_style = "";
    mapboxgl.accessToken = this.apiKeyValue; // Set the Mapbox access token
    this.map = new mapboxgl.Map({
      container: this.globusTarget, // Set the map container
      style: 'mapbox://styles/timchap96/cle9d1pes000201ltisdfvwnm', // Set the map style
      zoom: 1, // Set the initial zoom level
      center: [139.697888, 35.685098], // Set the initial center coordinates
      projection: "globe", // Set the map projection to globe
    });
    this.hoveredStateId = null;
      this.map.on("load", () => {
        // Add source for ward shapes
        this.map.addSource('wards', {
          type: 'geojson',
          data: 'tokyo.geojson'
        });
        // Add source for ward labels
        this.map.addSource('ward-labels', {
          type: 'geojson',
          data: 'labels.geojson'
        })
        // Fill each ward with color
        this.map.addLayer({
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
        // Set the border
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
        // Extrusion when ward is hovered on
        this.map.addLayer({
          'id': 'ward-extrusion',
          'type': 'fill-extrusion',
          'source': 'wards',
          'layout': {
            'visibility': 'visible'
          },
          'paint': {
            'fill-extrusion-color': [
              'case',
              ['boolean', ['feature-state', 'hover'], false],
              '#FF99AF',
              '#FFD6DF'
            ],
            'fill-extrusion-height': [
              'case',
              ['boolean', ['feature-state', 'hover'], false],
              3000,
              1
            ],
            'fill-extrusion-base': 200,
            'fill-extrusion-opacity': 1
          }
        });
        //Listener for ward click to go to the show page
        this.map.on("click", "wards-fill", (e) => {
          debugger;
          let ward_name = e.features[0].properties.ward_en;
          this.areasValue.forEach((area) => {
            if (ward_name.toLowerCase() === area.name) {
              window.location.href = `wards/${area.id}`;
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
        //Place labels
        this.map.addLayer({
          'id': 'ward-labels',
          'type': 'symbol',
          'source': 'ward-labels',
          'minzoom': 2,
          'layout': {
            'text-field': ['get', 'ward_en'],
            'text-variable-anchor': ['top', 'bottom', 'left', 'right'],
            // 'text-radial-offset': 0.5,
            'text-justify': 'auto'
            // 'icon-image': ['get', 'icon']
          },
          'paint': {
            'text-color': '#290009'
          }
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
  sort() { // sort function takes user selection from form and sets extrusion height/color based on that data
    if (this.map.getLayer('ward-sort-extrusion')) { // Check if a layer called "ward-sort-extrusion" already exists in the map
      this.map.removeLayer('ward-sort-extrusion') // If it does, remove it
    };
    let sortKey = this.sortKeyTarget.selectedOptions[0].id // Get the selected sorting option's ID
    this.map.setLayoutProperty("ward-extrusion", "visibility", 'none'); // Hide "ward-extrusion" to hover extrusion doesen't happen
    this.map.addLayer({
      'id': 'ward-sort-extrusion', // Add a new layer with ID "ward-sort-extrusion"
      'type': 'fill-extrusion', // The layer type is "fill-extrusion", which is used for creating 3D extrusions on a map
      'source': 'wards',
      'layout': {
        'visibility': 'visible' // Set the layer visibility to "visible"
      },
      'paint': {
        'fill-extrusion-color': [
          'case',
          ['boolean', ['feature-state', 'hover'], false],
          ['get', 'hover-color'],
          ['get', 'base-color']
        ], // Set the color of the extrusion
        'fill-extrusion-height': ['get', `${sortKey}`], // Set the height of the extrusion based on the selected sorting option which gets it from the wards source
        'fill-extrusion-base': 0, // Set the base height of the extrusion
        'fill-extrusion-opacity': 1 // Set the opacity of the extrusion to 100%
      }
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
  }

}
