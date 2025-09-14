// assets/js/chatbot.js
(function () {
  // --- Icon (SVG) ---
  const ICON_SVG = `
    <svg viewBox="0 0 24 24" width="36" height="36" aria-hidden="true" focusable="false">
      <path d="M4 5.5h12a3 3 0 0 1 3 3v5a3 3 0 0 1-3 3H9l-5 4v-4H4a3 3 0 0 1-3-3v-5a3 3 0 0 1 3-3Z"
            fill="none" stroke="currentColor" stroke-width="1.8"
            stroke-linecap="round" stroke-linejoin="round"/>
      <circle cx="9" cy="11" r="1" fill="currentColor"/>
      <circle cx="12" cy="11" r="1" fill="currentColor"/>
      <circle cx="15" cy="11" r="1" fill="currentColor"/>
    </svg>
  `;

  // --- Styles (bottom-right + pulse) ---
  const style = document.createElement('style');
  style.textContent = `
    .chat-fab {
      position: fixed;
      right: 20px; bottom: 20px;
      width: 90px; height: 90px;
      display: flex; align-items: center; justify-content: center;
      border-radius: 50%;
      background: #083d48;        /* your accent */
      color: #fff;                 /* icon color */
      border: none;
      cursor: pointer;
      z-index: 9999;
      box-shadow: 0 6px 18px rgba(0,0,0,0.25);
      transition: transform .2s ease, box-shadow .2s ease;
      animation: cbt-pulse 2s infinite;
      text-decoration: none;       /* if we use <a> */
    }
    .chat-fab:hover {
      transform: scale(1.08);
      box-shadow: 0 8px 22px rgba(0,0,0,0.30);
      animation: none; /* pause pulse on hover */
    }
    .chat-fab svg { display: block; }

    @keyframes cbt-pulse {
      0%   { transform: scale(1);    box-shadow: 0 0 0 0 rgba(8,61,72,0.45); }
      70%  { transform: scale(1.05); box-shadow: 0 0 0 14px rgba(8,61,72,0); }
      100% { transform: scale(1);    box-shadow: 0 0 0 0 rgba(8,61,72,0); }
    }
  `;
  document.head.appendChild(style);

  // --- Create button (as a link so Hydejack PJAX can handle it) ---
  const btn = document.createElement('a');
  btn.className = 'chat-fab';
  btn.href = '/chatbot'; // or "{{ '/chatbot/' | relative_url }}"
  btn.setAttribute('title', 'Ask my chatbot about me!');
  btn.innerHTML = ICON_SVG;

  // If you prefer hard navigation (no PJAX), uncomment:
  // btn.setAttribute('data-no-hy-push-state', '');

  document.body.appendChild(btn);
})();
