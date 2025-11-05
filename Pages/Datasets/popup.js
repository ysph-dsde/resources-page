/**
 * This script handles the functionality for a timed feedback popup modal that 
 * appears after a specified delay when users visit the webpage.
 * 
 * It includes the following features:
 *    1. Displaying a feedback popup after a configurable time delay.
 *    2. Opening multiple Microsoft Forms links in new tabs.
 *    3. Closing the modal via the close button (X) in the top-right corner.
 *    4. Closing the modal by clicking outside the popup content area.
 *    5. Auto-closing the modal when users click on any feedback form link.
 *    6. Configurable delay timing with common preset options commented.
 *
 * Author: Shelby Golden, M.S.
 *   Date: November 2025
 * 
 * Note: Written with the assistance of Yale's AI, Clarity.
 */

document.addEventListener("DOMContentLoaded", function() {
    // Set delay time in milliseconds
    // 5 seconds: var delayTime = 5000;
    // 30 seconds: var delayTime = 30000;
    // 1 minute: var delayTime = 60000;
    // 2 minutes: var delayTime = 120000;
    // 3 minutes: var delayTime = 180000; (current setting)
    // 5 minutes: var delayTime = 300000;
    var delayTime = 5000; // Change this to adjust the delay
    
    var formsPopup = document.getElementById("formsPopup");
    var closeBtn = document.querySelector(".close");
    
    // Show the popup after the specified delay
    setTimeout(function() {
        formsPopup.style.display = "block";
    }, delayTime);

    // When the user clicks on close button (X), close the popup
    closeBtn.addEventListener("click", function() {
        formsPopup.style.display = "none";
    });

    // When the user clicks anywhere outside of the popup content, close it
    formsPopup.addEventListener("click", function(event) {
        if (event.target === formsPopup) {
            formsPopup.style.display = "none";
        }
    });
    
    // Optional: Close popup when any form link is clicked
    var formLinks = document.querySelectorAll(".form-link");
    formLinks.forEach(function(link) {
        link.addEventListener("click", function() {
            setTimeout(function() {
                formsPopup.style.display = "none";
            }, 100);
        });
    });
});