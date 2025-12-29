import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Edit, MapPin, CreditCard, Bell, Moon, HelpCircle, LogOut, Package, DollarSign, Settings, Star } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import UserAvatar from '../components/UserAvatar';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage } from '../contexts/LanguageContext';
import apiService from '../services/api.service';

interface TransporterStats {
  total_trips: number;
  total_revenue: number;
  pending_bookings: number;
  confirmed_bookings: number;
  in_transit_bookings: number;
}

export default function TransporterProfile() {
  const navigate = useNavigate();
  const { user, logout } = useAuth();
  const { darkMode } = useTheme();
  const { t } = useLanguage();
  const [stats, setStats] = useState<TransporterStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchStats();
  }, []);

  const fetchStats = async () => {
    try {
      const token = localStorage.getItem('token');
      if (token) {
        const statsData = await apiService.getUserStats(token);
        console.log('📊 Statistiques transporteur:', statsData);
        setStats(statsData);
      }
    } catch (error) {
      console.error('❌ Erreur chargement stats:', error);
    } finally {
      setLoading(false);
    }
  };

  const menuItems = [
    { icon: Edit, label: t('editProfile'), path: '/edit-profile', color: 'text-gray-700' },
    { icon: Settings, label: t('settings'), path: '/settings', color: 'text-gray-700' },
    { icon: HelpCircle, label: t('helpSupport'), path: '/help-transporter', color: 'text-gray-700' },
  ];

  const handleLogout = () => {
    logout();
    navigate('/');
  };

  return (
    <div className={`min-h-screen pb-20 transition-colors ${
      darkMode ? 'bg-gray-900' : 'bg-gray-50'
    }`}>
      <div className="bg-gradient-to-r from-[#FF9500] to-[#E68600] text-white p-6 rounded-b-3xl mb-6">
        <button 
          onClick={() => navigate('/transporter-dashboard')} 
          className={`mb-6 p-2 rounded-full inline-flex ${
            darkMode ? 'hover:bg-white/20' : 'hover:bg-white/10'
          }`}
        >
          <ArrowLeft className="w-6 h-6" />
        </button>
        
        <div className="flex items-center space-x-4 mb-6">
          <UserAvatar user={user} size="lg" />
          <div className="flex-1">
            <h1 className="text-xl mb-1 font-semibold">{user?.name || 'Transporter'}</h1>
            <p className="text-orange-100 text-sm">{user?.email || t('noEmail')}</p>
          </div>
          <button 
            onClick={() => navigate('/edit-profile')}
            className={`p-2 rounded-full ${
              darkMode ? 'hover:bg-white/20' : 'hover:bg-white/10'
            }`}
          >
            <Edit className="w-5 h-5" />
          </button>
        </div>

        <div className="grid grid-cols-3 gap-3">
          <div className="bg-white/10 backdrop-blur rounded-xl p-3">
            <div className="flex items-center space-x-2 mb-1">
              <Package className="w-4 h-4" />
              <span className="text-xs text-orange-100">{t('activeTrips')}</span>
            </div>
            <p className="text-2xl">{loading ? '...' : (stats?.total_trips || 0)}</p>
          </div>
          <div className="bg-white/10 backdrop-blur rounded-xl p-3">
            <div className="flex items-center space-x-2 mb-1">
              <DollarSign className="w-4 h-4" />
              <span className="text-xs text-orange-100">{t('totalRevenue')}</span>
            </div>
            <p className="text-2xl">{loading ? '...' : `${stats?.total_revenue.toFixed(0) || 0}€`}</p>
          </div>
          <div className="bg-white/10 backdrop-blur rounded-xl p-3">
            <div className="flex items-center space-x-2 mb-1">
              <Package className="w-4 h-4" />
              <span className="text-xs text-orange-100">{t('pendingBookings')}</span>
            </div>
            <p className="text-2xl">{loading ? '...' : (stats?.pending_bookings || 0)}</p>
          </div>
        </div>
      </div>

      <div className={`mx-6 rounded-2xl overflow-hidden ${
        darkMode ? 'bg-gray-800' : 'bg-white'
      }`}>
        {menuItems.map((item, index) => (
          <button
            key={item.label}
            onClick={() => navigate(item.path)}
            className={`w-full flex items-center justify-between p-4 transition-colors ${
              darkMode 
                ? 'hover:bg-gray-700' 
                : 'hover:bg-gray-50'
            } ${index !== menuItems.length - 1 ? 'border-b' : ''} ${
              darkMode ? 'border-gray-700' : 'border-gray-100'
            }`}
          >
            <div className="flex items-center space-x-3">
              <item.icon className={`w-5 h-5 ${
                darkMode ? 'text-gray-300' : item.color
              }`} />
              <span className={darkMode ? 'text-white' : 'text-gray-900'}>
                {item.label}
              </span>
            </div>
            <ArrowLeft className={`w-5 h-5 rotate-180 ${
              darkMode ? 'text-gray-500' : 'text-gray-400'
            }`} />
          </button>
        ))}
      </div>

      <button
        onClick={handleLogout}
        className={`mx-6 mt-6 w-[calc(100%-48px)] flex items-center justify-center space-x-2 p-4 rounded-2xl transition-colors ${
          darkMode 
            ? 'bg-red-900/20 text-red-400 hover:bg-red-900/30' 
            : 'bg-red-50 text-red-600 hover:bg-red-100'
        }`}
      >
        <LogOut className="w-5 h-5" />
        <span>{t('logout')}</span>
      </button>

      <BottomNav active="profile" />
    </div>
  );
}
