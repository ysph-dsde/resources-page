document.addEventListener('DOMContentLoaded', () => {
  const sidebarToggler = document.querySelector('.sidebar-toggler');
  const sidebarWrapper = document.querySelector('.sidebar-wrapper');

  console.log('sidebarToggler:', sidebarToggler); // Log for debugging
  console.log('sidebarWrapper:', sidebarWrapper); // Log for debugging

  if (sidebarToggler && sidebarWrapper) {
    sidebarToggler.addEventListener('click', () => {
      sidebarWrapper.classList.toggle('expanded');
    });
  } else {
    console.error('Sidebar toggler or wrapper not found');
  }
});