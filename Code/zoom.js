/**
 * This script handles the functionality for a modal image viewer with zoom and 
 * pan capabilities. Works when the user clicks on the image embedded on a page.
 * 
 * It includes the following features:
 *    1. Opening and closing the modal.
 *    2. Centering the image initially.
 *    3. Zooming in and out using the mouse wheel.
 *    4. Panning the zoomed-in image by dragging it with the mouse.
 *    5. Enforcing minimum and maximum zoom levels set via data attributes on 
 *       the container element.
 *
 * Author: Shelby Golden, M.S.
 *   Date: September 2025
 * 
 * Note: Written with the assistance of Yale's AI, Clarity.
 */

// Initial scale and pan values for the image
let scale = 1;
let panX = 0;
let panY = 0;

// Get the container element and read the data attributes for min and max scales
const container = document.querySelector('.container');
const minScale = parseFloat(container.getAttribute('data-min-scale')) || 1;
const maxScale = parseFloat(container.getAttribute('data-max-scale')) || 3;

// Get modal elements by their IDs
const modal = document.getElementById("myModal");
const img = document.getElementById("myImage");
const modalImg = document.getElementById("img01");
const captionText = document.getElementById("caption");

// Open the modal and display the clicked image with its caption when the image is clicked
img.onclick = function () {
  modal.style.display = "block";
  modalImg.src = this.src;
  captionText.innerHTML = this.alt;
  centerImage(); // Center the image initially
};

// Get the span element that closes the modal
const span = document.getElementsByClassName("close")[0];
span.onclick = function () {
  modal.style.display = "none";
  resetZoomAndPan();
};

// Close the modal when clicking outside the image
modal.onclick = function (event) {
  if (event.target == modal) {
    modal.style.display = "none";
    resetZoomAndPan();
  }
};

// Center the image by resetting the zoom and pan values
function centerImage() {
  resetZoomAndPan();
}

// Reset zoom and pan values to their defaults
function resetZoomAndPan() {
  scale = 1;
  panX = 0;
  panY = 0;
  updateTransform();
}

// Handle mouse wheel events for zooming
modalImg.onwheel = function (event) {
  event.preventDefault();
  const rect = modalImg.getBoundingClientRect();
  const { clientX: mouseX, clientY: mouseY } = event; 
  const dx = (mouseX - rect.left - rect.width / 2) / scale;
  const dy = (mouseY - rect.top - rect.height / 2) / scale;
  const prevScale = scale;
  const zoomIntensity = 0.1;

  // Adjust the scale based on the wheel scroll direction
  scale += event.deltaY > 0 ? -zoomIntensity : zoomIntensity;
  scale = Math.max(minScale, Math.min(maxScale, scale));

  // Adjust pan to maintain the position relative to the image center
  panX -= dx * (scale - prevScale);
  panY -= dy * (scale - prevScale);

  updateTransform();
};

// Handle mouse down events for panning
modalImg.onmousedown = function (event) {
  event.preventDefault();
  const startX = event.clientX;
  const startY = event.clientY;
  const startPanX = panX;
  const startPanY = panY;

  // Define the mouse move event handler for panning
  function onMouseMove(e) {
    panX = startPanX + (e.clientX - startX);
    panY = startPanY + (e.clientY - startY);
    updateTransform();
  }

  // Define the mouse up event handler to remove the move event listeners
  function onMouseUp() {
    document.removeEventListener("mousemove", onMouseMove);
    document.removeEventListener("mouseup", onMouseUp);
  }

  // Add the event listeners for mouse movement and release
  document.addEventListener("mousemove", onMouseMove);
  document.addEventListener("mouseup", onMouseUp);
};

// Update the transform CSS property to apply zoom and pan effects
function updateTransform() {
  const rect = modalImg.getBoundingClientRect();
  const modalRect = modal.getBoundingClientRect();

  // If the scale is less than or equal to 1, reset pan values
  if (scale <= 1) {
    panX = 0;
    panY = 0;
  } else {
    // Ensure the image doesn't pan out of the modal bounds
    panX = Math.min(
      Math.max(panX, (modalRect.width - rect.width * scale) / 2),
      (rect.width * scale - modalRect.width) / 2
    );
    panY = Math.min(
      Math.max(panY, (modalRect.height - rect.height * scale) / 2),
      (rect.height * scale - modalRect.height) / 2
    );
  }

  // Apply the transform style to the image
  modalImg.style.transform = `translate(${panX}px, ${panY}px) scale(${scale}) translate(-50%, -50%)`;
}