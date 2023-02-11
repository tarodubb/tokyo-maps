import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    const bg = document.querySelector('.img-wrapper');
    console.log(bg);
    window.addEventListener('scroll', ()=>{
      bg.style.backgroundSize = 160 - +window.pageYOffset/12 + '%';
      bg.style.opacity = 1 - +window.pageYOffset/700 + '';
    });
  }

  zoom()  {
    console.log("scrolling");
  }
}
