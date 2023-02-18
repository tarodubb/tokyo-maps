# <body>
# <div id="container">
# <button id="fly-to-tokyo">Fly to Tokyo</button>
# <button id="reset-view">Reset</button>
# </div>
# </body>




# # //fly to Tokyo/add after the map loads
# document.querySelector('#fly-to-tokyo').addEventListener('click', () => {
#   this.map.flyTo({
#     center: [139.697888, 35.685098],
#     zoom: 10,
#     pitch: 45
#   })
# })

# # //reset the map view
# document.querySelector('#reset-view').addEventListener('click', () => {
#   this.map.flyTo({
#     center: INITIAL_CENTER,
#     zoom: INITIAL_ZOOM,
#     pitch: 0
#   })
# })
