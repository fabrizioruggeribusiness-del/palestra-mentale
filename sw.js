// Service worker minimale — cache offline della shell
const CACHE = 'player-one-v41';
const ASSETS = ['index.html', 'manifest.json', 'icon.png',
  'scalinata-0.jpg','scalinata-1.jpg','scalinata-2.jpg','scalinata-3.jpg','scalinata-4.jpg',
  'avatar-0-a.png','avatar-0-b.png',
  'avatar-1-a.png','avatar-1-b.png',
  'avatar-2-a.png','avatar-2-b.png',
  'avatar-3-a.png','avatar-3-b.png',
  'avatar-4-a.png','avatar-4-b.png','avatar-4-c.png'];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE).then(c =>
      Promise.all(ASSETS.map(a => c.add(a).catch(() => {})))
    )
  );
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', e => {
  // Solo GET della shell: API Supabase/Anthropic sempre in rete
  if (e.request.method !== 'GET') return;
  const url = new URL(e.request.url);
  if (url.origin !== location.origin) return;
  // L'HTML va chiesto saltando la cache HTTP del browser: GitHub Pages lo serve
  // con max-age=600, quindi senza questo per dieci minuti dopo ogni deploy la
  // "rete" restituisce comunque la versione vecchia e l'app sembra non aggiornarsi.
  // (Le immagini no: lì la cache HTTP fa il suo lavoro e va lasciata lavorare.)
  const isDoc = e.request.mode === 'navigate' || url.pathname.endsWith('/') || url.pathname.endsWith('.html');
  e.respondWith(
    fetch(isDoc ? new Request(url.href, { cache: 'reload' }) : e.request)
      .then(r => { caches.open(CACHE).then(c => c.put(e.request, r.clone())); return r.clone(); })
      .catch(() => caches.match(e.request))
  );
});
