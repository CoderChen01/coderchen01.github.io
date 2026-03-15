---
layout: about
title: About Me
permalink: /
subtitle: >
  My Chinese name is <span class="cyber-name">陈俊杰</span> <span style="font-family: monospace; color: var(--global-text-color-light); font-size: 0.8em;">// 陳俊傑 [Sounds like: Ch-urn June-Jee-eh]</span>.
  <span class="audio-btn" onclick="speakName('陈俊杰', 'zh-CN')" title="Pronunciation: Chén Jùnjié">
    <i class="fa-solid fa-volume-high"></i>
  </span> <br/>
  You can call me <strong>Jorji</strong>.
  <span class="audio-btn" onclick="speakName('Jorji', 'en-US')" title="Pronunciation: Jorji">
    <i class="fa-solid fa-volume-high"></i>
  </span> <br/>
profile:
  align: right
  image: prof_pic.jpg
  image_circular: false # crops the image to make it circular
  # more_info: >
  #   <p>🗺️C711@AHPU, Wuhu</p>

news: true # includes a list of news items
selected_papers: true # includes a list of papers marked as "selected={true}"
social: false # includes social icons at the bottom of the page
---

I was born in November 2002 in [Lu’an, Anhui, China](https://en.wikipedia.org/wiki/Lu%27an). I am currently in the final year of my Master’s degree at Anhui Polytechnic University (AHPU), supervised by Prof. Subin Huang.

I am a Research Intern at the [Institute of Artificial Intelligence](https://iai.ustc.edu.cn/iai/), [Hefei](https://en.wikipedia.org/wiki/Hefei) Comprehensive National Science Center, supervised by Prof. [Meng Wang](https://scholar.google.com/citations?user=rHagaaIAAAAJ&hl=en), and I plan to apply for PhD studies in Fall 2026. I am also working with [Linfeng Zhang](https://scholar.google.com/citations?user=AK9VF30AAAAJ&hl=en&authuser=1) and his research group, where I am learning and exploring research problems related to Efficient AI.

💡 I am broadly interested in understanding how AI systems can better model human psychological and emotional states, and how such understanding can be incorporated into practical and efficient interactive systems.

---

##### 🎯 Research Focus

I am primarily interested in the following research question:

> **How can we build psychologically grounded, fine-grained, multimodal, efficient, evolving, and full-duplex conversational AI systems that better understand and respond to human emotions?**

In particular, I am learning and exploring:
- 🧠 **Psychology-informed modeling** of emotion and cognition in dialogue systems.
- 🎭 **Fine-grained emotion perception**, including subtle, dynamic, and context-dependent affect.
- 🔊🖼️ **Multimodal interaction**, combining language with visual, acoustic, and behavioral cues.
- ⚡ **Efficiency-aware methods** for building deployable and scalable dialogue models.

For a deeper dive into my long-term roadmap and methodology, please visit my **[Research Vision](./research-vision)**.

---

##### 🔬 Research Interests

The following areas reflect my **current interests and learning directions**, which support the above research focus:

- 🧠 **AI4Psychology**  
  Computational approaches to modeling psychological processes.

- ⚡ **Efficient AI**  
  Model compression, acceleration, and efficiency-oriented learning.

- 🎭 **Multimodal AI**  
  Representation learning and fusion across multiple modalities.

- 🖌️ **Generative AI**  
  Controlled and interpretable generation for dialogue and simulation.

- 🧭 **Spatial Intelligence**  
  Embodied and environment-aware reasoning related to interaction and behavior.

These directions are not independent goals, but are explored as part of a broader effort to understand and build psychologically informed conversational AI.

---

##### 💬 Let’s Collaborate!

I am always happy to learn from and collaborate with researchers interested in:
- Emotion and affect modeling grounded in psychology
- Multimodal dialogue systems
- Efficient and practical conversational AI

If our interests overlap, I would be glad to connect and exchange ideas.

<script>
function speakName(name, lang) {
  // 创建语音实例
  const utterance = new SpeechSynthesisUtterance(name);
  // 强制使用中文语音包
  utterance.lang = lang; 
  // 语速稍微慢一点，让人听清
  utterance.rate = 0.8; 
  // 播放
  window.speechSynthesis.speak(utterance);
  
  // 添加一点点击反馈动画 (可选)
  const btn = document.querySelector('.audio-btn');
  btn.style.color = 'var(--global-theme-color)';
  setTimeout(() => { btn.style.color = ''; }, 1000);
}
</script>

<style>
.audio-btn {
  cursor: pointer;
  margin-left: 8px;
  font-size: 0.9em;
  opacity: 0.6;
  transition: all 0.2s;
  vertical-align: middle;
}
.audio-btn:hover {
  opacity: 1;
  transform: scale(1.1);
  color: var(--global-theme-color); /* 悬停变霓虹色 */
}
</style>
