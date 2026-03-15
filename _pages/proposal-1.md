---
layout: page
title: Research Vision
permalink: /research-vision/
description: Research Vision - Cognitive-Affective Symbiosis
nav: true
nav_order: 5
horizontal: false 
---

<style>
    /* * THEME CONFIGURATION */
    .tech-vision-container {
        --tv-bg: var(--global-bg-color);
        --tv-text: var(--global-text-color);
        --tv-text-muted: var(--global-text-color-light);
        --tv-primary: var(--global-theme-color);
        --tv-hover: var(--global-hover-color);
        --tv-border: var(--global-divider-color);
        --tv-card-bg: var(--global-card-bg-color);
        --tv-code-bg: var(--global-code-bg-color);
        
        --font-ui: 'Rajdhani', sans-serif;
        --font-body: 'Inter', sans-serif;
        --font-mono: 'JetBrains Mono', monospace;

        font-family: var(--font-body);
        color: var(--tv-text);
        position: relative;
        overflow-x: hidden;
        line-height: 1.7;
    }

    .tech-vision-container.lang-zh {
        --font-body: "Noto Serif SC", "PingFang SC", serif; 
    }

    /* --- HEADER & TOGGLE --- */
    .vision-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        border-bottom: 1px solid var(--tv-border);
        padding-bottom: 1rem;
    }

    .doc-id {
        font-family: var(--font-mono);
        font-size: 0.8rem;
        color: var(--tv-text-muted);
    }

    .lang-switch-group {
        display: flex;
        gap: 0.5rem;
        font-family: var(--font-mono);
        font-size: 0.9rem;
    }

    .lang-btn {
        background: transparent;
        border: 1px solid transparent;
        color: var(--tv-text-muted);
        cursor: pointer;
        padding: 2px 8px;
        transition: all 0.3s;
    }
    .lang-btn.active {
        color: var(--tv-primary);
        border: 1px solid var(--tv-primary);
        box-shadow: 0 0 8px rgba(var(--tv-primary), 0.2);
    }
    .lang-btn:hover { color: var(--tv-text); }

    /* --- TYPOGRAPHY --- */
    .tech-h1 {
        font-family: var(--font-ui);
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        font-size: 2.2rem;
        line-height: 1.1;
        margin-bottom: 1.5rem;
    }
    
    .tech-h2 {
        font-family: var(--font-ui);
        font-weight: 700;
        text-transform: uppercase;
        font-size: 1.4rem;
        border-bottom: 1px solid var(--tv-border);
        padding-bottom: 10px;
        margin-bottom: 2rem;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .tech-label {
        font-family: var(--font-mono);
        font-size: 0.7rem;
        color: var(--tv-primary);
        letter-spacing: 0.1em;
        text-transform: uppercase;
        opacity: 0.9;
    }

    /* --- CITATION LINKS --- */
    .citation-link {
        font-family: var(--font-mono);
        font-size: 0.75em;
        color: var(--tv-primary);
        text-decoration: none;
        vertical-align: super;
        margin-left: 2px;
        opacity: 0.8;
        border-bottom: 1px dotted transparent;
    }
    .citation-link:hover {
        opacity: 1;
        border-bottom-color: var(--tv-primary);
    }

    /* --- HERO --- */
    .mission-box {
        background: var(--tv-code-bg);
        border: 1px solid var(--tv-border);
        border-left: 4px solid var(--tv-primary);
        padding: 2rem;
        margin: 2rem 0;
        font-family: var(--font-body);
        font-size: 1.1rem;
        font-weight: 500;
        color: var(--tv-text);
        font-style: italic;
    }

    /* --- GAP CARDS --- */
    .gap-grid { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
    .gap-card {
        background: var(--tv-card-bg);
        border: 1px solid var(--tv-border);
        padding: 1.5rem;
        position: relative;
        overflow: hidden;
        transition: all 0.3s ease;
    }
    .gap-card:hover { border-color: var(--tv-primary); box-shadow: 0 0 15px rgba(0,0,0,0.05); }

    .gap-card-header {
        display: flex; justify-content: space-between; margin-bottom: 1rem;
        font-family: var(--font-ui); font-weight: 700; font-size: 1.1rem; text-transform: uppercase;
    }

    .gap-scanner {
        height: 2px; background: var(--tv-border); width: 100%; margin-bottom: 1rem; position: relative; overflow: hidden;
    }
    .gap-scanner::after {
        content: ''; position: absolute; top: 0; left: -100%; width: 100%; height: 100%;
        background: linear-gradient(90deg, transparent, var(--tv-primary), transparent);
        transition: left 0.5s ease;
    }
    .gap-card:hover .gap-scanner::after { left: 100%; transition: left 1s ease-in-out; }

    .gap-content {
        display: grid; grid-template-columns: 1fr 1px 1fr; gap: 1rem; align-items: start; font-size: 0.9rem;
    }
    .gap-divider { background: var(--tv-border); height: 100%; width: 1px; }

    .state-label { font-family: var(--font-mono); font-size: 0.65rem; display: block; margin-bottom: 0.5rem; }
    .current-text { color: var(--tv-text-muted); }
    .target-text { color: var(--tv-text); font-weight: 600; opacity: 0.5; transition: all 0.3s; }
    .gap-card:hover .target-text { opacity: 1; text-shadow: 0 0 1px currentColor; }

    /* --- HORIZON LISTS --- */
    .horizon-section {
        border-left: 2px solid var(--tv-border); padding-left: 2rem; margin-bottom: 3rem; position: relative;
    }
    .horizon-section::before {
        content: ''; position: absolute; left: -6px; top: 0; width: 10px; height: 10px;
        background: var(--tv-bg); border: 2px solid var(--tv-primary); transform: rotate(45deg);
    }
    .horizon-title {
        font-family: var(--font-ui); font-weight: 700; font-size: 1.2rem; text-transform: uppercase;
        color: var(--tv-text); margin-bottom: 1rem;
    }
    .horizon-list li { margin-bottom: 0.8rem; color: var(--tv-text-muted); list-style: none; position: relative; padding-left: 1.5rem; }
    .horizon-list li::before {
        content: ">>"; position: absolute; left: 0; font-family: var(--font-mono); font-size: 0.7rem; color: var(--tv-primary); top: 4px;
    }
    .more-indicator { opacity: 0.5; letter-spacing: 2px; font-family: var(--font-mono); }
    .more-indicator::before { content: "" !important; } /* Remove arrow for ellipsis */
    
    .highlight-term { color: var(--tv-text); font-weight: 600; border-bottom: 1px dotted var(--tv-primary); }

    /* --- FOOTER: PYTHON STYLE --- */
    .py-footer {
        padding-top: 2rem;
        margin-top: 3rem;
        border-top: 1px solid var(--tv-border);
        font-family: var(--font-mono);
        font-size: 0.85rem;
        color: var(--tv-text-muted);
    }
    .code-block {
        background: var(--tv-code-bg);
        padding: 10px 15px;
        border-radius: 4px;
        display: inline-block;
        cursor: pointer;
        transition: all 0.2s;
        border: 1px solid transparent;
    }
    .code-block:hover {
        border-color: var(--tv-primary);
        color: var(--tv-text);
    }
    .keyword { color: #d73a49; }
    .string { color: #032f62; }
    [data-theme="dark"] .keyword { color: #ff7b72; }
    [data-theme="dark"] .string { color: #a5d6ff; }

    @media (max-width: 768px) {
        .gap-content { grid-template-columns: 1fr; gap: 1.5rem; }
        .gap-divider { display: none; }
        .tech-h1 { font-size: 1.8rem; }
    }
</style>

<div class="tech-vision-container">

    <div class="vision-header">
        <div class="doc-id">DOC_REF: PROPOSAL_2026-2030</div>
        <div class="lang-switch-group">
            <button class="lang-btn active" onclick="setLang('en')" id="btn-en">EN</button>
            <span>/</span>
            <button class="lang-btn" onclick="setLang('zh')" id="btn-zh">CN</button>
        </div>
    </div>

    <section class="mb-5">
        <div class="tech-label mb-2" data-i18n="hero_badge">RESEARCH VISION</div>
        <h1 class="tech-h1">
            <span data-i18n="hero_title_1">Towards</span> <br>
            <span style="color: var(--tv-primary);" data-i18n="hero_title_highlight">Cognitive-Affective Symbiosis</span>
        </h1>
        
        <p class="lead" style="color: var(--tv-text-muted); font-size: 1.1rem; max-width: 800px;" data-i18n="hero_desc">
            Moving beyond surface-level signal processing to build embodied, psychologically grounded intelligence.
        </p>
        <div class="mission-box">
            "How can we build psychologically grounded, fine-grained, multimodal, efficient, evolving, and full-duplex conversational AI systems that better understand and respond to human emotions?"
        </div>
    </section>

    <section class="mb-5">
        <h2 class="tech-h2">
            <span data-i18n="gap_title">Paradigm Shift Analysis</span>
            <span class="tech-label" style="font-size: 0.6rem;">MOUSE_OVER_TO_SCAN</span>
        </h2>

        <p class="mb-4" style="color: var(--tv-text-muted);" data-i18n="gap_intro">
            Identifying critical bottlenecks in current SOTA systems: from passive semantic processing to active social agency.
        </p>

        <div class="gap-grid">
            
            <div class="gap-card">
                <div class="gap-card-header" data-i18n="card1_title">Social Agency</div>
                <div class="gap-scanner"></div>
                <div class="gap-content">
                    <div class="current-state">
                        <span class="state-label">CURRENT: PASSIVE RETRIEVER</span>
                        <div class="current-text" data-i18n="card1_current">
                            Powerful semantic engines, but fundamentally "solipsistic." Limited Theory of Mind (ToM) capabilities <a href="https://arxiv.org/abs/2302.02083" target="_blank" class="citation-link">[Kosinski, 2023]</a> lead to superficial empathy.
                        </div>
                    </div>
                    <div class="gap-divider"></div>
                    <div class="target-state">
                        <span class="state-label">TARGET: ACTIVE RESONANCE</span>
                        <div class="target-text" data-i18n="card1_target">
                            Systems with intrinsic motivation to align with human mental states. Moving from "Understanding" to "Resonating" via psychological grounding.
                        </div>
                    </div>
                </div>
            </div>

            <div class="gap-card">
                <div class="gap-card-header" data-i18n="card2_title">Multimodal Synchrony</div>
                <div class="gap-scanner"></div>
                <div class="gap-content">
                    <div class="current-state">
                        <span class="state-label">CURRENT: ASYNCHRONOUS</span>
                        <div class="current-text" data-i18n="card2_current">
                            Despite advances like GPT-4o <a href="https://openai.com/index/hello-gpt-4o/" target="_blank" class="citation-link">[OpenAI, 2024]</a>, fine-grained behavioral cues (micro-expressions) are often lost in "text-dominant" latent spaces.
                        </div>
                    </div>
                    <div class="gap-divider"></div>
                    <div class="target-state">
                        <span class="state-label">TARGET: HIGH-FIDELITY</span>
                        <div class="target-text" data-i18n="card2_target">
                            Efficient adapters that preserve low-level acoustic/visual features, enabling real-time affective synchronization.
                        </div>
                    </div>
                </div>
            </div>

            <div class="gap-card">
                <div class="gap-card-header" data-i18n="card3_title">Temporal Dynamics</div>
                <div class="gap-scanner"></div>
                <div class="gap-content">
                    <div class="current-state">
                        <span class="state-label">CURRENT: AMNESIC & RIGID</span>
                        <div class="current-text" data-i18n="card3_current">
                            Suffers from "Temporal Amnesia" regarding affective history <a href="https://arxiv.org/abs/2304.03442" target="_blank" class="citation-link">[Park et al., 2023]</a>. Constrained by turn-taking (wait-to-speak) latency.
                        </div>
                    </div>
                    <div class="gap-divider"></div>
                    <div class="target-state">
                        <span class="state-label">TARGET: CONTINUOUS FLOW</span>
                        <div class="target-text" data-i18n="card3_target">
                            Full-duplex (interruptible) interaction backed by evolving, long-term affective memory.
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <section class="mb-5">
        <h2 class="tech-h2">
            <span data-i18n="roadmap_title">Research Horizons</span>
            <span class="tech-label" style="font-size: 0.6rem;">STRATEGIC_TRAJECTORY</span>
        </h2>
        
        <div class="horizon-section">
            <div class="tech-label mb-1" data-i18n="h1_label">HORIZON I</div>
            <div class="horizon-title" data-i18n="h1_title">Foundation & Efficiency</div>
            <ul class="horizon-list">
                <li data-i18n="h1_p1">Developing <span class="highlight-term">Data Infrastructure</span> for high-fidelity, fine-grained multimodal emotion analysis.</li>
                <li data-i18n="h1_p2">Designing cost-effective <span class="highlight-term">Multimodal Adapters</span> to align LLMs with non-verbal signals.</li>
                <li data-i18n="h1_p3">Enabling efficient test-time adaptation for personalized user alignment.</li>
                <li class="more-indicator">...</li>
            </ul>
        </div>

        <div class="horizon-section">
            <div class="tech-label mb-1" data-i18n="h2_label">HORIZON II</div>
            <div class="horizon-title" data-i18n="h2_title">Cognitive Kernel</div>
            <ul class="horizon-list">
                <li data-i18n="h2_p1">Building <span class="highlight-term">Long-Term Affective Memory</span> with dynamic update and retrieval mechanisms.</li>
                <li data-i18n="h2_p2">Integrating <span class="highlight-term">Theory of Mind (ToM)</span> to infer implicit mental states and intent <a href="https://web.media.mit.edu/~picard/" target="_blank" class="citation-link">[Picard, MIT]</a>.</li>
                <li data-i18n="h2_p3">Creating the "Psychological Mirror": Systems that reflect and validate user emotions.</li>
                <li class="more-indicator">...</li>
            </ul>
        </div>

        <div class="horizon-section">
            <div class="tech-label mb-1" data-i18n="h3_label">HORIZON III</div>
            <div class="horizon-title" data-i18n="h3_title">Embodiment & Complexity</div>
            <ul class="horizon-list">
                <li data-i18n="h3_p1">Realizing <span class="highlight-term">Full-Duplex Interaction</span>: Handling interruptions, backchanneling, and multi-party dynamics.</li>
                <li data-i18n="h3_p2">Bridging generative AI with <span class="highlight-term">Robotics</span> for parametric expression control <a href="https://www.science.org/doi/10.1126/scirobotics.adi4724" target="_blank" class="citation-link">[Hu et al., 2024]</a>.</li>
                <li data-i18n="h3_p3">Achieving seamless cognitive-affective symbiosis in complex, real-world scenarios.</li>
                <li class="more-indicator">...</li>
            </ul>
        </div>
    </section>

    <div class="py-footer">
        <div>Junjie (Jorji) Chen</div>
        <div class="mt-2">
            <span class="code-block" onclick="copyEmail()">
                <span class="keyword">email</span> = <span class="string">"jorji.chen"</span> + <span class="string">"@"</span> + <span class="string">"gmail.com"</span>
            </span>
        </div>
    </div>

</div>

<script>
    const i18n = {
        en: {
            hero_badge: "RESEARCH VISION",
            hero_title_1: "Towards",
            hero_title_highlight: "Cognitive-Affective Symbiosis",
            hero_desc: "Moving beyond surface-level signal processing to build embodied, psychologically grounded intelligence.",
            
            gap_title: "Paradigm Shift Analysis",
            gap_intro: "Current LLMs excel at text generation but face critical bottlenecks in social cognition, memory retention, and interaction dynamics.",
            
            // Cards
            card1_title: "Social Agency",
            card1_current: "Powerful semantic engines, but fundamentally 'solipsistic.' Limited Theory of Mind (ToM) capabilities <a href='https://arxiv.org/abs/2302.02083' target='_blank' class='citation-link'>[Kosinski, 2023]</a> lead to superficial empathy.",
            card1_target: "Systems with intrinsic motivation to align with human mental states. Moving from 'Understanding' to 'Resonating' via psychological grounding.",
            
            card2_title: "Multimodal Synchrony",
            card2_current: "Despite advances like GPT-4o <a href='https://openai.com/index/hello-gpt-4o/' target='_blank' class='citation-link'>[OpenAI, 2024]</a>, fine-grained behavioral cues (micro-expressions) are often lost in 'text-dominant' latent spaces.",
            card2_target: "Efficient adapters that preserve low-level acoustic/visual features, enabling real-time affective synchronization.",

            card3_title: "Temporal Dynamics",
            card3_current: "Suffers from 'Temporal Amnesia' regarding affective history <a href='https://arxiv.org/abs/2304.03442' target='_blank' class='citation-link'>[Park et al., 2023]</a>. Constrained by turn-taking (wait-to-speak) latency.",
            card3_target: "Full-duplex (interruptible) interaction backed by evolving, long-term affective memory.",

            roadmap_title: "Research Horizons",
            
            h1_label: "HORIZON I", h1_title: "Foundation & Efficiency",
            h1_p1: "Developing <span class='highlight-term'>Data Infrastructure</span> for high-fidelity, fine-grained multimodal emotion analysis.",
            h1_p2: "Designing cost-effective <span class='highlight-term'>Multimodal Adapters</span> to align LLMs with non-verbal signals.",
            h1_p3: "Enabling efficient test-time adaptation for personalized user alignment.",

            h2_label: "HORIZON II", h2_title: "Cognitive Kernel",
            h2_p1: "Building <span class='highlight-term'>Long-Term Affective Memory</span> with dynamic update and retrieval mechanisms.",
            h2_p2: "Integrating <span class='highlight-term'>Theory of Mind (ToM)</span> to infer implicit mental states and intent <a href='https://web.media.mit.edu/~picard/' target='_blank' class='citation-link'>[Picard, MIT]</a>.",
            h2_p3: "Creating the 'Psychological Mirror': Systems that reflect and validate user emotions.",

            h3_label: "HORIZON III", h3_title: "Embodiment & Complexity",
            h3_p1: "Realizing <span class='highlight-term'>Full-Duplex Interaction</span>: Handling interruptions, backchanneling, and multi-party dynamics.",
            h3_p2: "Bridging generative AI with <span class='highlight-term'>Robotics</span> for parametric expression control <a href='https://www.science.org/doi/10.1126/scirobotics.adi4724' target='_blank' class='citation-link'>[Hu et al., 2024]</a>.",
            h3_p3: "Achieving seamless cognitive-affective symbiosis in complex, real-world scenarios."
        },
        zh: {
            hero_badge: "研究愿景",
            hero_title_1: "迈向",
            hero_title_highlight: "认知-情感共生系统",
            hero_desc: "超越表层的信号处理，构建具身的、具有心理学基础的智能系统。",
            
            gap_title: "范式转换分析",
            gap_intro: "当前的大语言模型擅长文本生成，但在社会认知、记忆保持和交互动态方面面临关键瓶颈。",

            // Cards
            card1_title: "社会代理 (Social Agency)",
            card1_current: "强大的语义引擎，但本质上是“唯我论”的。受限的心智理论 (ToM) 能力 <a href='https://arxiv.org/abs/2302.02083' target='_blank' class='citation-link'>[Kosinski, 2023]</a> 导致了肤浅的共情。",
            card1_target: "具备内在动机去对齐人类心理状态的系统。通过心理学基础，从单纯的“理解”迈向“共鸣”。",

            card2_title: "多模态同步",
            card2_current: "尽管有 GPT-4o <a href='https://openai.com/index/hello-gpt-4o/' target='_blank' class='citation-link'>[OpenAI, 2024]</a> 等进展，细粒度的行为线索（微表情）常在“文本主导”的潜空间中丢失。",
            card2_target: "高效的适配器，保留低层级的声学/视觉特征，实现实时的情感同步。",

            card3_title: "时间动态",
            card3_current: "对情感历史存在“时间失忆” <a href='https://arxiv.org/abs/2304.03442' target='_blank' class='citation-link'>[Park et al., 2023]</a>。受限于轮流对话（等待-发言）的延迟。",
            card3_target: "全双工（可打断）交互，支持连续、演进的长期情感记忆。",

            roadmap_title: "研究视界",
            
            h1_label: "视界 I", h1_title: "基石与效率",
            h1_p1: "建立<span class='highlight-term'>数据基础设施</span>，用于高保真、细粒度的多模态情感分析。",
            h1_p2: "设计低成本的<span class='highlight-term'>多模态适配器</span>，将现有LLM与非语言信号对齐。",
            h1_p3: "实现高效的测试时适应 (Test-time Adaptation) 以达成个性化对齐。",

            h2_label: "视界 II", h2_title: "认知核心",
            h2_p1: "构建<span class='highlight-term'>长期情感记忆</span>，包含动态更新和检索机制。",
            h2_p2: "整合<span class='highlight-term'>心智理论 (ToM)</span> <a href='https://web.media.mit.edu/~picard/' target='_blank' class='citation-link'>[Picard, MIT]</a>，推断用户的隐性意图和心理状态。",
            h2_p3: "打造“心理镜像”：能够反射并确认用户情绪的系统。",

            h3_label: "视界 III", h3_title: "具身与复杂性",
            h3_p1: "实现<span class='highlight-term'>全双工交互</span>：处理打断、语气词反馈及多人动态场景。",
            h3_p2: "连接生成式AI与<span class='highlight-term'>机器人技术</span> <a href='https://www.science.org/doi/10.1126/scirobotics.adi4724' target='_blank' class='citation-link'>[Hu et al., 2024]</a>，实现参数化的表情控制。",
            h3_p3: "在复杂的现实场景中实现无缝的认知-情感共生。"
        }
    };

    function setLang(lang) {
        const wrapper = document.querySelector('.tech-vision-container');
        const btnEn = document.getElementById('btn-en');
        const btnZh = document.getElementById('btn-zh');

        if(lang === 'zh') {
            wrapper.classList.add('lang-zh');
            btnEn.classList.remove('active');
            btnZh.classList.add('active');
        } else {
            wrapper.classList.remove('lang-zh');
            btnZh.classList.remove('active');
            btnEn.classList.add('active');
        }

        document.querySelectorAll('[data-i18n]').forEach(el => {
            const key = el.getAttribute('data-i18n');
            if (i18n[lang][key]) el.innerHTML = i18n[lang][key];
        });
    }

    function copyEmail() {
        const email = "jorji.chen" + "@" + "gmail.com";
        navigator.clipboard.writeText(email).then(() => {
            alert("Email copied to clipboard: " + email);
        }).catch(err => {
            console.error('Failed to copy: ', err);
            window.location.href = "mailto:" + email;
        });
    }
</script>
