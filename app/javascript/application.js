// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "bootstrap"
import "./functions/findBiggest"
import 'slick-carousel'
//= require slick

$(document).ready(function() {
  $('.carousel').slick({
    // Slick options go here
  });
});
