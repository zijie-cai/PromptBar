import React, { useState, useEffect } from 'react';
import { MenuBar } from './MenuBar';
import { CommandPalette } from './CommandPalette';
import { PromptEditor } from './PromptEditor';
import { Toast } from './Toast';
import { INITIAL_PROMPTS, Prompt } from '../store/prompts';

export function Desktop() {
  const [isPaletteOpen, setIsPaletteOpen] = useState(false);
  const [isEditorOpen, setIsEditorOpen] = useState(false);
  const [toastMessage, setToastMessage] = useState<string | null>(null);
  const [prompts, setPrompts] = useState<Prompt[]>(INITIAL_PROMPTS);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      // Cmd+Shift+P or Ctrl+Shift+P
      if ((e.metaKey || e.ctrlKey) && e.shiftKey && e.key.toLowerCase() === 'p') {
        e.preventDefault();
        setIsPaletteOpen((prev) => !prev);
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  const showToast = (message: string) => {
    setToastMessage(message);
    setTimeout(() => setToastMessage(null), 2000);
  };

  return (
    <div 
      className="relative w-full h-screen overflow-hidden bg-cover bg-center"
      style={{ 
        backgroundImage: 'url("https://images.unsplash.com/photo-1620121692029-d088224ddc74?q=80&w=2832&auto=format&fit=crop")',
        backgroundColor: '#1a1a2e'
      }}
    >
      <MenuBar 
        onOpenPalette={() => setIsPaletteOpen(true)}
        onOpenEditor={() => setIsEditorOpen(true)}
      />

      <div className="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
        <div className="text-white/30 text-2xl font-light tracking-wide mb-4">
          PromptBar Prototype
        </div>
        <div className="flex items-center gap-2 text-white/40 bg-black/20 px-4 py-2 rounded-full backdrop-blur-md border border-white/5">
          <span>Press</span>
          <kbd className="font-mono bg-white/10 px-2 py-1 rounded text-sm">⌘</kbd>
          <kbd className="font-mono bg-white/10 px-2 py-1 rounded text-sm">⇧</kbd>
          <kbd className="font-mono bg-white/10 px-2 py-1 rounded text-sm">P</kbd>
          <span>to open</span>
        </div>
      </div>

      {isPaletteOpen && (
        <CommandPalette 
          prompts={prompts}
          onClose={() => setIsPaletteOpen(false)}
          onCopy={(prompt) => {
            navigator.clipboard.writeText(prompt.content);
            showToast('✓ Prompt copied');
            setIsPaletteOpen(false);
          }}
        />
      )}

      {isEditorOpen && (
        <PromptEditor 
          prompts={prompts}
          setPrompts={setPrompts}
          onClose={() => setIsEditorOpen(false)}
        />
      )}

      <Toast message={toastMessage} />
    </div>
  );
}
