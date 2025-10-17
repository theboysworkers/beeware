// NAV
document.querySelectorAll('#nav button').forEach(btn=>{
  btn.addEventListener('click', ()=>{
    document.querySelectorAll('#nav button').forEach(b=>b.classList.remove('active'));
    btn.classList.add('active');
    const view = btn.dataset.view;
    document.querySelectorAll('.view').forEach(v=>v.style.display='none');
    document.getElementById('view-' + view).style.display='block';
    document.getElementById('pageTitle').textContent = btn.textContent;
  });
});

// UTILS
async function api(url,data={}){
  const fd = new FormData();
  for(const k in data) fd.append(k,data[k]);
  const res = await fetch(url,{method:'POST',body:fd});
  return await res.json();
}

// DASHBOARD
async function refreshDashboard(){
  document.getElementById('overview').textContent='Caricamento...';
  const r = await api('dashboard.php');
  if(!r.ok){ document.getElementById('overview').textContent='Errore'; return; }
  document.getElementById('uptime').textContent=r.stats.uptime;
  document.getElementById('top_cpu').textContent=r.stats.top_cpu;
  document.getElementById('top_mem').textContent=r.stats.top_mem;
  document.getElementById('disk').textContent=r.stats.disk;
  document.getElementById('net').textContent=r.stats.net;
  document.getElementById('overview').textContent=`Load: ${r.stats.load}\n\nMemory:\n${r.stats.memory.split('\n').slice(0,6).join('\n')}`;
}

// PROCESSI
document.getElementById('btnGetProcs').addEventListener('click', async ()=>{
  const n=document.getElementById('procN').value;
  const sort=document.getElementById('procSort').value;
  document.getElementById('procsOutput').textContent='Caricamento...';
  const r=await api('processes.php',{n,sort});
  if(r.ok) document.getElementById('procsOutput').textContent=r.output;
  else document.getElementById('procsOutput').textContent='Errore';
});

// LOGS
document.getElementById('btnTail').addEventListener('click', async ()=>{
  const path=document.getElementById('logPath').value;
  const lines=document.getElementById('tailLines').value;
  document.getElementById('logOutput').textContent='Tail...';
  const r=await api('logs.php',{action:'tail',path,lines});
  if(r.ok) document.getElementById('logOutput').textContent=r.output;
  else document.getElementById('logOutput').textContent='Errore';
});
document.getElementById('btnDL').addEventListener('click', async ()=>{
  const path=document.getElementById('logPath').value;
  const r=await api('logs.php',{action:'download',path});
  if(r.ok) window.open(r.url,'_blank');
  else alert('Errore');
});

// FILES
document.getElementById('btnListDir').addEventListener('click', async ()=>{
  const p=document.getElementById('fileBrowsePath').value;
  document.getElementById('filesList').textContent='Listing...';
  const r=await api('files.php',{path:p});
  if(r.ok) document.getElementById('filesList').textContent=r.items.join('\n');
  else document.getElementById('filesList').textContent='Errore';
});

// SHELL
const execForm=document.getElementById('execForm');
let lastCmd='';
execForm.addEventListener('submit', async e=>{
  e.preventDefault();
  const cmd=execForm.cmd.value.trim();
  if(!cmd) return;
  lastCmd=cmd;
  document.getElementById('execOutput').textContent='Esecuzione...';
  const r=await api('shell.php',{cmd});
  if(r.ok) document.getElementById('execOutput').textContent=r.output;
  else document.getElementById('execOutput').textContent='Errore';
});
document.getElementById('btnClear').addEventListener('click', ()=>{
  execForm.cmd.value='';
  document.getElementById('execOutput').textContent='';
});
document.getElementById('btnLast').addEventListener('click', ()=>execForm.cmd.value=lastCmd);

// REFRESH
document.getElementById('refreshAll').addEventListener('click', async ()=>{
  await refreshDashboard();
  document.getElementById('btnGetProcs').click();
});
refreshDashboard();
document.getElementById('btnGetProcs').click();
