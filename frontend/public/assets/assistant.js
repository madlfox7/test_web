(function(){
  try{
    if(document.getElementById('assist-toggle') || document.getElementById('assist-box')) return;

    const lang = (document.documentElement.getAttribute('lang') || 'en').toLowerCase();
    const L = {
      en: {
        title: 'Need help?',
        sub: 'Quick links to get you started:',
        services: 'See services',
        specialists: 'Find a specialist',
        or: 'Or',
        contact: 'book an intro call',
        specialistsHref: '/en/specialists.html'
      },
      ru: {
        title: 'Нужна помощь?',
        sub: 'Быстрые ссылки для старта:',
        services: 'Услуги',
        specialists: 'Специалисты',
        or: 'Или',
        contact: 'запишитесь на вводный звонок',
        specialistsHref: '/ru/specialists.html'
      },
      hy: {
        title: 'Օգնա՞կ է պետք',
        sub: 'Արագ հղումներ՝ սկսելու համար․',
        services: 'Ծառայություններ',
        specialists: 'Մասնագետներ',
        or: 'Կամ',
        contact: 'ամրագրեք նախնական զանգ',
        specialistsHref: '/hy/specialists.html'
      }
    };
    const t = L[lang] || L.en;

    // Button
    const btn = document.createElement('button');
    btn.id = 'assist-toggle';
    btn.type = 'button';
    btn.setAttribute('aria-label', t.title);
    btn.setAttribute('aria-expanded', 'false');
    btn.setAttribute('aria-controls', 'assist-box');
    btn.style.cssText = [
      'position:fixed','bottom:20px','right:20px','display:grid','place-items:center','width:56px','height:56px','border:none',
      'border-radius:50%','background:linear-gradient(135deg,var(--brand),var(--brand-2))','color:#fff','font-size:24px','cursor:pointer',
      'box-shadow:0 10px 25px rgba(2,6,23,.18)','z-index:1100'
    ].join(';');
    btn.textContent = '💬';

    // Popup
    const box = document.createElement('div');
    box.id = 'assist-box';
    box.setAttribute('role','dialog');
    box.setAttribute('aria-modal','false');
    box.setAttribute('aria-labelledby','assist-title');
    box.style.cssText = [
      'display:none','position:fixed','bottom:84px','right:20px','width:min(320px,92vw)','background:#fff','color:#0f172a','border-radius:14px',
      'box-shadow:0 12px 30px rgba(2,6,23,.22)','padding:14px 14px 12px','border:1px solid var(--line)','z-index:1099'
    ].join(';');

    const title = document.createElement('div');
    title.id = 'assist-title';
    title.textContent = t.title;
    title.style.cssText = 'font-weight:700;margin:0 0 6px';

    const sub = document.createElement('div');
    sub.textContent = t.sub;
    sub.style.cssText = 'color:#475569;margin:0 0 10px';

    const links = document.createElement('div');
    links.style.cssText = 'display:flex;gap:8px;flex-wrap:wrap';
    const a1 = document.createElement('a');
    a1.href = '#/services';
    a1.textContent = t.services;
    a1.style.cssText = 'flex:1;min-width:120px;text-align:center;text-decoration:none;color:#fff;background:linear-gradient(135deg,var(--brand),var(--brand-2));padding:8px 10px;border-radius:10px;font-weight:600';
    const a2 = document.createElement('a');
    a2.href = t.specialistsHref;
    a2.textContent = t.specialists;
    a2.style.cssText = 'flex:1;min-width:120px;text-align:center;text-decoration:none;color:var(--brand);background:#fff;border:1px solid var(--line);padding:8px 10px;border-radius:10px;font-weight:600';
    links.appendChild(a1); links.appendChild(a2);

    const hint = document.createElement('div');
    hint.innerHTML = `${t.or} <a href="#/contact" style="color:var(--brand);text-decoration:underline;text-underline-offset:3px">${t.contact}</a>.`;
    hint.style.cssText = 'margin-top:10px;font-size:.92rem;color:#475569';

    box.appendChild(title); box.appendChild(sub); box.appendChild(links); box.appendChild(hint);
    document.body.appendChild(btn);
    document.body.appendChild(box);

    function isHidden(){ return box.style.display === 'none' || getComputedStyle(box).display === 'none'; }
    function toggle(open){ box.style.display = open ? 'block' : 'none'; btn.setAttribute('aria-expanded', String(open)); }
    btn.addEventListener('click', ()=> toggle(isHidden()));
    document.addEventListener('click', (e)=>{ if(!box.contains(e.target) && e.target !== btn) toggle(false); });
    document.addEventListener('keydown', (e)=>{ if(e.key==='Escape') toggle(false); });
  }catch(e){/* noop */}
})();
