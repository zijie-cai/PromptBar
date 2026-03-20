const downloadUrl =
  'https://github.com/zijie-cai/PromptBar/releases/latest/download/PromptBar.zip';

const paletteResults = [
  {
    emoji: '🧠',
    title: 'Blog Writer',
    description: 'Write a structured blog post with a clear angle and outline.',
  },
  {
    emoji: '✉️',
    title: 'Friendly Email Draft',
    description: 'Draft a concise, warm reply with polished professional tone.',
  },
  {
    emoji: '💻',
    title: 'Debug Code',
    description: 'Analyze a bug, explain the issue, and suggest the next fix.',
  },
];

const features = [
  {
    title: 'Always close at hand',
    body: 'PromptBar lives in the menu bar, so your prompt library stays available without taking over the desktop.',
  },
  {
    title: 'Built for speed',
    body: 'Open the palette, type a few letters, and copy the prompt you need in one motion.',
  },
  {
    title: 'Native by design',
    body: 'The experience is tuned for macOS with a focused palette, calm visuals, and lightweight interactions.',
  },
];

const steps = [
  'Download PromptBar.zip',
  'Move PromptBar.app to Applications',
  'Open the app and keep it in the menu bar',
];

export default function App() {
  return (
    <main className="site-shell">
      <div className="site-background" aria-hidden="true">
        <div className="gradient-orb gradient-orb-left" />
        <div className="gradient-orb gradient-orb-right" />
      </div>

      <section className="hero">
        <header className="topbar">
          <div className="brand-lockup">
            <div className="brand-mark">⌘</div>
            <span>PromptBar</span>
          </div>
          <nav className="topbar-links" aria-label="Primary">
            <a href="#overview">Overview</a>
            <a href="#download">Download</a>
            <a href="https://github.com/zijie-cai/PromptBar">GitHub</a>
          </nav>
        </header>

        <div className="hero-copy">
          <p className="eyebrow">Native macOS utility</p>
          <h1>Keep your best prompts one shortcut away.</h1>
          <p className="hero-body">
            PromptBar is a menu bar app for saving, searching, and copying AI prompts instantly.
            Fast to open. Quiet to use. Built to feel at home on macOS.
          </p>

          <div className="hero-actions">
            <a className="primary-button" href={downloadUrl} id="download">
              Download for macOS
            </a>
            <a className="secondary-button" href="https://github.com/zijie-cai/PromptBar/releases/latest">
              View release notes
            </a>
          </div>

          <p className="hero-meta">macOS menu bar app · Quick access with ⌘⇧P · ZIP download</p>
        </div>

        <div className="hero-visual" aria-hidden="true">
          <div className="menu-bar-preview">
            <div className="menu-dot" />
            <div className="menu-item-label">PromptBar</div>
            <div className="menu-shortcut">⌘⇧P</div>
          </div>

          <div className="palette-card">
            <div className="palette-header">
              <div className="palette-title">
                <span className="palette-logo">⌘</span>
                <span>PromptBar</span>
              </div>
              <span className="palette-chip">Quick Access</span>
            </div>

            <div className="palette-search">Search prompts…</div>

            <div className="palette-results">
              {paletteResults.map((item, index) => (
                <div
                  className={`palette-row ${index === 0 ? 'palette-row-selected' : ''}`}
                  key={item.title}
                >
                  <div className="palette-row-emoji">{item.emoji}</div>
                  <div className="palette-row-copy">
                    <div className="palette-row-title">{item.title}</div>
                    <div className="palette-row-description">{item.description}</div>
                  </div>
                  <div className="palette-row-action">{index === 0 ? 'Copied' : 'Copy'}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      <section className="overview-section" id="overview">
        <div className="section-heading">
          <p className="eyebrow">Overview</p>
          <h2>A focused utility for prompts you use every day.</h2>
        </div>

        <div className="feature-grid">
          {features.map((feature) => (
            <article className="feature-card" key={feature.title}>
              <h3>{feature.title}</h3>
              <p>{feature.body}</p>
            </article>
          ))}
        </div>
      </section>

      <section className="showcase-section">
        <div className="showcase-card">
          <div className="showcase-copy">
            <p className="eyebrow">Built for macOS</p>
            <h2>Open, search, copy, and move on.</h2>
            <p>
              PromptBar is designed around a single job: giving you fast access to saved prompts
              without turning into a dashboard.
            </p>
          </div>

          <div className="editor-preview" aria-hidden="true">
            <div className="editor-sidebar">
              <div className="editor-sidebar-label">Favorites</div>
              <div className="editor-list-item editor-list-item-active">🧠 Blog Writer</div>
              <div className="editor-list-item">✉️ Friendly Email Draft</div>
              <div className="editor-list-item">💻 Debug Code</div>
            </div>
            <div className="editor-main">
              <div className="editor-field editor-field-title">Blog Writer</div>
              <div className="editor-field">Write a structured article with clear framing.</div>
              <div className="editor-textarea">
                Write a compelling blog post about [TOPIC]. Include a clear introduction, three
                strong sections, and a concise conclusion.
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="download-section">
        <div className="download-card">
          <div>
            <p className="eyebrow">Download</p>
            <h2>Install in a minute.</h2>
          </div>

          <ol className="install-list">
            {steps.map((step) => (
              <li key={step}>{step}</li>
            ))}
          </ol>

          <div className="download-actions">
            <a className="primary-button" href={downloadUrl}>
              Download PromptBar
            </a>
            <p className="download-note">
              To use the global shortcut, allow PromptBar in System Settings → Privacy &amp;
              Security → Accessibility.
            </p>
          </div>
        </div>
      </section>
    </main>
  );
}
