(function(){
  try{
    if(document.getElementById('assist-toggle') || document.getElementById('assist-box')) return;

    const lang = (document.documentElement.getAttribute('lang') || 'en').toLowerCase();
    const isSpec = /\/specialists\.html$/i.test(location.pathname);
    const L = {
      en: {
        title: 'Need help?',
        sub: 'Quick links to get you started:',
        services: 'See services',
        specialists: 'Find a specialist',
        or: 'Or',
        contact: 'book an intro call',
        specialistsHref: '/en/specialists.html',
        // Specialists page prompt
        chooseTitle: 'Need help choosing a specialist?',
        chooseSub: 'Type a few words and we’ll filter the list for you:',
        placeholder: 'e.g., anxiety, Yerevan, Armenian, female…',
        go: 'Search',
        done: 'Applied your filters.'
      },
      ru: {
        title: 'Нужна помощь?',
        sub: 'Быстрые ссылки для старта:',
        services: 'Услуги',
        specialists: 'Специалисты',
        or: 'Или',
        contact: 'запишитесь на вводный звонок',
        specialistsHref: '/ru/specialists.html',
        chooseTitle: 'Помочь выбрать специалиста?',
        chooseSub: 'Опишите в двух словах — мы отфильтруем список:',
        placeholder: 'напр.: тревога, Ереван, русский, женщина…',
        go: 'Найти',
        done: 'Фильтры применены.'
      },
      hy: {
        title: 'Օգնությու՞ն է հարկավոր',
        sub: 'Արագ հղումներ՝ սկսելու համար․',
        services: 'Ծառայություններ',
        specialists: 'Մասնագետներ',
        or: 'Կամ',
        contact: 'ամրագրեք նախնական զանգ',
        specialistsHref: '/hy/specialists.html',
        chooseTitle: 'Օգնե՞նք ընտրել մասնագետի',
        chooseSub: 'Գրեք մի քանի բառ, և մենք կֆիլտրենք ցուցակը․',
        placeholder: 'օր․՝ տագնապ, Երևան, հայերեն, կին…',
        go: 'Որոնել',
        done: 'Ֆիլտրերը կիրառվեցին։'
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
    title.textContent = isSpec ? t.chooseTitle : t.title;
    title.style.cssText = 'font-weight:700;margin:0 0 6px';

    const sub = document.createElement('div');
    sub.textContent = isSpec ? t.chooseSub : t.sub;
    sub.style.cssText = 'color:#475569;margin:0 0 10px';

    if(!isSpec){
      // Default quick links box
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

      const hint = document.createElement('div');
      hint.innerHTML = `${t.or} <a href="#/contact" style="color:var(--brand);text-decoration:underline;text-underline-offset:3px">${t.contact}</a>.`;
      hint.style.cssText = 'margin-top:10px;font-size:.92rem;color:#475569';

      box.appendChild(title); box.appendChild(sub); box.appendChild(links); box.appendChild(hint);
      links.appendChild(a1); links.appendChild(a2);
    }else{
      // Specialists page: prompt + input + button
      const wrap = document.createElement('div');
      wrap.style.cssText = 'display:grid;gap:8px';

      const input = document.createElement('input');
      input.type = 'text';
      input.placeholder = t.placeholder;
      input.setAttribute('aria-label', t.chooseTitle);
      input.style.cssText = 'width:100%;padding:10px 12px;border:1px solid var(--line);border-radius:10px;font:inherit';

      const act = document.createElement('button');
      act.type = 'button';
      act.textContent = t.go;
      act.className = 'assist-go';
      act.style.cssText = 'justify-self:end;padding:8px 12px;border-radius:10px;border:none;background:linear-gradient(135deg,var(--brand),var(--brand-2));color:#fff;font-weight:700;cursor:pointer';

      // Tiny examples (chips)
      const chips = document.createElement('div');
      chips.style.cssText = 'display:flex;gap:6px;flex-wrap:wrap'
      const examples = (
        lang==='ru' ? ['тревога','Ереван','русскоязычный специалист'] :
        lang==='hy' ? ['տագնապ','Երևան','հայերեն'] :
                      ['anxiety','Yerevan','Armenian']
      );
      examples.forEach(ex=>{
        const c=document.createElement('button');
        c.type='button'; c.textContent=ex;
        c.style.cssText='padding:6px 10px;border-radius:999px;border:1px solid var(--line);background:#fff;color:var(--brand);font-weight:600;cursor:pointer';
        c.addEventListener('click',()=>{ input.value = input.value ? (input.value+ (input.value.endsWith(' ')?'':', ') + ex) : ex; input.focus(); });
        chips.appendChild(c);
      });

      function applyToFilters(msg){
        try{
          const q = document.getElementById('q');
          if(q){ q.value = msg; q.dispatchEvent(new Event('input', {bubbles:true})); }
          // Optionally try to detect language/gender/city quickly (very naive)
          const low = msg.toLowerCase();
          const langSel = document.getElementById('lang');
          if(langSel){
            const guess = (/armenian|hy\b|հայ/i.test(low)?'hy' : /russian|ru\b|рус/i.test(low)?'ru' : /english|en\b|անգլ/i.test(low)?'en' : '');
            if(guess && Array.from(langSel.options).some(o=>o.value===guess)){ langSel.value = guess; langSel.dispatchEvent(new Event('change', {bubbles:true})); }
          }
          const genderSel = document.getElementById('gender');
          if(genderSel){
            const g = (/female|woman|женщ|իգա/i.test(low)?'female' : /male|man|мужч|արա/i.test(low)?'male' : '');
            if(g && Array.from(genderSel.options).some(o=>o.value===g)){ genderSel.value = g; genderSel.dispatchEvent(new Event('change', {bubbles:true})); }
          }
          const citySel = document.getElementById('city');
          if(citySel){
            const cities = Array.from(citySel.options).map(o=>o.value).filter(Boolean);
            const hit = cities.find(c=> low.includes(c.toLowerCase()) || low.includes((c==='Yerevan'?'Երևան':c).toLowerCase()) );
            if(hit){ citySel.value = hit; citySel.dispatchEvent(new Event('change', {bubbles:true})); }
          }
          const apply = document.getElementById('apply');
          apply && apply.click();
        }catch(_){/* noop */}
      }

      act.addEventListener('click', ()=>{ const v = input.value.trim(); if(!v) { input.focus(); return; } applyToFilters(v); toggle(false); });
      input.addEventListener('keydown', (e)=>{ if(e.key==='Enter'){ e.preventDefault(); act.click(); }});

      // Prefill from URL param assist_q if provided
      try{
        const usp = new URLSearchParams(location.search);
        const pre = usp.get('assist_q');
        if(pre){ input.value = pre; setTimeout(()=>applyToFilters(pre), 50); }
      }catch(_){ }

      box.appendChild(title); box.appendChild(sub); box.appendChild(input); box.appendChild(chips); box.appendChild(act);
    }

    document.body.appendChild(btn);
    document.body.appendChild(box);

    function isHidden(){ return box.style.display === 'none' || getComputedStyle(box).display === 'none'; }
    function toggle(open){ box.style.display = open ? 'block' : 'none'; btn.setAttribute('aria-expanded', String(open)); }
    btn.addEventListener('click', ()=> toggle(isHidden()));
    document.addEventListener('click', (e)=>{ if(!box.contains(e.target) && e.target !== btn) toggle(false); });
    document.addEventListener('keydown', (e)=>{ if(e.key==='Escape') toggle(false); });
  }catch(e){/* noop */}
})();
