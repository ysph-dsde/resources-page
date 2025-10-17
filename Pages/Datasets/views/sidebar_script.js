// views/sidebar_script.js

document.addEventListener("DOMContentLoaded", function() {
  console.log("DOM fully loaded");

  // Correctly target the sidebar toggler and wrapper
  const sidebarToggler = document.querySelector(".sidebar-toggler");
  const sidebarWrapper = document.querySelector(".sidebar-wrapper");

  console.log("sidebarToggler:", sidebarToggler);  // Should log the element or null
  console.log("sidebarWrapper:", sidebarWrapper);  // Should log the element or null

  // Check if elements exist and add event listener for the toggler
  if (sidebarToggler && sidebarWrapper) {
    sidebarToggler.addEventListener("click", function() {
      console.log("Sidebar toggler clicked");
      sidebarWrapper.classList.toggle("show");
      sidebarWrapper.classList.toggle("hidden");
    });
  } else {
    console.error("Sidebar toggler or sidebar wrapper not found.");
  }
});