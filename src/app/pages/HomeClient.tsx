import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { MapPin, Calendar, Weight, DollarSign, Clock } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import UserAvatar from '../components/UserAvatar';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage } from '../contexts/LanguageContext';
import { useRecentSearches } from '../hooks/useRecentSearches';

export default function HomeClient() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { darkMode } = useTheme();
  const { t } = useLanguage();
  const [from, setFrom] = useState('');
  const [to, setTo] = useState('');
  const { recentSearches, addRecentSearch } = useRecentSearches();

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    
    // Save the search to recent searches
    if (from && to) {
      addRecentSearch(from, to);
    }
    
    const params = new URLSearchParams();
    if (from) params.append('from', from);
    if (to) params.append('to', to);
    navigate(`/search?${params.toString()}`);
  };

  return (
    <div className={`min-h-screen pb-20 transition-colors ${
      darkMode ? 'bg-gray-900' : 'bg-gray-50'
    }`}>
      {/* Header */}
      <div className="bg-gradient-to-r from-[#0066FF] to-[#0052CC] text-white p-6 rounded-b-3xl">
        <div className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-2xl mb-1">{t('hello')}, {user?.name || 'Guest'}!</h1>
            <p className="text-blue-100">{t('whereToSend')}</p>
          </div>
          <button 
            onClick={() => navigate('/profile')}
            className="hover:opacity-80 transition-opacity"
          >
            <UserAvatar user={user} size="md" />
          </button>
        </div>

        {/* Search Form */}
        <form onSubmit={handleSearch} className="space-y-3">
          <div className="relative">
            <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              value={from}
              onChange={(e) => setFrom(e.target.value)}
              className={`w-full pl-12 pr-4 py-4 rounded-xl focus:outline-none transition-colors ${
                darkMode
                  ? 'bg-gray-800 text-white placeholder-gray-500 border border-gray-700'
                  : 'bg-white text-gray-900 placeholder-gray-400 border-0'
              }`}
              placeholder={t('from')}
              required
            />
          </div>

          <div className="relative">
            <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              value={to}
              onChange={(e) => setTo(e.target.value)}
              className={`w-full pl-12 pr-4 py-4 rounded-xl focus:outline-none transition-colors ${
                darkMode
                  ? 'bg-gray-800 text-white placeholder-gray-500 border border-gray-700'
                  : 'bg-white text-gray-900 placeholder-gray-400 border-0'
              }`}
              placeholder={t('to')}
              required
            />
          </div>

          {/* Filter Buttons */}
          <div className="flex gap-2">
            <button
              type="button"
              className="flex items-center space-x-2 px-4 py-2 bg-white/20 rounded-xl text-white text-sm"
            >
              <Calendar className="w-4 h-4" />
              <span>{t('date')}</span>
            </button>
            <button
              type="button"
              className="flex items-center space-x-2 px-4 py-2 bg-white/20 rounded-xl text-white text-sm"
            >
              <Weight className="w-4 h-4" />
              <span>{t('weight')}</span>
            </button>
            <button
              type="button"
              className="flex items-center space-x-2 px-4 py-2 bg-white/20 rounded-xl text-white text-sm"
            >
              <DollarSign className="w-4 h-4" />
              <span>{t('price')}</span>
            </button>
          </div>

          <button
            type="submit"
            className="w-full bg-white text-[#0066FF] py-4 rounded-xl transition-all active:scale-98"
          >
            {t('searchTransporters')}
          </button>
        </form>
      </div>

      {/* Recent Searches */}
      <div className="p-6">
        <h2 className={`text-lg mb-4 font-semibold ${
          darkMode ? 'text-white' : 'text-gray-900'
        }`}>{t('recentSearches')}</h2>
        {recentSearches.length === 0 ? (
          <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
            {t('noRecentSearches') || 'Aucune recherche récente'}
          </p>
        ) : (
          <div className="space-y-3">
            {recentSearches.map((search) => (
              <button
                key={search.id}
                onClick={() => {
                  setFrom(search.from);
                  setTo(search.to);
                  window.scrollTo({ top: 0, behavior: 'smooth' });
                }}
                className={`w-full p-4 rounded-xl shadow-sm border transition-colors ${
                  darkMode 
                    ? 'bg-gray-800 border-gray-700 hover:border-[#0066FF]' 
                    : 'bg-white border-gray-100 hover:border-[#0066FF]'
                }`}
              >
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-blue-50 rounded-full flex items-center justify-center">
                      <MapPin className="w-5 h-5 text-[#0066FF]" />
                    </div>
                    <div className="text-left">
                      <p className={`text-sm font-medium ${
                        darkMode ? 'text-white' : 'text-gray-900'
                      }`}>
                        {search.from} → {search.to}
                      </p>
                      <div className={`flex items-center space-x-1 text-xs mt-1 ${
                        darkMode ? 'text-gray-400' : 'text-gray-500'
                      }`}>
                        <Clock className="w-3 h-3" />
                        <span>{search.date}</span>
                      </div>
                    </div>
                  </div>
                  <div className={darkMode ? 'text-gray-500' : 'text-gray-400'}>→</div>
                </div>
              </button>
            ))}
          </div>
        )}
      </div>

      <BottomNav active="home" />
    </div>
  );
}