# Pong-GS — Lua + LÖVE2D

Гра написана мовою Lua для LÖVE2D.

Для запуску в браузері GitHub Pages використовується love.js. GitHub Actions автоматично:
1. пакує `main.lua` і `conf.lua` у `pong.love`;
2. збирає web-версію через `love.js`;
3. публікує її на GitHub Pages.

Після завантаження цих файлів у репозиторій потрібно в GitHub:
Settings → Pages → Build and deployment → Source → GitHub Actions.

Потім у вкладці Actions дочекайся зеленого `Build and deploy LÖVE game to GitHub Pages`.
