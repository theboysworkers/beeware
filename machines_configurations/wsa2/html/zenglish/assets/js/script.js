// -------------------- ELEMENTI DOM --------------------
const italianEl = document.getElementById('italian-word');
const wordTypeEl = document.getElementById('word-type');
const answerEl = document.getElementById('answer');
const scoreEl = document.getElementById('score');
const remainingEl = document.getElementById('remaining');
const accuracyEl = document.getElementById('accuracy');
const prevEl = document.getElementById('previous');

const newBtn = document.getElementById('new-btn');
const checkBtn = document.getElementById('check-btn');
const showBtn = document.getElementById('show-btn');
const resetBtn = document.getElementById('reset-btn');
const categorySelect = document.getElementById('category');

// -------------------- VARIABILI GLOBALI --------------------
let currentCategory = '';
let queue = [];
let pos = 0;
let score = 0;
let totalAttempts = 0;
let correctAttempts = 0;
let prevCard = null;
let userId = null;
let currentCategoryId = null; // per statistiche

// -------------------- CARICA CATEGORIE --------------------
async function loadCategories() {
  try {
    const res = await fetch('server.php?action=categories');
    const data = await res.json();
    categorySelect.innerHTML = '';

    data.forEach(cat => {
      const opt = document.createElement('option');
      opt.value = cat;
      opt.textContent = cat;
      categorySelect.appendChild(opt);
    });

    if (data.length > 0) {
      currentCategory = data[0];
      loadWords();
    }
  } catch (err) {
    console.error('Errore caricamento categorie:', err);
    italianEl.textContent = "❌ Errore caricamento categorie";
  }
}

// -------------------- CARICA PAROLE --------------------
async function loadWords() {
  try {
    const res = await fetch(`server.php?categoria=${encodeURIComponent(currentCategory)}`);
    const data = await res.json();

    if (!data || data.length === 0) {
      italianEl.textContent = "⚠️ Nessuna parola trovata";
      wordTypeEl.textContent = 'Tipo: —';
      return;
    }

    queue = [...data].sort(() => Math.random() - 0.5);
    pos = 0;
    score = 0;
    totalAttempts = 0;
    correctAttempts = 0;
    prevCard = null;
    prevEl.innerHTML = '';
    prevEl.className = 'previous';

    currentCategoryId = data[0].categoria_id || null;
    updateUI();
    showCard();
  } catch (err) {
    console.error('Errore caricamento parole:', err);
    italianEl.textContent = "❌ Errore caricamento parole";
    wordTypeEl.textContent = 'Tipo: —';
  }
}

// -------------------- MOSTRA PAROLA --------------------
function showCard() {
  if (pos >= queue.length) {
    italianEl.textContent = '🎉 Hai completato la categoria!';
    wordTypeEl.textContent = 'Tipo: —';
    prevEl.textContent = '';
    return;
  }

  const card = queue[pos];
  italianEl.textContent = card.italiano;
  wordTypeEl.innerHTML = `Tipo: ${formatType(card)}`;
  answerEl.value = '';
  answerEl.focus();
  updateUI();
}

// -------------------- STATISTICHE --------------------
function updateUI() {
  remainingEl.textContent = Math.max(0, queue.length - pos);
  scoreEl.textContent = score;
  const accuracy = totalAttempts ? Math.round((correctAttempts / totalAttempts) * 100) : 0;
  accuracyEl.textContent = `🎯 ${accuracy}%`;
}

// -------------------- FORMATI --------------------
function formatSynonyms(card) {
  if (card.sinonimi && card.sinonimi.length > 0) {
    return `<br><strong>Sinonimi:</strong><ul>${card.sinonimi.map(s => `<li>${s}</li>`).join('')}</ul>`;
  }
  return '';
}

function formatExamples(card) {
  if (card.esempi && card.esempi.length > 0) {
    return `<br><strong>Esempi:</strong><ul>${card.esempi.map(e => `<li>${e}</li>`).join('')}</ul>`;
  }
  return '';
}

function formatType(card) {
  if (card.tipo) {
    if (Array.isArray(card.tipo)) {
      return `<ul>${card.tipo.map(t => `<li>${t}</li>`).join('')}</ul>`;
    }
    return card.tipo;
  }
  return '—';
}

// -------------------- MOSTRA PRECEDENTE --------------------
function showPrevious(card, wasCorrect) {
  if (!card) {
    prevEl.innerHTML = '';
    prevEl.className = 'previous';
    return;
  }
  prevEl.className = 'previous ' + (wasCorrect ? 'correct' : 'wrong');
  prevEl.innerHTML = `
    <span>${card.italiano} → ${card.inglese}</span>
    ${formatSynonyms(card)}
    ${formatExamples(card)}
  `;
}

// -------------------- CONTROLLO RISPOSTA --------------------
function checkAnswer() {
  if (pos >= queue.length) return;
  const card = queue[pos];
  const given = answerEl.value.trim();
  if (!given) return;

  totalAttempts++;
  const normalize = s => s.normalize('NFD').replace(/\p{Diacritic}/gu, '').toLowerCase();
  const correct = normalize(card.inglese);
  const givenNorm = normalize(given);
  const wasCorrect = givenNorm === correct;

  if (wasCorrect) {
    score++;
    correctAttempts++;
  } else {
    const offset = 2 + Math.floor(Math.random() * 3);
    queue.splice(pos + offset, 0, { ...card });
  }

  prevCard = card;
  showPrevious(card, wasCorrect);
  pos++;

  if (userId && currentCategoryId) {
    updateStats(currentCategoryId, correctAttempts, totalAttempts);
  }

  setTimeout(() => {
    updateUI();
    showCard();
  }, 500);
}

// -------------------- EVENTI --------------------
newBtn.onclick = showCard;
checkBtn.onclick = checkAnswer;
answerEl.addEventListener('keydown', e => { if (e.key === 'Enter') checkAnswer(); });
showBtn.onclick = () => {
  if (pos < queue.length) {
    const card = queue[pos];
    showPrevious(card, true);
  }
};
resetBtn.onclick = () => {
  currentCategory = categorySelect.value;
  loadWords();
};
categorySelect.onchange = () => {
  currentCategory = categorySelect.value;
  loadWords();
};

// -------------------- AVVIO --------------------
loadCategories(); // parte subito se la sessione è valida (PHP la controlla)
