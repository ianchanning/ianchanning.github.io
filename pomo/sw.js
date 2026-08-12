const CACHE_NAME = "pomo-v5";
const APP_SHELL = [
  "./",
  "./index.html",
  "./site.webmanifest",
  "./main.js",
  "./app.js",
  "./quotes/bacon.txt",
  "./quotes/eddie.txt",
  "./quotes/soap.txt",
  "./quotes/tom.txt",
  "./quotes/rory_breaker.txt",
  "./audio/alarm-clock-01.mp3",
  "./audio/alarm-clock-01.ogg",
  "./images/android-chrome-192x192.png",
  "./images/android-chrome-512x512.png",
  "./images/apple-touch-icon.png",
  "./images/favicon-16x16.png",
  "./images/favicon-32x32.png",
  "./images/favicon.ico",
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return Promise.allSettled(APP_SHELL.map((asset) => cache.add(asset)));
    }),
  );
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    Promise.all([
      caches.keys().then((cacheNames) => {
        return Promise.all(
          cacheNames
            .filter((cacheName) => cacheName !== CACHE_NAME)
            .map((cacheName) => caches.delete(cacheName)),
        );
      }),
      self.clients.claim(),
    ]),
  );
});

self.addEventListener("fetch", (event) => {
  if (event.request.method !== "GET") {
    return;
  }

  const requestUrl = new URL(event.request.url);
  if (requestUrl.origin !== self.location.origin) {
    return;
  }

  event.respondWith(
    fetch(event.request)
      .then((response) => {
        if (response.ok) {
          const responseToCache = response.clone();
          caches.open(CACHE_NAME).then((cache) => {
            cache.put(event.request, responseToCache);
          });
        }
        return response;
      })
      .catch(async (error) => {
        const cachedResponse = await caches.match(event.request);
        if (cachedResponse) {
          return cachedResponse;
        }
        throw error;
      }),
  );
});
