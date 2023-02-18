import { Controller, ValueListObserver } from "@hotwired/stimulus";
// import geojson from "/geocode/toyko.geojson"

export default class extends Controller {
  static values = {
    apiKey: String,
    areas: Array,
  };
  static targets = ["globus"];

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;
    // let list = JSON.parse("../../assets/geocode/tokyo.json")
    // console.log(list)
    // fetch("../../assets/geocode/tokyo.geojson").then(res => console.log(res))
    this.map = new mapboxgl.Map({
      container: this.globusTarget,
      style: "mapbox://styles/mapbox/streets-v10",
      zoom: 1,
      center: [139.697888, 35.685098],
      projection: "globe",
    });
    this.map.on("load", () => {
      this.areasValue.forEach((area) => {
        const geojson = {
          type: "geojson",
          data: {
            type: "Feature",
            geometry: area.geojson,
            properties: {
              name: area.name,
              code: area.code,
            },
          },
        };
        console.log(geojson, area.geojson);
        console.log(geojson, area.name);
        console.log("name");
        this.map.addSource(area.name, geojson);
        // this.map.addSource(area.name, { type: "geojson", data: area.geojson })
        this.map.addLayer({
          id: `${area.name}-fill`,
          type: "fill",
          source: area.name, // reference the data source
          layout: {},
          paint: {
            "fill-color": [
              "match",
              ["get", "name"],
              "ota ku",
              "#FFC2CF",
              "shibuya ku",
              "#FFC2CF",
              "setagaya ku",
              "#FFC2CF",
              "koto ku",
              "#FFC2CF",
              "shinagawa ku",
              "#FFC2CF",
              "meguro ku",
              "#FFC2CF",
              "nakano ku",
              "#FFC2CF",
              "suginami ku",
              "#FFC2CF",
              "toshima ku",
              "#FFC2CF",
              "kita ku",
              "#FFC2CF",
              "arakawa ku",
              "#FFC2CF",
              "itabashi ku",
              "#FFC2CF",
              "nerima ku",
              "#FFC2CF",
              "adachi ku",
              "#FFC2CF",
              "katsushika ku",
              "#FFC2CF",
              "edogawa ku",
              "#FFC2CF",
              "minato ku",
              "#FFC2CF",
              "chuo ku",
              "#FFC2CF",
              "shinjuku ku",
              "#FFC2CF",
              "chiyoda ku",
              "#FFC2CF",
              "bunkyo ku",
              "#FFC2CF",
              "taito ku",
              "#FFC2CF",
              "sumida ku",
              "#FFC2CF",
              "#FFC2CF",
            ],
            "fill-opacity": [
              "case",
              ["boolean", ["feature-state", "hover"], false],
              1,
              0,
            ],
          },
        });

        // Add a black outline around the polygon.
        this.map.addLayer({
          id: `${area.name}-outline`,
          type: "line",
          source: area.name,
          layout: {},
          paint: {
            "line-color": "#000",
            "line-width": 3,
            "line-opacity": 0.7,
          },
        })
        this.map.on('click', (e) => {
          console.log(e);
          // window.location.href = `${area.path}/${area.id}`;
        });

        // let hoveredStateId = null;

        // this.map.on("mousemove", `${area.name}-fill`, (e) => {
        //   console.log(e.features[0],hoveredStateId, area.name);
        //   if (e.features.length > 0) {
        //     if (hoveredStateId !== null) {
        //       this.map.setFeatureState(
        //         { source: area.name, id: hoveredStateId },
        //         { hover: false }
        //       );
        //     }
        //     hoveredStateId =`${e.features[0].layer.id}`;
        //     this.map.setFeatureState(
        //       { source: area.name, id: hoveredStateId },
        //       { hover: true }
        //     );
        //   }
        // });

        // this.map.on("mouseleave", `${area.name}-fill`, () => {
        //   if (hoveredStateId !== null) {
        //     this.map.setFeatureState(
        //       { source: area.name, id: hoveredStateId },
        //       { hover: false }
        //     );
        //   }
        //   hoveredStateId = null;
        // });

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
