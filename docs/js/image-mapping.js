// Provide a function to map unoptimized-to-optimized image URLs.

/**
 * Function to load and process image data
 *
 * @param {string} imageServerDomain - The domain of the image server
 *   For example 'https://images.example.com/' or 'http://localhost:8705/'.
 * @param {string} imageFileUrl - The URL of the JSON file containing the image
 *   mapping. For example '/unversioned-image-mapping.json'.
 */
 function loadImages(imageServerDomain, imageFileUrl) {
  // Select all <img> elements in the document
  const images = document.querySelectorAll('img');

  // Fetch the JSON file once
  fetch(imageFileUrl)
      .then(response => {
          if (!response.ok) {
              throw new Error('Failed to fetch JSON');
          }
          return response.json();
      })
      .then(mappingData => {
          // Iterate over each <img> element
          images.forEach(img => {
              // Read data attributes
              const dataSrc = img.getAttribute('data-src');
              const dataSize = img.getAttribute('data-size');
              const lightboxAnchor = img.closest('a');
              let imgSrc = "";
              if (!dataSrc) {
                return;
              }

              // Get optimized image URL from mapping data
              let optimizedSrc = mappingData[dataSrc.replace('/media', '')];

              if (optimizedSrc && optimizedSrc[dataSize]) {
                const secureurlpart = optimizedSrc[dataSize]
                // Construct the optimized URL
                const optimizedURL = `${secureurlpart}`;
                imgSrc = imageServerDomain + optimizedURL;
              }
              else {
                // using imageFileUrl, we cannot map the unoptimized image to
                // an optimized image. We will use the original image.
                console.log("Optimized image path not found; we will output the list of available sizes, and the requested size. It is possible that the requested size has not been generated and should be.");
                console.log(optimizedSrc);
                console.log(dataSize);
                imgSrc = dataSrc;
              }
              // Update img src with optimized URL
              img.src = imgSrc;
              lightboxAnchor.href = imgSrc;
          });
      })
      .catch(error => {
          console.error('Error fetching or processing JSON:', error);
          // Optionally handle error, e.g., set a fallback image for all images
      });
}
