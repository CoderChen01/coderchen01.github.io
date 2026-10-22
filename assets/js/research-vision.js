(() => {
  const buttons = document.querySelectorAll("[data-vision-language]");
  const panels = document.querySelectorAll("[data-vision-panel]");
  if (!buttons.length || !panels.length) return;

  const setLanguage = (language) => {
    buttons.forEach((button) => {
      button.setAttribute("aria-pressed", String(button.dataset.visionLanguage === language));
    });
    panels.forEach((panel) => {
      panel.hidden = panel.dataset.visionPanel !== language;
    });
    document.documentElement.dataset.visionLanguage = language;
  };

  buttons.forEach((button) => {
    button.addEventListener("click", () => setLanguage(button.dataset.visionLanguage));
  });
})();
