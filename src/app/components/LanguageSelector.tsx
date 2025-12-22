import { useState } from 'react';
import { Globe } from 'lucide-react';

interface LanguageSelectorProps {
  variant?: 'light' | 'dark';
}

export default function LanguageSelector({ variant = 'dark' }: LanguageSelectorProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [currentLanguage, setCurrentLanguage] = useState('FR');

  const languages = [
    { code: 'FR', label: 'Français', flag: '🇫🇷' },
    { code: 'EN', label: 'English', flag: '🇬🇧' },
    { code: 'AR', label: 'العربية', flag: '🇹🇳' },
  ];

  const handleLanguageChange = (code: string) => {
    setCurrentLanguage(code);
    setIsOpen(false);
    // Here you would typically update the app's i18n context
  };

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
                  currentLanguage === lang.code ? 'bg-blue-50' : ''
                }`}
              >
                <span className="text-xl">{lang.flag}</span>
                <span className="text-sm text-gray-900">{lang.label}</span>
                {currentLanguage === lang.code && (
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