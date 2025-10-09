
let kittens = []; // definita globalmente

const gallery = document.getElementById('gallery');
const overlay = document.getElementById('overlay');
const modalImg = document.getElementById('modalImg');
const modalName = document.getElementById('modalName');
const modalDesc = document.getElementById('modalDesc');
const modalTags1 = document.getElementById('modalTags1');
const modalTags2 = document.getElementById('modalTags2');
const closeBtn = document.getElementById('closeBtn');
const searchInput = document.getElementById('search');
const randomBtn = document.getElementById('randomBtn');

// carica i dati da data.json
fetch('assets/data.json')
    .then(res => res.json())
    .then(data => {
        kittens = data.kittens;
        renderGallery(kittens); // renderizza dopo il fetch
    });

// renderizza la gallery
function renderGallery(list) {
    gallery.innerHTML = '';
    if(list.length === 0){
        gallery.innerHTML = '<p style="color: #ccc; text-align:center;">Nessun gatto trovato.</p>';
        return;
    }
    list.forEach(cat => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
          <img src="${cat.img}" alt="${cat.name}" />
          <h2>${cat.name}</h2>
          <p>${cat.desc}</p>
        `;
        card.addEventListener('click', () => openModal(cat));
        gallery.appendChild(card);
    });
}

// apri modal
function openModal(cat) {
    modalImg.src = cat.img;
    modalName.textContent = cat.name;
    modalDesc.textContent = cat.desc;
    modalTags1.textContent = "#" + cat.tags[0];
    modalTags2.textContent = "#" + cat.tags[1];
    overlay.classList.add('open');
}

// chiudi modal
closeBtn.addEventListener('click', () => overlay.classList.remove('open'));
overlay.addEventListener('click', e => {
    if (e.target === overlay) overlay.classList.remove('open');
});
document.addEventListener('keydown', e => {
    if (e.key === 'Escape') overlay.classList.remove('open');
});

// ricerca
searchInput.addEventListener('input', e => {
    const q = e.target.value.toLowerCase();
    const filtered = kittens.filter(cat =>
        cat.name.toLowerCase().includes(q) ||
        cat.tags.some(t => t.toLowerCase().includes(q))
    );
    renderGallery(filtered);
});

// gatto random
randomBtn.addEventListener('click', () => {
    if(kittens.length === 0) return;
    const randomCat = kittens[Math.floor(Math.random() * kittens.length)];
    openModal(randomCat);
});
