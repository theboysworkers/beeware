<?php
require_once __DIR__.'/lib/auth.php';
if(!logged_in()){ header('Location: login.php'); exit; }
?>
<!doctype html>
<html lang="it">
<head>
<meta charset="utf-8">
<title>Admin Panel</title>
<meta name="viewport" content="width=device-width,initial-scale=1">
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="app">
<aside class="sidebar">
  <div class="logo">Admin Panel</div>
  <div class="small">Utente: <?=htmlspecialchars($_SESSION['user'])?></div>
  <nav class="nav" id="nav">
    <button data-view="dashboard" class="active">Dashboard</button>
    <button data-view="processes">Processi</button>
    <button data-view="logs">Logs</button>
    <button data-view="files">File Browser</button>
    <button data-view="shell">Shell</button>
    <button data-view="settings">Settings</button>
  </nav>
  <div class="foot"><a href="logout.php" style="color:#f88;text-decoration:none">Logout</a></div>
</aside>

<main class="main">
<div class="topbar">
  <div>
    <h2 id="pageTitle">Dashboard</h2>
    <div class="small" id="subTitle">Panoramica risorse server</div>
  </div>
  <div class="flex">
    <button id="refreshAll" class="btn">Aggiorna</button>
  </div>
</div>

<div id="views">
  <!-- DASHBOARD -->
  <section id="view-dashboard" class="view">
    <div class="grid">
      <div>
        <div class="card">
          <h3>System Overview</h3>
          <div id="overview" class="small">Caricamento...</div>
        </div>
        <div class="card">
          <h3>Top CPU</h3>
          <pre id="top_cpu" class="proc-table">—</pre>
        </div>
        <div class="card">
          <h3>Top Memory</h3>
          <pre id="top_mem" class="proc-table">—</pre>
        </div>
      </div>
      <div>
        <div class="card">
          <h3>Disk</h3>
          <pre id="disk" class="small">—</pre>
        </div>
        <div class="card">
          <h3>Network</h3>
          <pre id="net" class="small">—</pre>
        </div>
        <div class="card">
          <h3>Uptime / Load</h3>
          <pre id="uptime" class="small">—</pre>
        </div>
      </div>
    </div>
  </section>

  <!-- PROCESSI -->
  <section id="view-processes" class="view" style="display:none">
    <div class="card">
      <div style="display:flex;justify-content:space-between">
        <h3>Processi (ps)</h3>
        <div class="flex">
          <label class="small">N: <input id="procN" type="number" value="15" style="width:80px"></label>
          <select id="procSort">
            <option value="cpu">CPU</option>
            <option value="mem">MEM</option>
          </select>
          <button id="btnGetProcs" class="btn">Aggiorna</button>
        </div>
      </div>
      <pre id="procsOutput" class="proc-table">—</pre>
    </div>
  </section>

  <!-- LOGS -->
  <section id="view-logs" class="view" style="display:none">
    <div class="card">
      <h3>Visualizza log</h3>
      <div style="display:flex;gap:8px;margin-bottom:8px">
        <input id="logPath" type="text" value="<?=htmlspecialchars(BASE_FILE_ROOT . '/apache2/access.log')?>">
        <input id="tailLines" type="number" value="200" style="width:100px">
        <button id="btnTail" class="btn">Tail</button>
        <button id="btnDL" class="btn" style="background:#10b981">Download</button>
      </div>
      <pre id="logOutput" class="output">—</pre>
    </div>
  </section>

  <!-- FILES -->
  <section id="view-files" class="view" style="display:none">
    <div class="card">
      <h3>File Browser (root: <?=htmlspecialchars(BASE_FILE_ROOT)?>)</h3>
      <div style="display:flex;gap:8px;margin-bottom:8px">
        <input id="fileBrowsePath" type="text" value="<?=htmlspecialchars(BASE_FILE_ROOT)?>">
        <button id="btnListDir" class="btn">List</button>
      </div>
      <div id="filesList" class="small">—</div>
    </div>
  </section>

  <!-- SHELL -->
  <section id="view-shell" class="view" style="display:none">
    <div class="card">
      <h3>Shell</h3>
      <form id="execForm">
        <textarea name="cmd" class="cmd" placeholder="Comando..."></textarea>
        <div style="display:flex;gap:8px;margin-top:8px">
          <button type="submit" class="btn">Esegui</button>
          <button type="button" id="btnClear" class="btn" style="background:#ef4444">Pulisci</button>
          <button type="button" id="btnLast" class="btn" style="background:#6b7280">Ultimo</button>
        </div>
      </form>
      <h4>Output</h4>
      <pre id="execOutput" class="output">—</pre>
    </div>
  </section>

  <!-- SETTINGS -->
  <section id="view-settings" class="view" style="display:none">
    <div class="card">
      <h3>Settings</h3>
      <p class="small">Base file root: <code><?=htmlspecialchars(BASE_FILE_ROOT)?></code></p>
      <p class="small">Max tail lines: <code><?=MAX_TAIL?></code></p>
      <p class="small" style="color:#f88">Cambia APP_PASS nel file e usa HTTPS.</p>
    </div>
  </section>
</div>
</main>
</div>
<script src="assets/script.js"></script>
</body>
</html>
