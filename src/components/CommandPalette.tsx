import React, { useState, useEffect, useRef } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Search, Command, ArrowDown, ArrowUp, CornerDownLeft } from 'lucide-react';
import { Prompt } from '../store/prompts';
import { cn } from '../lib/utils';

interface CommandPaletteProps {
  prompts: Prompt[];
  onClose: () => void;
  onCopy: (prompt: Prompt) => void;
}

export function CommandPalette({ prompts, onClose, onCopy }: CommandPaletteProps) {
  const [query, setQuery] = useState('');
  const [selectedIndex, setSelectedIndex] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);
  const listRef = useRef<HTMLDivElement>(null);

  const filteredPrompts = prompts.filter(p => 
    p.title.toLowerCase().includes(query.toLowerCase()) || 
    p.description.toLowerCase().includes(query.toLowerCase()) ||
    p.category.toLowerCase().includes(query.toLowerCase())
  );

  useEffect(() => {
    setSelectedIndex(0);
  }, [query]);

  useEffect(() => {
    inputRef.current?.focus();
    
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        e.preventDefault();
        onClose();
      } else if (e.key === 'ArrowDown') {
        e.preventDefault();
        setSelectedIndex(prev => Math.min(prev + 1, filteredPrompts.length - 1));
      } else if (e.key === 'ArrowUp') {
        e.preventDefault();
        setSelectedIndex(prev => Math.max(prev - 1, 0));
      } else if (e.key === 'Enter') {
        e.preventDefault();
        if (filteredPrompts[selectedIndex]) {
          onCopy(filteredPrompts[selectedIndex]);
        }
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [filteredPrompts, selectedIndex, onClose, onCopy]);

  useEffect(() => {
    const selectedElement = listRef.current?.children[selectedIndex] as HTMLElement;
    if (selectedElement) {
      selectedElement.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
    }
  }, [selectedIndex]);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/20 backdrop-blur-sm" onClick={onClose}>
      <motion.div
        initial={{ opacity: 0, scale: 0.95, y: -20 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        exit={{ opacity: 0, scale: 0.95, y: -20 }}
        transition={{ type: 'spring', damping: 25, stiffness: 300 }}
        className="w-full max-w-2xl bg-white/10 dark:bg-black/40 backdrop-blur-2xl border border-white/20 dark:border-white/10 rounded-2xl shadow-2xl overflow-hidden flex flex-col"
        onClick={e => e.stopPropagation()}
      >
        <div className="flex items-center px-4 py-3 border-b border-white/10">
          <Search className="w-5 h-5 text-white/50 mr-3" />
          <input
            ref={inputRef}
            type="text"
            value={query}
            onChange={e => setQuery(e.target.value)}
            placeholder="Search prompts..."
            className="flex-1 bg-transparent border-none outline-none text-white text-lg placeholder:text-white/30"
          />
          <div className="flex items-center gap-2 text-xs text-white/40 font-mono">
            <span className="flex items-center gap-1 bg-white/10 px-1.5 py-0.5 rounded"><Command size={12}/>K</span>
          </div>
        </div>

        <div className="max-h-[60vh] overflow-y-auto p-2" ref={listRef}>
          {filteredPrompts.length === 0 ? (
            <div className="py-12 text-center text-white/50">
              No prompts found for "{query}"
            </div>
          ) : (
            filteredPrompts.map((prompt, index) => (
              <div
                key={prompt.id}
                className={cn(
                  "flex items-center gap-4 px-4 py-3 rounded-xl cursor-pointer transition-colors duration-150",
                  index === selectedIndex ? "bg-white/20 text-white" : "text-white/70 hover:bg-white/10"
                )}
                onMouseEnter={() => setSelectedIndex(index)}
                onClick={() => onCopy(prompt)}
              >
                <div className="text-2xl flex-shrink-0 w-10 h-10 flex items-center justify-center bg-white/5 rounded-lg shadow-inner border border-white/10">
                  {prompt.emoji}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="font-medium text-white truncate">{prompt.title}</div>
                  <div className="text-sm text-white/50 truncate">{prompt.description}</div>
                </div>
                <div className="flex items-center gap-2 opacity-0 transition-opacity duration-150" style={{ opacity: index === selectedIndex ? 1 : 0 }}>
                  <span className="text-xs text-white/40 bg-white/10 px-2 py-1 rounded flex items-center gap-1">
                    <CornerDownLeft size={12} /> Copy
                  </span>
                </div>
              </div>
            ))
          )}
        </div>

        <div className="px-4 py-2 border-t border-white/10 bg-black/20 flex items-center justify-between text-xs text-white/40">
          <div className="flex items-center gap-4">
            <span className="flex items-center gap-1"><ArrowUp size={12}/><ArrowDown size={12}/> Navigate</span>
            <span className="flex items-center gap-1"><CornerDownLeft size={12}/> Copy Prompt</span>
          </div>
          <div>PromptBar v1.0</div>
        </div>
      </motion.div>
    </div>
  );
}
