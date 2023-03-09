import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // Define the values that can be passed to the controller
  static values = {
    apiKey: String, // a string value for the API key
    areas: Array, // an array of areas
    user: Object
  };

  // Define the HTML elements to be targeted by the controller
  static targets = ["globus", "sortKey"];


  // Declare the class variables
  map = null;
  hoveredStateId = null;


  connect() { // Initial map on home page with fill, hover, and click to show page features
    this.mapInitialize();
    this.mapLoad();

  }
  mapInitialize() {
    if (localStorage.repeater === 'true') {
      document.querySelector(".banner-content").style.opacity = 0;
      let landing_info = document.querySelector(".landing-info");
      landing_info.remove();
      // this.sortFormTarget.style.display = "block";
      this.globusTarget.classList.add("map-full");
      this.globusTarget.classList.remove("map-banner");
      //Clear session storage of user selections on refresh or reload
      sessionStorage.clear()
    }
    let center = [];
    let zoom = 0;
    let pitch = 0;
    if (localStorage.repeater === undefined) {
      center = [139.697988, 35.685098];
      zoom = 4.99;
      pitch = 65;
    }
    else {
      center = [139.749888, 35.639098];
      zoom = 10.4;
      pitch = 20;
    }
    mapboxgl.accessToken = this.apiKeyValue; // Set the Mapbox access token
    this.map = new mapboxgl.Map({
      container: this.globusTarget, // Set the map container
      style: 'mapbox://styles/timchap96/cleky3zxc000g01mxat00cwa8', // Set the map style
      zoom: zoom, // Set the initial zoom level
      center: center, // Set the initial center coordinates
      pitch: pitch,
      projection: "globe", // Set the map projection to globe
      attributionControl: 'false'
    });
    //Set space and globe fog colors
  }
  mapLoad() {
    this.map.on("load", () => {
      // Add source for ward shapes
      this.map.addSource('wards', {
        type: 'geojson',
        data: 'tokyo.geojson'
      });
      this.map.setFog({
        color: 'rgb(186, 210, 235)', // Lower atmosphere
        'high-color': 'rgb(36, 92, 223)', // Upper atmosphere
        'horizon-blend': 0.02, // Atmosphere thickness (default 0.2 at low zooms)
        'space-color': 'rgb(11, 11, 25)', // Background color
        'star-intensity': 0.6 // Background star brightness (default 0.35 at low zooms )
      });
      this.hoveredStateId = null;
      this.addLayers("white", "black", "")
      this.click();
      this.userStep();
      this.hover();
      this.#addUserToMap();
    });
  }

  flyTokyo() {
    document.querySelector(".banner-content").style.display = "none";
    document.querySelector(".landing-info").style.display = "none";
    document.querySelector(".sort").style.opacity = 1;
    // let landing_info = document.querySelector(".landing-info");
    // landing_info.remove();
    // this.sortFormTarget.style.display = "block";
    this.globusTarget.classList.add("map-full");
    this.globusTarget.classList.remove("map-banner");
    this.map.setLayoutProperty('wards-fill', 'visibility', 'visible');
    this.map.setLayoutProperty('wards-outline', 'visibility', 'visible');
    // this.map.setLayoutProperty('ward-extrusion', 'visibility', 'visible');
    this.map.flyTo({
      center: [139.727888, 35.714467],
      zoom: 10.85,
      pitch: 25,
    });
    localStorage.repeater = true;
    this.map.resize()
  }

  selectedSort(e) {
    let rentButtons = document.querySelectorAll(".rent-button");
    let selectedRent = document.querySelector(".selected-rent-target");
    // Set local storage button toggle vals
    if (localStorage.ldkToggle === undefined) {
      localStorage.ldkToggle = false;
    }
    if (localStorage.secondaryToggle === undefined) {
      localStorage.secondaryToggle = false;
    }
    // Check which buttons have been pressed and assign vals to local storage
    if (e.target.id === "one_ldk" || e.target.id === "two_ldk" || e.target.id === "three_ldk") {
      localStorage.ldkToggle = e.target.id
    }
    if (e.target.id === "safety" || e.target.id === "international_schools") {
      console.log(e.target.id);
      localStorage.secondaryToggle = e.target.id
    }
    if (localStorage.ldkToggle !== "false" && localStorage.secondaryToggle !== "false") {
      this.sort(`${localStorage.ldkToggle}_${localStorage.secondaryToggle}_sort_color`);
    }
    else if (localStorage.ldkToggle && localStorage.secondaryToggle === "false") {
      this.sort(`${localStorage.ldkToggle}_sort_color`)
    }
    else {
      this.sort(`${localStorage.secondaryToggle}_sort_color`)
    }
    if (e.target.id === "clear") {
      localStorage.ldkToggle = false;
      localStorage.secondaryToggle = false;
      this.clearLabels();
      rentButtons.forEach(button => {
        button.classList.remove("selected-rent-target");
      })
      this.removeSortLayers();
    }

    // if (rentStatus && safetyStatus) {
    //   let sortSafetyTarget = e.target;
    //   sortSafetyTarget.classList.add("selected-safety-target");
    //   this.sort(`${selectedRent.id}_${sortSafetyTarget.id}_color`, selectedRent.id, sortSafetyTarget.id);
    // }

    // if (e.target.id !== "safety" && safetyStatus === false) {
    //   rentButtons.forEach(button => {
    //     button.classList.remove("selected-rent-target");
    //   })
    //   let sortRentTarget = e.target;
    //   sortRentTarget.classList.add("selected-rent-target")
    //   this.sort(`${sortRentTarget.id}_sort_color`, sortRentTarget.id)
    // }
    // else if (e.target.id === "safety" && selectedRent) {
    //   let sortSafetyTarget = e.target;
    //   sortSafetyTarget.classList.add("selected-safety-target");
    //   this.sort(`${selectedRent.id}_${sortSafetyTarget.id}_color`, selectedRent.id, sortSafetyTarget.id);
    //   safetyStatus = true;
    // }
    // else{
    //   this.sort(e.target.id);
    // }
  }
  sort(sortTarget, sortValue, sortSafety) { // sort function takes user selection from form and sets extrusion height/color based on that data
    let sortKey = sortTarget // Get the selected sorting option's ID
    // this.map.setLayoutProperty("ward-extrusion", "visibility", 'none'); // Hide "ward-extrusion" to hover extrusion doesen't happen
    this.removeSortLayers();
    this.addSortLayers(sortKey, "-sort")
    this.click();
    this.hover();
    console.log(sortKey);
    this.labelChange(localStorage.ldkToggle);
  }
  hover() {
    // this.map.setLayoutProperty("ward-extrusion", "visibility", 'none'); // Hide "ward-extrusion" to hover extrusion doesen't happen
    // this.map.addLayer({
    //   'id': 'ward-sort-extrusion', // Add a new layer with ID "ward-sort-extrusion"
    //   'type': 'fill-extrusion', // The layer type is "fill-extrusion", which is used for creating 3D extrusions on a map
    //   'source': 'wards',
    //   'layout': {
    //     'visibility': 'visible' // Set the layer visibility to "visible"
    //   },
    //   'paint': {
    //     'fill-extrusion-color': [
    //       'case',
    //       ['boolean', ['feature-state', 'hover'], false],
    //       ['get', 'hover-color'],
    //       ['get', 'base-color']
    //     ], // Set the color of the extrusion
    //     'fill-extrusion-height': ['get', `${sortKey}`], // Set the height of the extrusion based on the selected sorting option which gets it from the wards source
    //     'fill-extrusion-base': 0, // Set the base height of the extrusion
    //     'fill-extrusion-opacity': 1 // Set the opacity of the extrusion to 100%
    //   }
    // });
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
  click() {
    // Extrusion when ward is hovered on
    // this.map.addLayer({
    //   'id': 'ward-extrusion',
    //   'type': 'fill-extrusion',
    //   'source': 'wards',
    //   'layout': {
    //     'visibility': 'none'
    //   },
    //   'paint': {
    //     'fill-extrusion-color': [
    //       'case',
    //       ['boolean', ['feature-state', 'hover'], false],
    //       '#FF99AF',
    //       '#FFD6DF'
    //     ],
    //     'fill-extrusion-height': [
    //       'case',
    //       ['boolean', ['feature-state', 'hover'], false],
    //       3000,
    //       1
    //     ],
    //     'fill-extrusion-base': 200,
    //     'fill-extrusion-opacity': 1
    //   }
    // });
    //Listener for ward click to go to the show page
    this.map.on("click", "wards-fill", (e) => {
      let ward_name = e.features[0].properties.ward_en;
      this.areasValue.forEach((area) => {
        if (ward_name.toLowerCase() === area.name) {
          // Get user selections and pass them through to the show page

          let selectedRent = document.querySelector(".selected-rent-target");
          let selectedSafety = document.querySelector(".selected-safety-target");

          if (selectedRent) {
            sessionStorage.setItem("ldkSelection", selectedRent.innerHTML);
          }
          if (selectedSafety) {
            sessionStorage.setItem("safetySelection", selectedSafety.innerHTML);
          }
          window.location.href = `wards/${area.id}`;
        }
      });
    });
  }
  labelChange(val1Sort, val2Sort = null) {
    this.areasValue.forEach((area) => {
      if (val1Sort && val2Sort) {
        this.map.setLayoutProperty('ward_labels', 'text-field', [
          'format',
          ['get', 'ward_en'],
          { 'font-scale': 1.2 },
          '\n',
          {},
          ['get', `${val1Sort}_sort_height`],
          {
            'font-scale': 0.8,
            'text-font': [
              'literal',
              ['DIN Offc Pro Italic', 'Arial Unicode MS Regular']
            ]
          }
          ['get', `${val2Sort}`],
          {
            'font-scale': 0.8,
            'text-font': [
              'literal',
              ['DIN Offc Pro Italic', 'Arial Unicode MS Regular']
            ]
          }
        ]);
      }
      else {
        this.map.setLayoutProperty('ward_labels', 'text-field', [
          'format',
          ['get', 'ward_en'],
          { 'font-scale': 1.2 },
          '\n',
          {},
          ['get', `${val1Sort}_sort_height`],
          {
            'font-scale': 0.8,
            'text-font': [
              'literal',
              ['DIN Offc Pro Italic', 'Arial Unicode MS Regular']
            ]
          }
        ]);
      }
    });
  }
  clearLabels() {
    this.map.setLayoutProperty('ward_labels', 'text-field', [
      'format',
      ['get', 'ward_en'],
      { 'font-scale': 1.0 },
    ]);
  }
  findLabels() {
    const layers = this.map.getStyle().layers;
    // Find the index of the first symbol layer in the map style.
    let firstSymbolId;
    for (const layer of layers) {
      if (layer.type === 'symbol') {
        firstSymbolId = layer.id;
        break;
      }
    }
    return firstSymbolId
  }
  findGeoTag() {
    const marker = this.map.marker.getElement()
  }
  addLayers(baseColor, hoverColor, type) {
    this.removeSortLayers();
    let firstSymbolId = this.findLabels();
    this.map.addLayer({
      'id': `wards${type}-fill`, // Add a new layer with ID "ward-sort-extrusion"
      'type': 'fill', // The layer type is "fill-extrusion", which is used for creating 3D extrusions on a map
      'source': 'wards',
      'layout': {
        'visibility': 'visible' // Set the layer visibility to "visible"
      },
      'paint': {
        'fill-color': [
          'case',
          ['boolean', ['feature-state', 'hover'], false],
          hoverColor,
          baseColor
        ],
        'fill-opacity': 1
      }
    }, firstSymbolId);
    this.map.addLayer({
      id: `wards${type}-outline`,
      type: "line",
      source: "wards",
      'layout': {
      },
      paint: {
        "line-color": "black",
        "line-width": 3,
        "line-opacity": 0.7,
      },
    }, firstSymbolId);
  }
  addSortLayers(sortKey, type) {
    this.removeSortLayers();
    let firstSymbolId = this.findLabels();
    this.map.addLayer({
      'id': `wards${type}-fill`, // Add a new layer with ID "ward-sort-extrusion"
      'type': 'fill', // The layer type is "fill-extrusion", which is used for creating 3D extrusions on a map
      'source': 'wards',
      'layout': {
        'visibility': 'visible' // Set the layer visibility to "visible"
      },
      'paint': {
        'fill-color': [
          'case',
          ['boolean', ['feature-state', 'hover'], false],
          ["get", "hover-color"],
          ["get", `${sortKey}`]
        ],
        'fill-opacity': 1
      }
    }, firstSymbolId);
    this.map.addLayer({
      id: `wards${type}-outline`,
      type: "line",
      source: "wards",
      'layout': {
      },
      paint: {
        "line-color": "black",
        "line-width": 3,
        "line-opacity": 0.7,
      },
    }, firstSymbolId);
  }
  removeSortLayers() {
    if (this.map.getLayer('wards-sort-fill')) { // Check if a layer called "ward-sort-extrusion" already exists in the map
      this.map.removeLayer('wards-sort-fill') // If it does, remove it
      this.map.removeLayer('wards-sort-outline')
    };
  }
  userStep() {
    if (localStorage.repeater === 'true') {
      this.map.setLayoutProperty('wards-fill', 'visibility', 'visible');
      this.map.setLayoutProperty('wards-outline', 'visibility', 'visible');
      // this.map.setLayoutProperty('ward-extrusion', 'visibility', 'visible');
      document.querySelector(".sort").style.opacity = 0.6;
      let bannerContent = document.querySelector(".banner-content");
      bannerContent.remove();
      this.map.resize()
    }
    else {
      let bannerContent = document.querySelector(".banner-content");
      bannerContent.classList.add("transition")
      setTimeout(() => {
        bannerContent.style.opacity = 1;
        document.querySelector(".landing-info").style.display = "flex";
      }, 500)
    }
  }
  #addUserToMap() {
    const customMarker = document.createElement("div")
    customMarker.innerHTML = this.userValue.marker_html

    new mapboxgl.Marker(customMarker)
      .setLngLat(this.userValue.coord)
      .addTo(this.map)
  }
}
