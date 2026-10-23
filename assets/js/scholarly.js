document.querySelectorAll("[data-copy-scholarly-citation]").forEach((button) => {
  button.addEventListener("click", async () => {
    const code = button.closest(".scholarly-citation").querySelector("[data-scholarly-bibtex]");
    try {
      await navigator.clipboard.writeText(code.textContent);
      button.textContent = "Copied!";
      setTimeout(() => (button.textContent = "Copy BibTeX"), 2000);
    } catch {
      const selection = window.getSelection();
      const range = document.createRange();
      range.selectNodeContents(code);
      selection.removeAllRanges();
      selection.addRange(range);
      button.textContent = "Selected — press Ctrl/Cmd+C";
    }
  });
});
