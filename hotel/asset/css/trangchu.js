
const headerSidebar = document.querySelector('.header-sidebar');
const headerMenu = document.querySelector('.header-menu');
const headerClose = document.querySelector('.header-close');

headerMenu.addEventListener('click', () =>{
  headerSidebar.classList.toggle('nav-sidebar')
})

headerClose.addEventListener('click', () =>{
  headerSidebar.classList.toggle('nav-sidebar')
})