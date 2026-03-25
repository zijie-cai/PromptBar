import React, { useState } from 'react';
import { motion, useScroll, useTransform, useMotionTemplate, AnimatePresence } from 'motion/react';
import { 
  Download, 
  Github, 
  Terminal, 
  Search,
  Copy,
  WandSparkles,
  Zap,
  LayoutTemplate,
  Star,
  Trash2,
  Plus,
  Check
} from 'lucide-react';

const Nav = () => {
  const { scrollY } = useScroll();
  const [isScrolled, setIsScrolled] = useState(false);

  React.useEffect(() => {
    return scrollY.onChange((latest) => {
      setIsScrolled(latest > 20);
    });
  }, [scrollY]);

  return (
    <motion.nav 
      className="fixed top-0 left-0 right-0 z-50"
      initial={false}
      animate={{
        backgroundColor: isScrolled ? "rgba(18, 18, 18, 0.8)" : "rgba(18, 18, 18, 0)",
        backdropFilter: isScrolled ? "blur(16px)" : "blur(0px)",
        WebkitBackdropFilter: isScrolled ? "blur(16px)" : "blur(0px)",
        borderBottom: isScrolled ? "1px solid rgba(255, 255, 255, 0.1)" : "1px solid rgba(255, 255, 255, 0)",
        paddingTop: isScrolled ? "16px" : "24px",
        paddingBottom: isScrolled ? "16px" : "24px",
      }}
      transition={{ duration: 0.3, ease: "easeOut" }}
    >
      <div className="max-w-5xl mx-auto px-6 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <motion.div 
            whileHover={{ rotate: 15, scale: 1.1 }}
            className="w-7 h-7 bg-white rounded-lg flex items-center justify-center shadow-sm cursor-pointer"
          >
            <WandSparkles className="w-4 h-4 text-black" />
          </motion.div>
          <span className="font-semibold text-lg tracking-tight text-white">PromptBar</span>
        </div>

        <div className="flex items-center gap-5 text-[13px] font-medium">
          <span className="text-[#86868b] hidden sm:block">macOS 14+</span>
          <motion.a 
            href="https://github.com/zijie-cai/PromptBar/releases/download/v1.0.0/PromptBar-1.0.0.zip"
            target="_blank"
            rel="noopener noreferrer"
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            className="bg-white text-black px-4 py-1.5 rounded-full hover:bg-gray-200 transition-colors shadow-sm inline-flex items-center justify-center"
          >
            Download
          </motion.a>
        </div>
      </div>
    </motion.nav>
  );
};

const CommandPaletteMockup = () => (
  <motion.div 
    initial={{ opacity: 0, y: 30, scale: 0.98 }}
    animate={{ opacity: 1, y: 0, scale: 1 }}
    transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1], delay: 0.1 }}
    className="w-full max-w-[640px] mx-auto bg-[#323232] rounded-2xl shadow-[0_40px_80px_rgba(0,0,0,0.6)] border border-white/10 overflow-hidden flex flex-col"
  >
    <div className="flex items-center px-5 py-4 border-b border-white/10">
      <Search className="w-5 h-5 text-[#86868b] mr-3" />
      <div className="w-full flex items-center">
        <span className="text-[18px] font-medium text-[#86868b]">Search prompts...</span>
        <motion.span 
          animate={{ opacity: [1, 0, 1] }}
          transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
          className="w-[2px] h-[20px] bg-white/80 ml-1" 
        />
      </div>
    </div>
    <motion.div 
      initial="hidden"
      animate="visible"
      variants={{
        hidden: {},
        visible: {
          transition: { staggerChildren: 0.05, delayChildren: 0.3 }
        }
      }}
      className="p-2"
    >
      <motion.div variants={{ hidden: { opacity: 0, x: -10 }, visible: { opacity: 1, x: 0, transition: { duration: 0.4 } } }} className="px-3 py-2 text-white hover:bg-white/5 rounded-xl flex items-center gap-4 transition-colors">
        <div className="w-10 h-10 bg-[#444444] rounded-lg flex items-center justify-center text-xl shadow-sm shrink-0">
          🧠
        </div>
        <div className="flex-1 flex flex-col items-start justify-center">
          <div className="flex items-center gap-2">
            <span className="font-semibold text-[15px] leading-tight">Blog Writer</span>
            <Star className="w-3.5 h-3.5 text-[#ffd60a] fill-[#ffd60a]" />
          </div>
          <span className="text-[13px] text-[#86868b] mt-0.5 leading-tight">Write a structured blog post about a topic.</span>
        </div>
      </motion.div>
      
      <motion.div variants={{ hidden: { opacity: 0, x: -10 }, visible: { opacity: 1, x: 0, transition: { duration: 0.4 } } }} className="px-3 py-2 bg-[#4a4a4c] text-white rounded-xl flex items-center gap-4 shadow-sm mt-0.5">
        <div className="w-10 h-10 bg-[#555555] rounded-lg flex items-center justify-center text-xl shadow-sm shrink-0">
          ✉️
        </div>
        <div className="flex-1 flex flex-col items-start justify-center">
          <div className="flex items-center gap-2">
            <span className="font-semibold text-[15px] leading-tight">Friendly Email Draft</span>
            <Star className="w-3.5 h-3.5 text-[#ffd60a] fill-[#ffd60a]" />
          </div>
          <span className="text-[13px] text-[#a1a1a6] mt-0.5 leading-tight">Draft a polite professional email.</span>
        </div>
        <div className="flex items-center gap-1.5 px-2.5 py-1 bg-[#34c759]/10 border border-[#34c759]/30 rounded-md text-[#34c759] shrink-0">
          <Check className="w-3.5 h-3.5" />
          <span className="text-[12px] font-medium">Copied</span>
        </div>
      </motion.div>

      <motion.div variants={{ hidden: { opacity: 0, x: -10 }, visible: { opacity: 1, x: 0, transition: { duration: 0.4 } } }} className="px-3 py-2 text-white hover:bg-white/5 rounded-xl flex items-center gap-4 transition-colors mt-0.5">
        <div className="w-10 h-10 bg-[#444444] rounded-lg flex items-center justify-center text-xl shadow-sm shrink-0">
          📝
        </div>
        <div className="flex-1 flex flex-col items-start justify-center">
          <div className="flex items-center gap-2">
            <span className="font-semibold text-[15px] leading-tight">Summarize Article</span>
            <Star className="w-3.5 h-3.5 text-[#ffd60a] fill-[#ffd60a]" />
          </div>
          <span className="text-[13px] text-[#86868b] mt-0.5 leading-tight">Extract key points from text.</span>
        </div>
      </motion.div>

      <motion.div variants={{ hidden: { opacity: 0, x: -10 }, visible: { opacity: 1, x: 0, transition: { duration: 0.4 } } }} className="px-3 py-2 text-white hover:bg-white/5 rounded-xl flex items-center gap-4 transition-colors mt-0.5">
        <div className="w-10 h-10 bg-[#444444] rounded-lg flex items-center justify-center text-xl shadow-sm shrink-0">
          💻
        </div>
        <div className="flex-1 flex flex-col items-start justify-center">
          <div className="flex items-center gap-2">
            <span className="font-semibold text-[15px] leading-tight">Debug Code</span>
          </div>
          <span className="text-[13px] text-[#86868b] mt-0.5 leading-tight">Analyze and fix bugs in code.</span>
        </div>
      </motion.div>
      
      <motion.div variants={{ hidden: { opacity: 0, x: -10 }, visible: { opacity: 1, x: 0, transition: { duration: 0.4 } } }} className="px-3 py-2 text-white hover:bg-white/5 rounded-xl flex items-center gap-4 transition-colors mt-0.5">
        <div className="w-10 h-10 bg-[#444444] rounded-lg flex items-center justify-center text-xl shadow-sm shrink-0">
          📈
        </div>
        <div className="flex-1 flex flex-col items-start justify-center">
          <div className="flex items-center gap-2">
            <span className="font-semibold text-[15px] leading-tight">Product Strategy</span>
          </div>
          <span className="text-[13px] text-[#86868b] mt-0.5 leading-tight">Generate a product roadmap outline.</span>
        </div>
      </motion.div>
    </motion.div>
  </motion.div>
);

const EditorMockup = () => (
  <motion.div 
    initial={{ opacity: 0, y: 40 }}
    whileInView={{ opacity: 1, y: 0 }}
    viewport={{ once: true, margin: "-100px" }}
    transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
    className="w-full max-w-[900px] mx-auto bg-[#323232] rounded-xl shadow-[0_40px_80px_rgba(0,0,0,0.6)] border border-white/10 flex flex-col overflow-hidden h-[500px]"
  >
    {/* Top Bar */}
    <div className="h-[52px] bg-[#282828] border-b border-white/10 flex items-center px-4 relative shrink-0">
      <div className="flex gap-2">
        <div className="w-3 h-3 rounded-full bg-[#ff5f56] border border-black/20" />
        <div className="w-3 h-3 rounded-full bg-[#ffbd2e] border border-black/20" />
        <div className="w-3 h-3 rounded-full bg-[#27c93f] border border-black/20" />
      </div>
      <div className="absolute left-1/2 -translate-x-1/2 text-[13px] font-semibold text-[#e5e5ea]">
        Manage Prompts
      </div>
    </div>

    {/* Body */}
    <div className="flex flex-1 min-h-0">
      {/* Sidebar */}
      <div className="w-[260px] bg-[#282828] border-r border-white/10 flex flex-col hidden sm:flex shrink-0">
        <motion.div 
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
          variants={{
            hidden: {},
            visible: {
              transition: { staggerChildren: 0.05, delayChildren: 0.2 }
            }
          }}
          className="p-3 flex-1 overflow-y-auto"
        >
          <div className="flex items-center justify-between mb-2 px-2 mt-2">
            <span className="text-[13px] font-semibold text-[#e5e5ea]">All Prompts</span>
            <Plus className="w-4 h-4 text-[#86868b]" />
          </div>
          
          <motion.div variants={{ hidden: { opacity: 0, x: -10 }, visible: { opacity: 1, x: 0, transition: { duration: 0.4 } } }} className="px-3 py-2 text-[#e5e5ea] hover:bg-white/5 rounded-lg flex items-center justify-between mb-1 cursor-pointer transition-colors">
            <div className="flex items-center gap-3">
              <span className="text-[16px]">🧠</span>
              <span className="font-medium text-[14px]">Blog Writer</span>
            </div>
            <Star className="w-3.5 h-3.5 text-[#ffd60a] fill-[#ffd60a]" />
          </motion.div>

          <motion.div variants={{ hidden: { opacity: 0, x: -10 }, visible: { opacity: 1, x: 0, transition: { duration: 0.4 } } }} className="px-3 py-2 bg-white/10 text-white rounded-lg flex items-center justify-between mb-1 shadow-sm cursor-pointer">
            <div className="flex items-center gap-3">
              <span className="text-[16px]">✉️</span>
              <span className="font-medium text-[14px]">Friendly Email Draft</span>
            </div>
            <Star className="w-3.5 h-3.5 text-[#ffd60a] fill-[#ffd60a]" />
          </motion.div>

          <motion.div variants={{ hidden: { opacity: 0, x: -10 }, visible: { opacity: 1, x: 0, transition: { duration: 0.4 } } }} className="px-3 py-2 text-[#e5e5ea] hover:bg-white/5 rounded-lg flex items-center justify-between mb-1 cursor-pointer transition-colors">
            <div className="flex items-center gap-3">
              <span className="text-[16px]">📝</span>
              <span className="font-medium text-[14px]">Summarize Article</span>
            </div>
            <Star className="w-3.5 h-3.5 text-[#ffd60a] fill-[#ffd60a]" />
          </motion.div>

          <motion.div variants={{ hidden: { opacity: 0, x: -10 }, visible: { opacity: 1, x: 0, transition: { duration: 0.4 } } }} className="px-3 py-2 text-[#e5e5ea] hover:bg-white/5 rounded-lg flex items-center justify-between mb-1 cursor-pointer transition-colors">
            <div className="flex items-center gap-3">
              <span className="text-[16px]">💻</span>
              <span className="font-medium text-[14px]">Debug Code</span>
            </div>
          </motion.div>

          <motion.div variants={{ hidden: { opacity: 0, x: -10 }, visible: { opacity: 1, x: 0, transition: { duration: 0.4 } } }} className="px-3 py-2 text-[#e5e5ea] hover:bg-white/5 rounded-lg flex items-center justify-between mb-1 cursor-pointer transition-colors">
            <div className="flex items-center gap-3">
              <span className="text-[16px]">📈</span>
              <span className="font-medium text-[14px]">Product Strategy</span>
            </div>
          </motion.div>

          <motion.div variants={{ hidden: { opacity: 0, x: -10 }, visible: { opacity: 1, x: 0, transition: { duration: 0.4 } } }} className="px-3 py-2 text-[#e5e5ea] hover:bg-white/5 rounded-lg flex items-center justify-between mb-1 cursor-pointer transition-colors">
            <div className="flex items-center gap-3">
              <span className="text-[16px]">🔍</span>
              <span className="font-medium text-[14px]">Research Assistant</span>
            </div>
          </motion.div>
        </motion.div>
      </div>
      
      {/* Main Content */}
      <motion.div 
        initial={{ opacity: 0, x: 20 }}
        whileInView={{ opacity: 1, x: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.6, delay: 0.4, ease: [0.16, 1, 0.3, 1] }}
        className="flex-1 flex flex-col bg-[#323232] p-8 min-w-0"
      >
        <div className="flex items-center justify-between mb-8">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 bg-[#444444] rounded-xl flex items-center justify-center text-2xl shadow-sm border border-white/5">
              ✉️
            </div>
            <h2 className="text-3xl font-bold text-white tracking-tight">Friendly Email Draft</h2>
          </div>
          <div className="flex items-center gap-3">
            <motion.button 
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className="w-9 h-9 bg-[#444444] rounded-lg flex items-center justify-center border border-white/5 hover:bg-[#555] transition-colors"
            >
              <Star className="w-4 h-4 text-[#ffd60a] fill-[#ffd60a]" />
            </motion.button>
            <motion.button 
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className="w-9 h-9 bg-[#444444] rounded-lg flex items-center justify-center border border-white/5 hover:bg-[#555] transition-colors"
            >
              <Trash2 className="w-4 h-4 text-[#ff453a]" />
            </motion.button>
          </div>
        </div>

        <div className="mb-6">
          <div className="text-[13px] font-semibold text-[#86868b] mb-2">Description</div>
          <div className="bg-[#3a3a3c] rounded-lg p-3.5 text-[15px] text-[#e5e5ea] border border-white/5 shadow-inner">
            Draft a polite professional email.
          </div>
        </div>

        <div className="flex-1 flex flex-col min-h-0">
          <div className="text-[13px] font-semibold text-[#86868b] mb-2">Prompt Content</div>
          <div className="bg-[#3a3a3c] rounded-lg p-5 text-[15px] text-[#e5e5ea] font-mono border border-white/5 flex-1 relative shadow-inner overflow-hidden">
            <div className="leading-relaxed">
              Draft a polite and professional email to [RECIPIENT] regarding [SUBJECT].<br/>
              The main goal of the email is to [GOAL]. Keep it concise and friendly.
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  </motion.div>
);

const InstallSection = () => {
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText('brew install --cask promptbar');
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <section className="py-32 px-6 bg-[#1a1a1a] border-t border-white/5">
      <div className="max-w-3xl mx-auto text-center">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-100px" }}
          transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
        >
          <h2 className="text-3xl font-semibold tracking-tight mb-4 text-transparent bg-clip-text bg-gradient-to-b from-white to-white/80">
            Ready to speed up your workflow?
          </h2>
          <p className="text-[18px] text-[#86868b] mb-10">
            Download the app directly or install via Homebrew.
          </p>
          
          <motion.div 
            whileHover={{ scale: 1.01, y: -2 }}
            transition={{ duration: 0.4, ease: [0.16, 1, 0.3, 1] }}
            className="bg-[#2a2a2a] border border-white/10 rounded-2xl p-8 max-w-xl mx-auto shadow-lg"
          >
            <div className="flex items-center justify-between mb-4">
              <span className="text-[14px] font-medium text-white">Install via Homebrew</span>
              <Terminal className="w-4 h-4 text-[#86868b]" />
            </div>
            <div className="relative group">
              <code className="block w-full bg-[#121212] border border-white/10 px-4 py-3.5 rounded-xl text-white font-mono text-[14px] text-left shadow-inner">
                brew install --cask promptbar
              </code>
              <button 
                onClick={handleCopy}
                className={`absolute right-2 top-1/2 -translate-y-1/2 w-8 h-8 rounded-lg transition-all border active:scale-95 flex items-center justify-center overflow-hidden ${
                  copied 
                    ? 'bg-[#34c759]/10 border-[#34c759]/30 text-[#34c759] opacity-100' 
                    : 'bg-[#2a2a2a] hover:bg-[#3a3a3c] border-white/5 text-white opacity-0 group-hover:opacity-100'
                }`}
                aria-label="Copy command"
              >
                <AnimatePresence mode="wait" initial={false}>
                  {copied ? (
                    <motion.div
                      key="check"
                      initial={{ scale: 0.5, opacity: 0 }}
                      animate={{ scale: 1, opacity: 1 }}
                      exit={{ scale: 0.5, opacity: 0 }}
                      transition={{ duration: 0.15 }}
                    >
                      <Check className="w-3.5 h-3.5" />
                    </motion.div>
                  ) : (
                    <motion.div
                      key="copy"
                      initial={{ scale: 0.5, opacity: 0 }}
                      animate={{ scale: 1, opacity: 1 }}
                      exit={{ scale: 0.5, opacity: 0 }}
                      transition={{ duration: 0.15 }}
                    >
                      <Copy className="w-3.5 h-3.5" />
                    </motion.div>
                  )}
                </AnimatePresence>
              </button>
            </div>
          </motion.div>
        </motion.div>
      </div>
    </section>
  );
};

export default function App() {
  return (
    <div className="min-h-screen font-sans bg-[#121212] text-[#f5f5f7]">
      <Nav />

      {/* Hero Section */}
      <section className="pt-40 pb-24 px-6 relative">
        <div className="max-w-4xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
          >
            <h1 className="text-5xl md:text-[64px] font-semibold tracking-tight mb-6 text-transparent bg-clip-text bg-gradient-to-b from-white to-white/80 text-balance leading-[1.05]">
              Your AI prompts,<br />
              <span className="text-[#86868b] bg-clip-text text-transparent bg-gradient-to-b from-[#86868b] to-[#555555]">instantly accessible.</span>
            </h1>
            <p className="text-xl md:text-[22px] text-[#86868b] max-w-2xl mx-auto mb-12 text-balance leading-relaxed">
              PromptBar is a native macOS menu bar utility for saving, searching, and copying prompts. Just press <kbd className="font-sans px-2 py-1 bg-white/10 rounded-md text-white text-lg mx-1 border border-white/10">⌘⇧P</kbd>.
            </p>
            <div className="flex flex-col sm:flex-row items-center justify-center gap-4 mb-20">
              <motion.a 
                href="https://github.com/zijie-cai/PromptBar/releases/download/v1.0.0/PromptBar-1.0.0.zip"
                target="_blank"
                rel="noopener noreferrer"
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                className="w-full sm:w-auto bg-white text-black px-8 py-3.5 rounded-full text-[17px] font-medium hover:bg-gray-200 transition-colors flex items-center justify-center gap-2 shadow-sm"
              >
                <Download className="w-5 h-5" />
                Download for macOS
              </motion.a>
              <motion.a 
                href="https://github.com/zijie-cai/PromptBar/"
                target="_blank"
                rel="noopener noreferrer"
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                className="w-full sm:w-auto bg-transparent text-white px-8 py-3.5 rounded-full text-[17px] font-medium hover:bg-white/10 transition-colors flex items-center justify-center gap-2 border border-white/20"
              >
                <Github className="w-5 h-5" />
                View on GitHub
              </motion.a>
            </div>
          </motion.div>

          {/* Hero Visual */}
          <div className="relative w-full mt-12">
            <CommandPaletteMockup />
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-32 px-6 bg-[#1a1a1a] border-y border-white/5">
        <div className="max-w-5xl mx-auto">
          <motion.div 
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true, margin: "-100px" }}
            variants={{
              hidden: {},
              visible: {
                transition: { staggerChildren: 0.1 }
              }
            }}
            className="grid grid-cols-1 md:grid-cols-3 gap-12 md:gap-8"
          >
            <motion.div 
              variants={{
                hidden: { opacity: 0, y: 20 },
                visible: { opacity: 1, y: 0, transition: { duration: 0.8, ease: [0.16, 1, 0.3, 1] } }
              }}
              whileHover={{ y: -8, scale: 1.02 }}
              className="flex flex-col items-center text-center p-6 rounded-2xl hover:bg-white/[0.02] border border-transparent hover:border-white/5 transition-colors cursor-default"
            >
              <div className="w-12 h-12 bg-[#2a2a2a] rounded-full flex items-center justify-center mb-6 border border-white/5">
                <Zap className="w-6 h-6 text-white" />
              </div>
              <h3 className="text-xl font-semibold tracking-tight mb-3 text-white">Instant Access</h3>
              <p className="text-[16px] text-[#86868b] leading-relaxed">
                Summon your prompt library from anywhere with a global keyboard shortcut. No context switching required.
              </p>
            </motion.div>

            <motion.div 
              variants={{
                hidden: { opacity: 0, y: 20 },
                visible: { opacity: 1, y: 0, transition: { duration: 0.8, ease: [0.16, 1, 0.3, 1] } }
              }}
              whileHover={{ y: -8, scale: 1.02 }}
              className="flex flex-col items-center text-center p-6 rounded-2xl hover:bg-white/[0.02] border border-transparent hover:border-white/5 transition-colors cursor-default"
            >
              <div className="w-12 h-12 bg-[#2a2a2a] rounded-full flex items-center justify-center mb-6 border border-white/5">
                <Search className="w-6 h-6 text-white" />
              </div>
              <h3 className="text-xl font-semibold tracking-tight mb-3 text-white">Fuzzy Search</h3>
              <p className="text-[16px] text-[#86868b] leading-relaxed">
                Find exactly what you need in milliseconds. The search engine is optimized for speed and accuracy.
              </p>
            </motion.div>

            <motion.div 
              variants={{
                hidden: { opacity: 0, y: 20 },
                visible: { opacity: 1, y: 0, transition: { duration: 0.8, ease: [0.16, 1, 0.3, 1] } }
              }}
              whileHover={{ y: -8, scale: 1.02 }}
              className="flex flex-col items-center text-center p-6 rounded-2xl hover:bg-white/[0.02] border border-transparent hover:border-white/5 transition-colors cursor-default"
            >
              <div className="w-12 h-12 bg-[#2a2a2a] rounded-full flex items-center justify-center mb-6 border border-white/5">
                <LayoutTemplate className="w-6 h-6 text-white" />
              </div>
              <h3 className="text-xl font-semibold tracking-tight mb-3 text-white">Native Feel</h3>
              <p className="text-[16px] text-[#86868b] leading-relaxed">
                Built specifically for macOS. It feels like a natural extension of your operating system, not a web app.
              </p>
            </motion.div>
          </motion.div>
        </div>
      </section>

      {/* Editor Section */}
      <section id="editor" className="py-32 px-6 relative bg-[#121212]">
        <div className="max-w-5xl mx-auto">
          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-100px" }}
            transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
            className="text-center mb-16"
          >
            <h2 className="text-4xl font-semibold tracking-tight mb-4 text-transparent bg-clip-text bg-gradient-to-b from-white to-white/80">
              A clean space to write.
            </h2>
            <p className="text-[18px] text-[#86868b] max-w-2xl mx-auto">
              Manage your prompts in a beautiful, distraction-free editor. Organize with folders, edit with ease, and sync across your devices.
            </p>
          </motion.div>
          
          <div className="relative mt-16">
            <EditorMockup />
          </div>
        </div>
      </section>

      <InstallSection />

      {/* Footer */}
      <footer className="py-8 px-6 border-t border-white/5 bg-[#121212]">
        <div className="max-w-5xl mx-auto flex flex-col items-center justify-center gap-4">
          <div className="flex items-center gap-4 text-[14px] text-[#86868b]">
            <span>Built by <a href="https://zijiecai.com/" target="_blank" rel="noopener noreferrer" className="text-white hover:underline transition-colors font-medium">Zijie Cai</a></span>
            <span className="w-1 h-1 rounded-full bg-[#86868b]/50"></span>
            <a href="https://github.com/zijie-cai/PromptBar/releases" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors font-medium">Releases</a>
            <span className="w-1 h-1 rounded-full bg-[#86868b]/50"></span>
            <a href="https://github.com/zijie-cai/PromptBar/" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors font-medium">GitHub</a>
          </div>
        </div>
      </footer>
    </div>
  );
}
