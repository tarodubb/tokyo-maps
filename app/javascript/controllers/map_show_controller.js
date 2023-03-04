import { Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    apiKey: String,
    areas: Object,
  };
  static targets = ["globus"];
  map = null;
  hoveredStateId = null;
  connect() {
    console.log(this.globusTarget);
    mapboxgl.accessToken = this.apiKeyValue;
    this.map = new mapboxgl.Map({
      container: this.globusTarget,
      style: 'mapbox://styles/timchap96/cleky3zxc000g01mxat00cwa8',
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
            'fill-opacity': 0.6
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
      //Place labels
      this.map.addLayer({
        'id': 'ward-labels',
        'type': 'symbol',
        'source': 'ward-labels',
        'minzoom': 2,
        'layout': {
          'text-field': ['get', 'ward_en'],
          'text-variable-anchor': ['top'],
          // 'text-radial-offset': 0.5,
          'text-justify': 'auto'
          // 'icon-image': ['get', 'icon']
        },
        'paint': {
          'text-color': '#290009'
        }
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
