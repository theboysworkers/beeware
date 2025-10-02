const ticketBody = document.getElementById('ticketBody');
const searchInput = document.getElementById('search');
const filterStatus = document.getElementById('filterStatus');

function loadTickets() {
    const q = searchInput.value;
    const status = filterStatus.value;

    fetch(`search_ticket.php?q=${encodeURIComponent(q)}&status=${encodeURIComponent(status)}`)
        .then(response => response.text())
        .then(data => {
            ticketBody.innerHTML = data;
            attachCloseHandlers();
        });
}

function attachCloseHandlers() {
    document.querySelectorAll('.closeBtn').forEach(btn => {
        btn.addEventListener('click', function() {
            if(confirm('Sei sicuro di voler chiudere questo ticket?')) {
                const id = this.dataset.id;
                fetch('update_ticket.php', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: `id=${id}`
                }).then(() => loadTickets());
            }
        });
    });
}

searchInput.addEventListener('input', loadTickets);
filterStatus.addEventListener('change', loadTickets);

// Carica inizialmente tutti i ticket
loadTickets();
