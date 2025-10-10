let scale = 1;
let panX = 0;
let panY = 0;

// Get the container element and read the data attributes
const container = document.querySelector('.container');
const minScale = parseFloat(container.getAttribute('data-min-scale')) || 1;
const maxScale = parseFloat(container.getAttribute('data-max-scale')) || 3;

// Get modal elements
const modal = document.getElementById("myModal");
const img = document.getElementById("myImage");
const modalImg = document.getElementById("img01");
const captionText = document.getElementById("caption");

img.onclick = function () {
  modal.style.display = "block";
  modalImg.src = this.src;
  captionText.innerHTML = this.alt;
  centerImage(); // Center the image initially
};

const span = document.getElementsByClassName("close")[0];
span.onclick = function () {
  modal.style.display = "none";
  resetZoomAndPan();
};

modal.onclick = function (event) {
  if (event.target == modal) {
    modal.style.display = "none";
    resetZoomAndPan();
  }
};

function centerImage() {
  resetZoomAndPan();
}

function resetZoomAndPan() {
  scale = 1;
  panX = 0;
  panY = 0;
  updateTransform();
}

modalImg.onwheel = function (event) {
  event.preventDefault();
  const rect = modalImg.getBoundingClientRect();
  const { clientX: mouseX, clientY: mouseY } = event;
  const dx = (mouseX - rect.left - rect.width / 2) / scale;
  const dy = (mouseY - rect.top - rect.height / 2) / scale;
  const prevScale = scale;
  const zoomIntensity = 0.1;

  scale += event.deltaY > 0 ? -zoomIntensity : zoomIntensity;
  scale = Math.max(minScale, Math.min(maxScale, scale));

  panX -= dx * (scale - prevScale);
  panY -= dy * (scale - prevScale);

  updateTransform();
};

modalImg.onmousedown = function (event) {
  event.preventDefault();
  const startX = event.clientX;
  const startY = event.clientY;
  const startPanX = panX;
  const startPanY = panY;

  function onMouseMove(e) {
    panX = startPanX + (e.clientX - startX);
    panY = startPanY + (e.clientY - startY);
    updateTransform();
  }

  function onMouseUp() {
    document.removeEventListener("mousemove", onMouseMove);
    document.removeEventListener("mouseup", onMouseUp);
  }

  document.addEventListener("mousemove", onMouseMove);
  document.addEventListener("mouseup", onMouseUp);
};

function updateTransform() {
  const rect = modalImg.getBoundingClientRect();
  const modalRect = modal.getBoundingClientRect();

  if (scale <= 1) {
    panX = 0;
    panY = 0;
  } else {
    panX = Math.min(
      Math.max(panX, (modalRect.width - rect.width * scale) / 2),
      (rect.width * scale - modalRect.width) / 2
    );
    panY = Math.min(
      Math.max(panY, (modalRect.height - rect.height * scale) / 2),
      (rect.height * scale - modalRect.height) / 2
    );
  }

  modalImg.style.transform = `translate(${panX}px, ${panY}px) scale(${scale}) translate(-50%, -50%)`;
}