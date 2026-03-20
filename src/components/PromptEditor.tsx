import React, { useState } from 'react';
import { motion } from 'motion/react';
import { X, Plus, Trash2, Star, Save } from 'lucide-react';
import { Prompt } from '../store/prompts';
import { cn } from '../lib/utils';

interface PromptEditorProps {
  prompts: Prompt[];
  setPrompts: React.Dispatch<React.SetStateAction<Prompt[]>>;
  onClose: () => void;
}

export function PromptEditor({ prompts, setPrompts, onClose }: PromptEditorProps) {
  const [selectedId, setSelectedId] = useState<string | null>(prompts[0]?.id || null);
  const selectedPrompt = prompts.find(p => p.id === selectedId);

  const handleUpdate = (updates: Partial<Prompt>) => {
    if (!selectedId) return;
    setPrompts(prev => prev.map(p => p.id === selectedId ? { ...p, ...updates } : p));
  };

  const handleAdd = () => {
    const newPrompt: Prompt = {
      id: Date.now().toString(),
      emoji: '✨',
      title: 'New Prompt',
      description: 'Description here...',
      content: '',
      category: 'General',
      isFavorite: false,
    };
    setPrompts([newPrompt, ...prompts]);
    setSelectedId(newPrompt.id);
  };

  const handleDelete = () => {
    if (!selectedId) return;
    setPrompts(prev => prev.filter(p => p.id !== selectedId));
    setSelectedId(null);
  };

  React.useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        e.preventDefault();
        onClose();
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [onClose]);

  return (
    <div className="fixed inset-0 z-40 flex items-center justify-center p-8 bg-black/20 backdrop-blur-sm" onClick={onClose}>
      <motion.div
        initial={{ opacity: 0, scale: 0.95, y: 20 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        exit={{ opacity: 0, scale: 0.95, y: 20 }}
        transition={{ type: 'spring', damping: 25, stiffness: 300 }}
        className="w-full max-w-5xl h-[80vh] bg-white/10 dark:bg-black/40 backdrop-blur-3xl border border-white/20 dark:border-white/10 rounded-2xl shadow-2xl overflow-hidden flex flex-col"
        onClick={e => e.stopPropagation()}
      >
        <div className="flex items-center justify-between px-4 py-3 border-b border-white/10 bg-white/5">
          <div className="flex items-center gap-2">
            <div className="w-3 h-3 rounded-full bg-red-500 cursor-pointer hover:bg-red-600" onClick={onClose} />
            <div className="w-3 h-3 rounded-full bg-yellow-500 cursor-pointer hover:bg-yellow-600" />
            <div className="w-3 h-3 rounded-full bg-green-500 cursor-pointer hover:bg-green-600" />
          </div>
          <div className="font-semibold text-white/80 text-sm">Manage Prompts</div>
          <div className="w-16" /> {/* Spacer for centering */}
        </div>

        <div className="flex flex-1 overflow-hidden">
          {/* Sidebar */}
          <div className="w-64 border-r border-white/10 bg-black/20 flex flex-col">
            <div className="p-4 flex items-center justify-between">
              <span className="text-white/60 text-xs font-semibold uppercase tracking-wider">All Prompts</span>
              <button onClick={handleAdd} className="text-white/60 hover:text-white transition-colors">
                <Plus size={16} />
              </button>
            </div>
            <div className="flex-1 overflow-y-auto p-2 space-y-1">
              {prompts.map(prompt => (
                <div
                  key={prompt.id}
                  onClick={() => setSelectedId(prompt.id)}
                  className={cn(
                    "flex items-center gap-3 px-3 py-2 rounded-lg cursor-pointer transition-colors text-sm",
                    selectedId === prompt.id ? "bg-blue-500 text-white" : "text-white/70 hover:bg-white/10"
                  )}
                >
                  <span>{prompt.emoji}</span>
                  <span className="truncate flex-1">{prompt.title}</span>
                  {prompt.isFavorite && <Star size={12} className={selectedId === prompt.id ? "text-white" : "text-yellow-400"} />}
                </div>
              ))}
            </div>
          </div>

          {/* Editor */}
          <div className="flex-1 flex flex-col bg-transparent">
            {selectedPrompt ? (
              <div className="flex-1 flex flex-col p-6 overflow-y-auto">
                <div className="flex items-center justify-between mb-6">
                  <div className="flex items-center gap-4 flex-1">
                    <input
                      type="text"
                      value={selectedPrompt.emoji}
                      onChange={e => handleUpdate({ emoji: e.target.value })}
                      className="w-12 h-12 text-2xl text-center bg-white/5 border border-white/10 rounded-xl outline-none focus:border-blue-500 transition-colors"
                      maxLength={2}
                    />
                    <input
                      type="text"
                      value={selectedPrompt.title}
                      onChange={e => handleUpdate({ title: e.target.value })}
                      className="flex-1 text-3xl font-bold bg-transparent border-none outline-none text-white placeholder:text-white/30"
                      placeholder="Prompt Title"
                    />
                  </div>
                  <div className="flex items-center gap-2">
                    <button
                      onClick={() => handleUpdate({ isFavorite: !selectedPrompt.isFavorite })}
                      className={cn(
                        "p-2 rounded-lg transition-colors border",
                        selectedPrompt.isFavorite ? "bg-yellow-500/20 border-yellow-500/50 text-yellow-400" : "bg-white/5 border-white/10 text-white/50 hover:bg-white/10 hover:text-white"
                      )}
                    >
                      <Star size={18} fill={selectedPrompt.isFavorite ? "currentColor" : "none"} />
                    </button>
                    <button
                      onClick={handleDelete}
                      className="p-2 rounded-lg transition-colors border bg-white/5 border-white/10 text-red-400 hover:bg-red-500/20 hover:border-red-500/50"
                    >
                      <Trash2 size={18} />
                    </button>
                  </div>
                </div>

                <div className="space-y-4 flex-1 flex flex-col">
                  <div>
                    <label className="block text-xs font-medium text-white/50 mb-1 uppercase tracking-wider">Description</label>
                    <input
                      type="text"
                      value={selectedPrompt.description}
                      onChange={e => handleUpdate({ description: e.target.value })}
                      className="w-full bg-white/5 border border-white/10 rounded-lg px-4 py-2 text-white outline-none focus:border-blue-500 transition-colors"
                      placeholder="Short description..."
                    />
                  </div>
                  <div className="flex-1 flex flex-col">
                    <label className="block text-xs font-medium text-white/50 mb-1 uppercase tracking-wider">Prompt Content</label>
                    <textarea
                      value={selectedPrompt.content}
                      onChange={e => handleUpdate({ content: e.target.value })}
                      className="flex-1 w-full bg-white/5 border border-white/10 rounded-lg px-4 py-3 text-white outline-none focus:border-blue-500 transition-colors resize-none font-mono text-sm leading-relaxed"
                      placeholder="Write your prompt here..."
                    />
                  </div>
                </div>
              </div>
            ) : (
              <div className="flex-1 flex items-center justify-center text-white/40">
                Select a prompt to edit or create a new one.
              </div>
            )}
          </div>
        </div>
      </motion.div>
    </div>
  );
}
