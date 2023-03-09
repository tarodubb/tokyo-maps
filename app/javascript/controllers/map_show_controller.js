import { Controller } from "@hotwired/stimulus";

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
      style: 'mapbox://styles/timchap96/cleky3zxc000g01mxat00cwa8',
      zoom: 11,
      center: [this.areasValue.longitude, this.areasValue.latitude],
      projection: "globe",
    });
    this.map.on("load", () => {
      let foundWard = ""
      let firstSymbolId = this.findLabels();
      this.map.addSource('wards', {
        type: 'geojson',
        data: '/tokyo.geojson'
      });
      let wardName = ""
      const mySentence = this.areasValue.name;
      const words = mySentence.split(" ");

      wardName = words.map((word) => {
        return word[0].toUpperCase() + word.substring(1);
      }).join(" ");
      this.map.addLayer({
        'id': `ward-filter-fill`,
        'type': 'fill',
        'source': 'wards',
        'paint': {
          'fill-color': ['get', `${localStorage.ldkToggle}_sort_color`],
          'fill-opacity': 1,
        },
        'filter': ['==', 'ward_en', wardName]
      }, firstSymbolId);
      this.map.addLayer({
        id: `wards-filter-outline`,
        type: "line",
        source: "wards",
        'layout': {
        },
        paint: {
          "line-color": "black",
          "line-width": 3,
          "line-opacity": 0.7,
        },
        'filter': ['==', 'ward_en', wardName]
      }, firstSymbolId);
      this.getWardColor();
    });
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
  capitalizeEachLetter(string) {
    let wardName = ""
    const words = string.split(" ");
    wardName = words.map((word) => {
      return word[0].toUpperCase() + word.substring(1);
    }).join(" ");
    return wardName
  }
  getWardColor() {
    console.log(this.areasValue.name);
    let wardName = this.capitalizeEachLetter(this.areasValue.name);
    console.log(wardName);
    fetch("/tokyo.geojson")
      .then((response) => response.json())
      .then((data) => {
        data.features.forEach((ward) => {
          if (ward.properties.ward_en == wardName) {
            let wardToggle = `${localStorage.ldkToggle}_sort_color`;
            console.log(wardToggle);
            // console.log(ward.properties.(eval(wardToggle)));
          }
        })
      })
      .catch((error) => console.error(error));

  }

}
