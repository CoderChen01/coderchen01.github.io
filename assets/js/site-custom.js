(() => {
  const prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

  const initSpeechButtons = () => {
    document.querySelectorAll("[data-speech]").forEach((button) => {
      button.addEventListener("click", () => {
        if (!("speechSynthesis" in window)) return;

        window.speechSynthesis.cancel();
        const utterance = new SpeechSynthesisUtterance(button.dataset.speech);
        utterance.lang = button.dataset.lang || "en-US";
        utterance.rate = 0.8;
        utterance.addEventListener("start", () => button.classList.add("is-speaking"));
        utterance.addEventListener("end", () => button.classList.remove("is-speaking"));
        utterance.addEventListener("error", () => button.classList.remove("is-speaking"));
        window.speechSynthesis.speak(utterance);
      });
    });
  };

  const initExperienceTrack = () => {
    const track = document.querySelector("[data-experience-track]");
    if (!track) return;

    document.querySelectorAll("[data-experience-direction]").forEach((button) => {
      button.addEventListener("click", () => {
        const card = track.querySelector(".experience-card");
        const gap = Number.parseFloat(getComputedStyle(track).columnGap) || 0;
        const distance = (card?.getBoundingClientRect().width || track.clientWidth) + gap;
        track.scrollBy({ left: Number(button.dataset.experienceDirection) * distance, behavior: "smooth" });
      });
    });

    let startX = 0;
    let startScrollLeft = 0;
    track.addEventListener("pointerdown", (event) => {
      if (event.pointerType === "touch") return;
      if (event.target.closest("a, button, input, select, textarea, [role='button']")) return;
      startX = event.clientX;
      startScrollLeft = track.scrollLeft;
      track.classList.add("is-dragging");
      track.setPointerCapture(event.pointerId);
    });
    track.addEventListener("pointermove", (event) => {
      if (!track.classList.contains("is-dragging")) return;
      track.scrollLeft = startScrollLeft - (event.clientX - startX);
    });
    const stopDragging = () => track.classList.remove("is-dragging");
    track.addEventListener("pointerup", stopDragging);
    track.addEventListener("pointercancel", stopDragging);
  };

  const initAuthorToggles = () => {
    document.querySelectorAll("[data-author-toggle]").forEach((button) => {
      const middle = document.getElementById(button.getAttribute("aria-controls"));
      if (!middle) return;

      button.addEventListener("click", () => {
        const isExpanded = button.getAttribute("aria-expanded") === "true";
        middle.hidden = isExpanded;
        button.setAttribute("aria-expanded", String(!isExpanded));
        button.textContent = isExpanded ? button.dataset.collapsedLabel : button.dataset.expandedLabel;
      });
    });
  };

  const initPublicationNotes = () => {
    document.querySelectorAll(".publication-annotation").forEach((container) => {
      const trigger = container.querySelector(".publication-note-trigger");
      const note = container.querySelector(".publication-note");
      if (!trigger || !note) return;
      document.body.append(note);
      let hideTimer;
      const hide = () => {
        note.classList.remove("is-visible");
        trigger.setAttribute("aria-expanded", "false");
      };
      const show = () => {
        clearTimeout(hideTimer);
        const bounds = trigger.getBoundingClientRect();
        const width = note.getBoundingClientRect().width;
        const height = note.getBoundingClientRect().height;
        note.style.left = `${Math.max(16, Math.min(bounds.left, window.innerWidth - width - 16))}px`;
        note.style.top = `${bounds.top > height + 24 ? bounds.top - height - 10 : bounds.bottom + 10}px`;
        note.classList.add("is-visible");
        trigger.setAttribute("aria-expanded", "true");
      };
      const hideSoon = () => {
        hideTimer = setTimeout(hide, 100);
      };
      trigger.addEventListener("pointerenter", show);
      trigger.addEventListener("pointerleave", hideSoon);
      trigger.addEventListener("focus", show);
      trigger.addEventListener("blur", hide);
      trigger.addEventListener("click", (event) => {
        event.stopPropagation();
        show();
      });
      note.addEventListener("pointerenter", () => clearTimeout(hideTimer));
      note.addEventListener("pointerleave", hideSoon);
      document.addEventListener("click", (event) => {
        if (!note.contains(event.target) && !trigger.contains(event.target)) hide();
      });
      document.addEventListener("keydown", (event) => {
        if (event.key === "Escape") hide();
      });
      window.addEventListener("scroll", hide, { passive: true });
      window.addEventListener("resize", hide, { passive: true });
    });
  };

  const initPointerGlow = () => {
    if (prefersReducedMotion.matches || !window.matchMedia("(pointer: fine)").matches) return;

    let frame = 0;
    let pointerX = window.innerWidth / 2;
    let pointerY = window.innerHeight * 0.22;

    window.addEventListener(
      "pointermove",
      (event) => {
        pointerX = event.clientX;
        pointerY = event.clientY;
        if (frame) return;

        frame = window.requestAnimationFrame(() => {
          document.body.style.setProperty("--pointer-x", `${pointerX}px`);
          document.body.style.setProperty("--pointer-y", `${pointerY}px`);
          frame = 0;
        });
      },
      { passive: true }
    );
  };

  const initScrollReveals = () => {
    const selectors = [
      '[role="main"] .post-header',
      '[role="main"] .profile',
      '[role="main"] .clearfix > p',
      '[role="main"] .clearfix > blockquote',
      '[role="main"] .clearfix > ul',
      '[role="main"] .home-section',
      '[role="main"] .news',
      '[role="main"] .publications ol.bibliography > li',
      '[role="main"] .post-list > li',
      '[role="main"] .featured-posts .card',
      '[role="main"] .tech-vision-container > *',
    ];
    const items = [...new Set(document.querySelectorAll(selectors.join(",")))];
    if (!items.length || prefersReducedMotion.matches || !("IntersectionObserver" in window)) return;

    document.documentElement.classList.add("reveal-enabled");
    items.forEach((item, index) => {
      item.classList.add("reveal-item");
      item.style.setProperty("--reveal-delay", `${(index % 5) * 55}ms`);
    });

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting) return;
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        });
      },
      { rootMargin: "0px 0px -7%", threshold: 0.08 }
    );

    items.forEach((item) => observer.observe(item));
  };

  const initClickResearchQuestions = () => {
    if (prefersReducedMotion.matches) return;

    const threads = [
      ["Why this problem?", "Is it real?", "Or just imaginary?", "Who suffers from it?", "Does it matter?"],
      ["Starting point?", "First principles?", "Any assumption?", "Does it hold?", "Back to basics?"],
      ["Is it novel?", "Really?", "Or just complex?", "Simpler way?", "Ockham's Razor?"],
      ["So what?", "Incremental?", "Breakthrough?", "Will it last?", "10 years later?"],
      ["Just SOTA hacking?", "0.1% improvement?", "Statistically significant?", "Is it worth it?", "True impact?"],
      ["Does it understand?", "Or just pattern matching?", "Stochastic parrot?", "Reasoning or retrieval?", "Intelligence?"],
      ["Black box?", "Why it works?", "Interpretability?", "Can we trust it?", "Safety?"],
      ["Data hungry?", "Quality over quantity?", "Bias inside?", "Garbage in?", "Garbage out?"],
      ["It works here.", "But everywhere?", "OOD generalization?", "Corner cases?", "Adversarial attack?"],
      ["Too complex?", "Hard to deploy?", "GPU rich?", "Latency?", "Scalability?"],
      ["Reproducible?", "Code available?", "Seeds fixed?", "Cherry-picked?", "Honest reporting?"],
      ["Fair comparison?", "Weak baselines?", "Same settings?", "Ablation study?", "Isolating the gain?"],
      ["Why research?", "For truth?", "For fame?", "Do you love it?", "Keep going."],
      ["Stuck?", "Zoom out.", "Read more.", "Think deeper.", "Write it down."],
    ];

    let activeThread = [];
    let activeIndex = 0;
    let idleTimer = 0;

    document.addEventListener("click", (event) => {
      if (!event.clientX && !event.clientY) return;
      if (!activeThread.length || activeIndex >= activeThread.length) {
        activeThread = threads[Math.floor(Math.random() * threads.length)];
        activeIndex = 0;
      }

      window.clearTimeout(idleTimer);
      idleTimer = window.setTimeout(() => {
        activeThread = [];
        activeIndex = 0;
      }, 5000);

      const pulse = document.createElement("span");
      pulse.className = "click-pulse";
      pulse.style.left = `${event.clientX}px`;
      pulse.style.top = `${event.clientY}px`;
      pulse.setAttribute("aria-hidden", "true");

      const text = document.createElement("span");
      text.className = "click-floating-text";
      text.textContent = activeThread[activeIndex];
      activeIndex += 1;
      text.style.left = `${event.clientX + (Math.random() - 0.5) * 46}px`;
      text.style.top = `${event.clientY - 10}px`;
      text.style.setProperty("--click-drift", `${(Math.random() - 0.5) * 58}px`);
      text.style.setProperty("--click-rotation", `${(Math.random() - 0.5) * 6}deg`);
      text.setAttribute("aria-hidden", "true");

      document.body.append(pulse, text);
      window.setTimeout(() => pulse.remove(), 800);
      window.setTimeout(() => text.remove(), 2400);
    });
  };

  const initialize = () => {
    initSpeechButtons();
    initExperienceTrack();
    initAuthorToggles();
    initPublicationNotes();
    initPointerGlow();
    initScrollReveals();
    initClickResearchQuestions();
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initialize, { once: true });
  } else {
    initialize();
  }
})();
