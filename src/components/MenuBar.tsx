import React, { useState, useRef, useEffect } from 'react';
import { Sparkles, Settings, Star, Search, X } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

interface MenuBarProps {
  onOpenPalette: () => void;
  onOpenEditor: () => void;
}

export function MenuBar({ onOpenPalette, onOpenEditor }: MenuBarProps) {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const menuRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setIsMenuOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  return (
    <div className="w-full h-7 bg-white/10 backdrop-blur-md border-b border-white/10 flex items-center px-4 justify-between text-white text-sm select-none z-50 relative">
      <div className="flex items-center space-x-4 font-medium">
        <span></span>
        <span className="font-semibold">PromptBar</span>
        <span>File</span>
        <span>Edit</span>
        <span>View</span>
        <span>Window</span>
        <span>Help</span>
      </div>

      <div className="flex items-center space-x-4">
        <div className="relative" ref={menuRef}>
          <button 
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            className={`p-1 rounded flex items-center justify-center transition-colors ${isMenuOpen ? 'bg-white/20' : 'hover:bg-white/10'}`}
          >
            <Sparkles size={16} />
          </button>

          <AnimatePresence>
            {isMenuOpen && (
              <motion.div
                initial={{ opacity: 0, y: -5, scale: 0.95 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                exit={{ opacity: 0, y: -5, scale: 0.95 }}
                transition={{ duration: 0.15, ease: 'easeOut' }}
                className="absolute right-0 top-full mt-1 w-56 bg-white/10 backdrop-blur-xl border border-white/20 rounded-lg shadow-2xl py-1 text-sm text-white overflow-hidden"
              >
                <div className="px-3 py-1.5 text-xs font-semibold text-white/50 uppercase tracking-wider">
                  PromptBar
                </div>
                <button 
                  onClick={() => { onOpenPalette(); setIsMenuOpen(false); }}
                  className="w-full text-left px-3 py-1.5 hover:bg-blue-500 hover:text-white flex items-center justify-between"
                >
                  <span className="flex items-center gap-2"><Search size={14} /> Open PromptBar</span>
                  <span className="text-white/50 text-xs tracking-widest">⌘⇧P</span>
                </button>
                <div className="h-px bg-white/10 my-1 mx-2" />
                <button 
                  onClick={() => { onOpenEditor(); setIsMenuOpen(false); }}
                  className="w-full text-left px-3 py-1.5 hover:bg-blue-500 hover:text-white flex items-center gap-2"
                >
                  <Settings size={14} /> Manage Prompts
                </button>
                <button className="w-full text-left px-3 py-1.5 hover:bg-blue-500 hover:text-white flex items-center gap-2">
                  <Star size={14} /> Favorites
                </button>
                <div className="h-px bg-white/10 my-1 mx-2" />
                <button className="w-full text-left px-3 py-1.5 hover:bg-blue-500 hover:text-white">
                  Settings...
                </button>
                <button className="w-full text-left px-3 py-1.5 hover:bg-blue-500 hover:text-white">
                  Quit PromptBar
                </button>
              </motion.div>
            )}
          </AnimatePresence>
        </div>
        <span>{new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
      </div>
    </div>
  );
}
