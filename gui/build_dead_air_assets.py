from PIL import Image, ImageDraw, ImageEnhance, ImageFilter
import os, json, math, random, shutil, zipfile
src='/mnt/data/a_detailed_cinematic_grungy_realistic_radio_inv.png'
out='/mnt/data/dead_air_production_assets'
im=Image.open(src).convert('RGBA'); W,H=im.size
shutil.copy2(src,out+'/source/approved_master.png')
items=[]
def sprite(name,box,shape='round',radius=10,group='hardware',notes=''):
 x0,y0,x1,y1=box
 patch=im.crop(box)
 mask=Image.new('L',patch.size,0); d=ImageDraw.Draw(mask)
 w,h=patch.size
 if shape=='round':d.rounded_rectangle((1,1,w-2,h-2),radius=min(radius,w//3,h//3),fill=255)
 elif shape=='ellipse': d.ellipse((1,1,w-2,h-2),fill=255)
 elif shape=='square':d.rectangle((0,0,w-1,h-1),fill=255)
 elif shape=='meter':d.rounded_rectangle((0,0,w-1,h-1),radius=14,fill=255)
 else: raise ValueError(shape)
 patch.putalpha(mask)
 path=f'{group}/{name}.png';os.makedirs(os.path.dirname(out+'/'+path),exist_ok=True);patch.save(out+'/'+path,optimize=True)
 items.append(dict(name=name,file=path,x=x0,y=y0,width=w,height=h,group=group,hitbox=[x0,y0,w,h],notes=notes))
 return patch
# Hardware. Regions are cropped precisely around distinct physical instruments.
sprite('navigation_panel',(95,150,275,611),'round',15)
sprite('site_monitor_frame',(282,152,477,570),'round',13)
sprite('main_waterfall_bezel',(478,64,1208,580),'round',24)
sprite('signal_meter',(1232,55,1478,214),'meter',group='sprites')
sprite('indicator_bank',(1480,57,1617,209),'round',12)
for name,box in [('rf_gain',(1254,228,1342,333)),('af_gain',(1370,228,1463,332)),('squelch',(1503,224,1602,329))]:sprite(name,box,'ellipse',group='sprites')
sprite('tuning_dial',(1250,342,1504,596),'ellipse',group='sprites',notes='Rotate visual around center [1377,469]; use drag gesture for tuning')
sprite('tuning_step_bank',(1501,363,1617,570),'round',11,group='sprites')
sprite('mode_bank',(303,585,445,741),'round',9,group='sprites')
sprite('transport_deck',(473,579,1092,725),'round',11,group='sprites')
sprite('waterfall_mode_bank',(1090,579,1222,738),'round',10,group='sprites')
sprite('frequency_panel',(1240,600,1584,724),'round',13,group='sprites')
# Individual buttons extracted with transparent rounded profiles.
for name,box in [
('button_scan',(497,604,600,710)),('button_hold',(616,604,724,709)),('button_record',(730,604,841,709)),('button_mark',(849,604,961,712)),('button_analyze',(970,604,1078,714)),
('step_10khz',(1516,384,1607,430)),('step_1khz',(1516,429,1607,476)),('step_100hz',(1516,478,1607,525)),('step_10hz',(1516,527,1607,570)),
('nav_radio',(102,164,267,213)),('nav_case_files',(102,217,267,270)),('nav_evidence',(102,276,267,327)),('nav_recordings',(102,334,267,387)),('nav_timeline',(102,390,267,443)),('nav_map',(102,446,267,496)),('nav_archive',(102,502,267,552)),('nav_notes',(102,557,267,607))]:
 sprite(name,box,'round',9,group='sprites')
# Screen windows: the opaque bezel extracted above is separate, while the screens themselves are independently rendered.
screens={
 'waterfall':(511,136,1123,488),
 'waterfall_status':(507,97,1177,135),
 'signal_waveform':(508,490,1063,551),
 'site_monitor':(295,202,466,391),
 'frequency_readout':(1280,639,1541,692)
}
for name,(x0,y0,x1,y1) in screens.items():
 ww,hh=x1-x0,y1-y0
 layer=Image.new('RGBA',(ww,hh),(1,11,6,247)); d=ImageDraw.Draw(layer)
 d.rectangle((0,0,ww-1,hh-1),outline=(29,106,57,250),width=2)
 # edges subtly inset rather than painted glow
 d.rectangle((3,3,ww-4,hh-4),outline=(8,43,23,190),width=2)
 layer.save(f'{out}/displays/{name}_blank.png')
 items.append(dict(name=name+'_blank',file=f'displays/{name}_blank.png',x=x0,y=y0,width=ww,height=hh,group='display',notes='Programmatically painted dynamic content overlays this screen; no pre-baked text'))
# Knob state variants: source-accurate sprite with green and amber indicator dots as a separate overlay.
for name,cx,cy,r in [('rf_gain',1298,276,38),('af_gain',1417,277,39),('squelch',1552,275,39),('tuning_dial',1377,469,118)]:
 for angle in [0,90,180,270]:
  size=2*r+14; layer=Image.new('RGBA',(size,size)); d=ImageDraw.Draw(layer)
  a=math.radians(angle-90)
  px=size/2+math.cos(a)*(r-6);py=size/2+math.sin(a)*(r-6)
  d.ellipse((px-3,py-3,px+3,py+3),fill=(154,255,148,220))
  layer=layer.filter(ImageFilter.GaussianBlur(.55))
  layer.save(f'{out}/sprites/{name}_indicator_{angle}.png')
# Off/on button overlays, transparent and perfectly register to original controls.
buttons={'scan':(497,604,600,710),'hold':(616,604,724,709),'record':(730,604,841,709),'mark':(849,604,961,712),'analyze':(970,604,1078,714)}
for name,box in buttons.items():
 x0,y0,x1,y1=box;w=x1-x0;h=y1-y0
 for state in ['off','on','pressed']:
  layer=Image.new('RGBA',(w,h));d=ImageDraw.Draw(layer)
  rgb=((26,100,43) if name!='record' else (113,25,13))
  if state=='on':
   d.rounded_rectangle((9,7,w-10,h-9),radius=9,fill=(*rgb,77),outline=(*[min(255,z*2) for z in rgb],225),width=3)
  elif state=='pressed':
   d.rounded_rectangle((9,7,w-10,h-9),radius=9,fill=(*rgb,125),outline=(247,194,93,225),width=3)
  else:
   d.rounded_rectangle((9,7,w-10,h-9),radius=9,outline=(8,17,12,95),width=2)
  layer.save(f'{out}/sprites/button_{name}_{state}.png')
# Source-accurate mounting surface. It is separately exported from foreground graphics.
# The display/sprite windows are cleared by textured-dark backing plates; surrounding photographic equipment remains.
base=im.copy();d=ImageDraw.Draw(base,'RGBA')
for x0,y0,x1,y1 in [
(97,154,275,612),(284,157,475,575),(484,70,1204,573),(1230,52,1478,215),
(1482,60,1618,207),(1247,223,1347,332),(1364,224,1467,333),(1498,222,1609,334),
(1251,342,1503,596),(1500,363,1619,574),(298,587,449,741),(469,579,1094,730),
(1088,580,1226,738),(1235,600,1586,725)]:
 d.rounded_rectangle((x0,y0,x1,y1),radius=12,fill=(11,12,11,245),outline=(53,49,41,220),width=3)
base.save(out+'/source/chassis_mounted_base.png',optimize=True)
# An uncluttered presentation including all source accurate extracted widgets in same locations.
preview=base.copy()
for item in items:
 if item['group']=='display':continue
 sp=Image.open(out+'/'+item['file']).convert('RGBA');preview.alpha_composite(sp,(item['x'],item['y']))
preview.save(out+'/previews/hardware_reassembled.png',optimize=True)
# Transparent frontplate full-frame: useful for building a stage with screens dynamically rendered behind.
front=Image.new('RGBA',(W,H))
for item in items:
 if item['group']=='display':continue
 sp=Image.open(out+'/'+item['file']).convert('RGBA');front.alpha_composite(sp,(item['x'],item['y']))
front.save(out+'/sprites/hardware_frontplate.png',optimize=True)
manifest={'schema':'dead-air-assets-v1','reference_resolution':[W,H],'coordinate_system':'pixel positions in approved 1672x941 concept','art_direction':'Approved 05/06 radio-instrument and investigation desk hybrid','sprites':items,'button_states':{n:[f'sprites/button_{n}_{s}.png' for s in ('off','on','pressed')] for n in buttons},'screens':screens,'constraints':['Source is concept illustration; manual retouch required before final release.','No Blackwood narrative text should be used in functional game panels.','Dynamic data and text should be rendered by game engine, never baked into source sprites.','Avoid invented glitch mechanics; waterfall should be consistent with the simulated signal source.']}
with open(out+'/atlas.json','w') as f:json.dump(manifest,f,indent=2)
# Native Godot integration starter, no dependency on a baked one-piece reference.
with open(out+'/README.md','w') as f:
 f.write('''# DEAD AIR — Receiver UI Production Asset Pack v1\n\n**Artwork master:** approved 1672×941 workstation hybrid (concepts 05 + 06).\n\n## Deliverables\n- `source/approved_master.png` retains the locked design reference.\n- `source/chassis_mounted_base.png` is the receiver/desk mounting surface with covered control bays.\n- `sprites/` contains transparent, individually positioned hardware cutouts: chassis control banks, knobs, signal meter, tuning dial, each physical button and navigation key.\n- `sprites/button_*_{off,on,pressed}.png` contains precisely registered transparent state overlays.\n- `sprites/*_indicator_{0,90,180,270}.png` provides knob indicator position overlays.\n- `displays/*_blank.png` provides dark framed surfaces for dynamic waterfall, status, waveform, case monitor and frequency display.\n- `atlas.json` includes each sprite's original pixel position, dimensions and suggested interaction hitbox.\n- `previews/hardware_reassembled.png` checks visual alignment of separate layers.\n- `previews/components.html` shows an interactive asset inventory without requiring external resources.\n\n## Layer stack (back to front)\n1. Chassis base (fixed texture)\n2. Dynamic screen textures in the atlas screen rectangles (waterfall, frequency, status, case, waveform)\n3. Hardware masks/sprites in their atlas locations\n4. Button state overlays and knob pointer indicators\n5. Text and modal overlays, rendered from game data (not embedded in raster)\n6. Accessible clickable/touch areas matching hitboxes in the JSON\n\n## Important limitations\nThis is an **extraction and layout-ready pack**, not a final hand-painted studio sprite set. Because the master is one flattened illustration, button labels are baked into hardware crops and some elements are imperfectly separable. The reassembled preview is the faithful composition check; remove/repaint fixed labels and improve cutout edges before final in-game production. The `chassis_mounted_base.png` is a masked mounting scaffold rather than a completely repainted blank radio body.\n\nSuggested target is a Godot 4 `Control` scene with a 1672×941 root base scaled uniformly to landscape viewport. Apply percent positions from `atlas.json` for adaptive scaling. Drive waterfall pixels, frequency, meters and interface text from the same receiver simulation. Touch-drag on tuning dial, tap on mechanical switches, and configurable alternate swipe/button controls.\n\n**Canon:** the mockup's Blackwood documents and 7.120 MHz are placeholders; game data should follow the DEAD AIR ledger.\n''')
# Index HTML gallery
cards=[]
for item in items:
 cards.append('<div class="card"><img src="../'+item['file']+'"><div><b>'+item['name']+'</b><small>'+str(item['width'])+' × '+str(item['height'])+' · '+item['group']+'</small></div></div>')
with open(out+'/previews/components.html','w') as f:
 f.write('<!DOCTYPE html><html><meta charset="utf-8"><title>DEAD AIR · Assets</title><style>body{background:#0b1010;color:#ddf4d9;font:14px monospace;margin:30px}h1{color:#9dfa9c}.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(210px,1fr));gap:14px}.card{border:1px solid #36543e;background:#1d211d;padding:12px;min-height:140px;display:flex;flex-direction:column;justify-content:space-between;align-items:center}.card img{max-width:100%;height:125px;object-fit:contain}.card small{display:block;color:#96af9b;padding:6px}a{color:#a2ffb3}</style><h1>DEAD AIR / Production Asset Inventory</h1><p>Source-accurate sprites and dynamic display surfaces. <a href="../atlas.json">Manifest</a></p><div class="grid">'+''.join(cards)+'</div></html>')
zip_path='/mnt/data/dead_air_production_asset_pack_v1.zip'
with zipfile.ZipFile(zip_path,'w',zipfile.ZIP_DEFLATED,compresslevel=8) as z:
 for root,dirs,files in os.walk(out):
  for file in files:
   full=os.path.join(root,file);z.write(full,os.path.relpath(full,'/mnt/data'))
print('asset count',len(items),'zip',os.path.getsize(zip_path),'preview',out+'/previews/hardware_reassembled.png')
