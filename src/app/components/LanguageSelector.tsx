import { useState } from 'react';
import { Globe } from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';

interface LanguageSelectorProps {
  variant?: 'light' | 'dark';
}

export default function LanguageSelector({ variant = 'dark' }: LanguageSelectorProps) {
  const [isOpen, setIsOpen] = useState(false);
  const { language, setLanguage } = useLanguage();

  const languages = [
    { code: 'en', label: 'English', flag: '🇬🇧' },
    { code: 'fr', label: 'Français', flag: '🇫🇷' },
    { code: 'ar', label: 'العربية', flag: '🇹🇳' },
  ];

  const handleLanguageChange = (code: string) => {
    setLanguage(code as 'en' | 'fr' | 'ar');
    setIsOpen(false);
  };

  const currentLanguage = language.toUpperCase();

  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className={`flex items-center space-x-2 px-3 py-2 rounded-lg transition-colors ${
          variant === 'dark' 
            ? 'bg-white/10 backdrop-blur hover:bg-white/20 text-white' 
            : 'bg-gray-100 hover:bg-gray-200 text-gray-700'
        }`}
      >
        <Globe className="w-5 h-5" />
        <span className="text-sm">{currentLanguage}</span>
      </button>

      {isOpen && (
        <>
          <div 
            className="fixed inset-0 z-40" 
            onClick={() => setIsOpen(false)}
          ></div>
          <div className="absolute top-full right-0 mt-2 bg-white rounded-xl shadow-lg overflow-hidden min-w-[160px] z-50">
            {languages.map((lang) => (
              <button
                key={lang.code}
                onClick={() => handleLanguageChange(lang.code)}
                className={`w-full flex items-center space-x-3 px-4 py-3 hover:bg-gray-50 transition-colors ${
                  language === lang.code ? 'bg-blue-50' : ''
                }`}
              >
                <span className="text-xl">{lang.flag}</span>
                <span className="text-sm text-gray-900">{lang.label}</span>
                {language === lang.code && (
                  <span className="ml-auto text-[#0066FF]">✓</span>
                )}
              </button>
            ))}
          </div>
        </>
      )}
    </div>
  );
}