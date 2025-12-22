import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { MapPin, Calendar, Weight, DollarSign, Clock } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import LanguageSelector from '../components/LanguageSelector';

export default function HomeClient() {
  const navigate = useNavigate();
  const [from, setFrom] = useState('');
  const [to, setTo] = useState('');

  const recentSearches = [
    { id: 1, from: 'Tunis', to: 'Paris', date: 'Dec 25' },
    { id: 2, from: 'Sfax', to: 'Lyon', date: 'Dec 20' },
    { id: 3, from: 'Sousse', to: 'Marseille', date: 'Dec 18' },
  ];

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    navigate('/search');
  };

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      {/* Header */}
      <div className="bg-gradient-to-r from-[#0066FF] to-[#0052CC] text-white p-6 rounded-b-3xl">
        <div className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-2xl mb-1">Hello, Ahmed!</h1>
            <p className="text-blue-100">Where to send today?</p>
          </div>
          <div className="flex items-center space-x-2">
            <LanguageSelector />
            <button 
              onClick={() => navigate('/profile')}
              className="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center"
            >
              <span className="text-xl">👤</span>
            </button>
          </div>
        </div>

        {/* Search Form */}
        <form onSubmit={handleSearch} className="space-y-3">
          <div className="relative">
            <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              value={from}
              onChange={(e) => setFrom(e.target.value)}
              className="w-full pl-12 pr-4 py-4 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none"
              placeholder="From (e.g., Tunis)"
              required
            />
          </div>

          <div className="relative">
            <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              value={to}
              onChange={(e) => setTo(e.target.value)}
              className="w-full pl-12 pr-4 py-4 rounded-xl text-gray-900 placeholder-gray-400 focus:outline-none"
              placeholder="To (e.g., Paris)"
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
              <span>Date</span>
            </button>
            <button
              type="button"
              className="flex items-center space-x-2 px-4 py-2 bg-white/20 rounded-xl text-white text-sm"
            >
              <Weight className="w-4 h-4" />
              <span>Weight</span>
            </button>
            <button
              type="button"
              className="flex items-center space-x-2 px-4 py-2 bg-white/20 rounded-xl text-white text-sm"
            >
              <DollarSign className="w-4 h-4" />
              <span>Price</span>
            </button>
          </div>

          <button
            type="submit"
            className="w-full bg-white text-[#0066FF] py-4 rounded-xl transition-all active:scale-98"
          >
            Search Transporters
          </button>
        </form>
      </div>

      {/* Recent Searches */}
      <div className="p-6">
        <h2 className="text-lg mb-4">Recent Searches</h2>
        <div className="space-y-3">
          {recentSearches.map((search) => (
            <button
              key={search.id}
              onClick={() => navigate('/search')}
              className="w-full bg-white p-4 rounded-xl shadow-sm border border-gray-100 hover:border-[#0066FF] transition-colors"
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 bg-blue-50 rounded-full flex items-center justify-center">
                    <MapPin className="w-5 h-5 text-[#0066FF]" />
                  </div>
                  <div className="text-left">
                    <p className="text-sm">
                      {search.from} → {search.to}
                    </p>
                    <div className="flex items-center space-x-1 text-xs text-gray-500 mt-1">
                      <Clock className="w-3 h-3" />
                      <span>{search.date}</span>
                    </div>
                  </div>
                </div>
                <div className="text-gray-400">→</div>
              </div>
            </button>
          ))}
        </div>
      </div>

      <BottomNav active="home" />
    </div>
  );
}