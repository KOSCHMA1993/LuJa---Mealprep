// Essensplan V9 Patch: X-Buttons, DM-Standardprodukte, additive Einkaufsliste
(() => {
  const $ = s => document.querySelector(s);
  const esc = v => String(v ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  const note = m => { const t=$('#toast'); if(t){t.textContent=m;t.classList.add('show');setTimeout(()=>t.classList.remove('show'),3200)} };
  const getDb = () => { try { return db; } catch { return null; } };
  const getUser = () => { try { return user; } catch { return null; } };

  // Sichtbares X oben rechts in jedem Dialog. Funktioniert auf iPhone ohne ESC.
  document.querySelectorAll('dialog').forEach(dialog => {
    if (dialog.querySelector('.dialog-x')) return;
    const x=document.createElement('button');
    x.type='button'; x.className='dialog-x'; x.setAttribute('aria-label','Fenster schließen'); x.textContent='×';
    x.addEventListener('click', e => { e.preventDefault(); dialog.close(); });
    dialog.prepend(x);
  });

  // Abbrechen zuverlässig schließen, unabhängig vom form/dialog-Verhalten des Browsers.
  document.addEventListener('click', e => {
    const b=e.target.closest('dialog button[value="cancel"]');
    if(!b) return;
    e.preventDefault();
    b.closest('dialog')?.close();
  }, true);

  // DM-Schnellauswahl einbauen.
  const shoppingTitle=$('#shopping .title');
  if(shoppingTitle && !$('#dmQuickOpen')){
    const btn=document.createElement('button'); btn.id='dmQuickOpen'; btn.type='button'; btn.className='secondary'; btn.textContent='DM-Artikel';
    shoppingTitle.append(btn);
    const dialog=document.createElement('dialog'); dialog.id='dmQuickDialog';
    const products=[
      ['Toilettenpapier','1','Packung','Haushalt'],['Küchenrolle','1','Packung','Haushalt'],['Taschentücher','1','Packung','Haushalt'],
      ['Müllbeutel','1','Rolle','Haushalt'],['Spülmittel','1','Flasche','Reinigung'],['Spülmaschinen-Tabs','1','Packung','Reinigung'],
      ['Waschmittel','1','Packung','Wäsche'],['Weichspüler','1','Flasche','Wäsche'],['Allzweckreiniger','1','Flasche','Reinigung'],
      ['Badreiniger','1','Flasche','Reinigung'],['WC-Reiniger','1','Flasche','Reinigung'],['Spülschwämme','1','Packung','Reinigung'],
      ['Handseife','1','Stück','Körperpflege'],['Duschgel','1','Stück','Körperpflege'],['Shampoo','1','Stück','Körperpflege'],
      ['Zahnpasta','1','Stück','Zahnpflege'],['Deo','1','Stück','Körperpflege'],['Wattestäbchen','1','Packung','Körperpflege']
    ];
    dialog.innerHTML=`<button type="button" class="dialog-x" aria-label="Fenster schließen">×</button><h2>DM-Standardprodukte</h2><p class="meta">Artikel auswählen und gesammelt ergänzen. Bereits offene DM-Artikel werden nicht doppelt angelegt.</p><div class="dm-grid">${products.map((p,i)=>`<label class="dm-product"><input type="checkbox" value="${i}"><span><b>${esc(p[0])}</b><small>${esc(p[1])} ${esc(p[2])}</small></span></label>`).join('')}</div><div class="row"><button type="button" class="secondary dm-cancel">Schließen</button><button type="button" id="addDmProducts">Auswahl hinzufügen</button></div>`;
    document.body.append(dialog);
    dialog.querySelector('.dialog-x').onclick=()=>dialog.close(); dialog.querySelector('.dm-cancel').onclick=()=>dialog.close();
    btn.onclick=()=>dialog.showModal();
    dialog.querySelector('#addDmProducts').onclick=async()=>{
      const db=getDb(), u=getUser(); if(!db||!u) return note('Bitte zuerst anmelden.');
      const selected=[...dialog.querySelectorAll('input:checked')].map(x=>products[+x.value]);
      if(!selected.length) return note('Bitte mindestens einen Artikel auswählen.');
      const {data:existing,error}=await db.from('shopping_items').select('name').eq('store','DM').eq('done',false);
      if(error) return note(error.message);
      const names=new Set((existing||[]).map(x=>x.name.trim().toLowerCase()));
      const rows=selected.filter(p=>!names.has(p[0].toLowerCase())).map(p=>({user_id:u.id,name:p[0],quantity:+p[1],unit:p[2],category:p[3],store:'DM',manual:true}));
      if(rows.length){const {error:e}=await db.from('shopping_items').insert(rows);if(e)return note(e.message)}
      dialog.querySelectorAll('input').forEach(x=>x.checked=false); dialog.close(); note(rows.length?`${rows.length} DM-Artikel ergänzt.`:'Alle ausgewählten Artikel stehen bereits auf der Liste.');
      if(typeof loadShopping==='function') loadShopping();
    };
  }

  // Wochenplan-Erzeugung abfangen: nichts löschen, vorhandene Positionen erhalten.
  const generate=$('#generate');
  if(generate){
    document.addEventListener('click', async e => {
      if(e.target.closest('#generate')!==generate) return;
      e.preventDefault(); e.stopImmediatePropagation();
      const db=getDb(), u=getUser(); if(!db||!u) return note('Bitte zuerst anmelden.');
      let start=new Date(); start.setHours(0,0,0,0); let end=new Date(start); end.setDate(end.getDate()+6);
      const iso=d=>d.toISOString().slice(0,10);
      const {data:meals,error}=await db.from('meal_plan').select('servings,recipes(servings,ingredients(name,quantity,unit,category,store))').gte('date',iso(start)).lte('date',iso(end));
      if(error) return note(error.message);
      const wanted=new Map();
      for(const m of meals||[]) for(const i of m.recipes?.ingredients||[]){
        const store=i.store||'Naturgut', key=`${i.name.trim().toLowerCase()}|${(i.unit||'').trim().toLowerCase()}|${store.toLowerCase()}`;
        const x=wanted.get(key)||{user_id:u.id,name:i.name,quantity:0,unit:i.unit,category:i.category||'Sonstiges',store,manual:false};
        x.quantity+=(Number(i.quantity)||0)*(Number(m.servings||1)/Number(m.recipes.servings||1)); wanted.set(key,x);
      }
      const {data:current,error:ce}=await db.from('shopping_items').select('*').eq('done',false); if(ce)return note(ce.message);
      const byKey=new Map((current||[]).map(i=>[`${i.name.trim().toLowerCase()}|${(i.unit||'').trim().toLowerCase()}|${(i.store||'Naturgut').toLowerCase()}`,i]));
      const inserts=[]; let kept=0;
      for(const [key,item] of wanted){ if(byKey.has(key)){kept++; continue;} inserts.push(item); }
      if(inserts.length){const {error:ie}=await db.from('shopping_items').insert(inserts);if(ie)return note(ie.message)}
      note(`${inserts.length} neue Artikel ergänzt. ${kept} vorhandene Positionen unverändert gelassen.`);
      if(typeof loadShopping==='function') loadShopping();
    }, true);
  }
})();
