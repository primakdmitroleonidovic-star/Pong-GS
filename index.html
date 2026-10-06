<!DOCTYPE html>
<html lang="uk">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Pong</title>
<style>
*{box-sizing:border-box}
body{margin:0;background:#111;color:#fff;font-family:monospace;display:flex;justify-content:center;align-items:center;min-height:100vh}
.wrap{width:min(1000px,94vw)}
.hud{display:flex;justify-content:space-between;padding:10px 14px;font-size:28px}
.board{position:relative;width:100%;aspect-ratio:16/9;background:#000;border:2px solid #fff;overflow:hidden;cursor:none;outline:none}
.paddle{position:absolute;width:14px;height:18%;background:#fff}
.left{left:2%;top:41%}.right{right:2%;top:41%}
.ball{position:absolute;width:16px;height:16px;background:#fff;border-radius:50%;left:50%;top:50%;transform:translate(-50%,-50%)}
.hint{text-align:center;font-size:15px;margin-top:12px}
.message{text-align:center;height:24px;margin-top:6px}
</style>
</head>
<body>
<div class="wrap">
  <div class="hud"><span id="p1">0</span><span>PONG</span><span id="p2">0</span></div>
  <div class="board" tabindex="0" aria-label="Pong">
    <div class="paddle left"></div>
    <div class="paddle right"></div>
    <div class="ball"></div>
  </div>
  <div class="message" id="message">Натисни ПРОБІЛ, щоб почати</div>
  <div class="hint">Гравець 1: W / S · Гравець 2: ↑ / ↓ · Пробіл — старт/пауза · R — перезапуск</div>
</div>
<script>
(() => {
  const board=document.querySelector('.board');
  const left=document.querySelector('.left');
  const right=document.querySelector('.right');
  const ball=document.querySelector('.ball');
  const p1El=document.getElementById('p1');
  const p2El=document.getElementById('p2');
  const msg=document.getElementById('message');

  let keys={}, running=false, paused=false;
  let p1=0,p2=0,x=50,y=50,vx=.65,vy=.45,last=0;
  let audioCtx=null;

  function sound(freq=440,duration=.06){
    try{
      audioCtx ||= new (window.AudioContext||window.webkitAudioContext)();
      if(audioCtx.state==='suspended') audioCtx.resume();
      const osc=audioCtx.createOscillator();
      const gain=audioCtx.createGain();
      osc.type='square';
      osc.frequency.value=freq;
      gain.gain.setValueAtTime(.045,audioCtx.currentTime);
      gain.gain.exponentialRampToValueAtTime(.001,audioCtx.currentTime+duration);
      osc.connect(gain); gain.connect(audioCtx.destination);
      osc.start(); osc.stop(audioCtx.currentTime+duration);
    }catch(e){}
  }

  function resetBall(dir){
    x=50;y=50;vx=.65*dir;vy=(Math.random()-.5)*.9;
  }

  function reset(){
    p1=0;p2=0;p1El.textContent='0';p2El.textContent='0';
    left.style.top='41%';right.style.top='41%';
    resetBall(Math.random()<.5?1:-1);
    running=false;paused=false;
    msg.textContent='Натисни ПРОБІЛ, щоб почати';
  }

  function loop(t){
    if(!last) last=t;
    const dt=Math.min(32,t-last);
    last=t;

    if(running && !paused){
      let lp=parseFloat(left.style.top)||41;
      let rp=parseFloat(right.style.top)||41;
      const step=.11*dt;

      if(keys.KeyW) lp-=step;
      if(keys.KeyS) lp+=step;
      if(keys.ArrowUp) rp-=step;
      if(keys.ArrowDown) rp+=step;

      lp=Math.max(0,Math.min(82,lp));
      rp=Math.max(0,Math.min(82,rp));
      left.style.top=lp+'%';
      right.style.top=rp+'%';

      x+=vx*dt/10;
      y+=vy*dt/10;

      if(y<=2 || y>=98){
        vy*=-1;
        y=Math.max(2,Math.min(98,y));
        sound(520);
      }

      const hitLeft=x<=6&&x>=4&&y>=lp&&y<=lp+18;
      const hitRight=x>=94&&x<=96&&y>=rp&&y<=rp+18;

      if(hitLeft){vx=Math.abs(vx)*1.04;x=6;sound(700)}
      if(hitRight){vx=-Math.abs(vx)*1.04;x=94;sound(700)}

      if(x<0){
        p2++;p2El.textContent=p2;sound(260,.12);resetBall(1);
      }
      if(x>100){
        p1++;p1El.textContent=p1;sound(260,.12);resetBall(-1);
      }

      if(p1>=10 || p2>=10){
        running=false;
        msg.textContent=(p1>=10?'Гравець 1':'Гравець 2')+' переміг! Натисни R для нової гри';
      }
    }

    ball.style.left=x+'%';
    ball.style.top=y+'%';
    requestAnimationFrame(loop);
  }

  board.addEventListener('keydown',e=>{
    keys[e.code]=true;
    if(e.code==='Space'){
      e.preventDefault();
      if(!running){sound(880,.08);running=true;paused=false;msg.textContent='Гра триває'}
      else{paused=!paused;msg.textContent=paused?'Пауза':'Гра триває'}
    }
    if(e.code==='KeyR') reset();
  });

  board.addEventListener('keyup',e=>keys[e.code]=false);
  board.addEventListener('click',()=>board.focus());
  board.focus();
  reset();
  requestAnimationFrame(loop);
})();
</script>
</body>
</html>
