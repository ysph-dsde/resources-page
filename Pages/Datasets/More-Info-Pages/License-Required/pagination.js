/**
 * This script handles client-side pagination for a list of citations displayed
 * on a webpage. It controls the visibility of citation items based on the current page.
 * 
 * Functionality includes:
 *    1. Determining the number of pages based on the number of citation items.
 *    2. Updating the display of citations when the page changes.
 *    3. Handling next and previous page navigation.
 *
 * Author: Shelby Golden, M.S.
 *   Date: May 2025
 * 
 * Note: Written with the assistance of Yale's AI, Clarity.
 */

document.addEventListener("DOMContentLoaded", function() {
  let currentPage = 1; // Initialize the current page
  const itemsPerPage = 3; // Number of citation items to display per page
  const citationsContent = document.getElementById("citations-content");

  if (citationsContent) {
    // Calculate the total number of pages
    const numPages = Math.ceil(citationsContent.children.length / itemsPerPage);

    // Function to update the citation items based on the current page
    function updateCitations() {
      const items = citationsContent.children;
      for (let i = 0; i < items.length; i++) {
        // Display only the items that belong to the current page
        items[i].style.display = (i >= (currentPage - 1) * itemsPerPage && i < currentPage * itemsPerPage) ? "list-item" : "none";
      }
    }

    // Function to go to the next page
    function nextPage() {
      if (currentPage < numPages) {
        currentPage++;
        updateCitations();
      }
    }

    // Function to go to the previous page
    function prevPage() {
      if (currentPage > 1) {
        currentPage--;
        updateCitations();
      }
    }

    // Initial call to display the first set of citation items on page load
    updateCitations();

    // Attach the next and previous page functions to the window object for button actions
    window.nextPage = nextPage;
    window.prevPage = prevPage;
  }
});