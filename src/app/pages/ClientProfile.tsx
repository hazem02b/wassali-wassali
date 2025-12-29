import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, ArrowRight, Edit, MapPin, CreditCard, Bell, Moon, HelpCircle, LogOut, Package, DollarSign, Settings } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import UserAvatar from '../components/UserAvatar';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage } from '../contexts/LanguageContext';
import apiService from '../services/api.service';

interface ClientStats {
  total_bookings: number;
  total_spent: number;
  active_bookings: number;
  completed_bookings: number;
  cancelled_bookings: number;
}

export default function ClientProfile() {
  const navigate = useNavigate();
  const { user, logout } = useAuth();
  const { darkMode } = useTheme();
  const { t } = useLanguage();
  const [stats, setStats] = useState<ClientStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchStats();
  }, []);

  const fetchStats = async () => {
    try {
      const token = localStorage.getItem('token');
      if (token) {
        const statsData = await apiService.getUserStats(token);
        console.log('📊 Statistiques client:', statsData);
        setStats(statsData);
      }
    } catch (error) {
      console.error('❌ Erreur chargement stats:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={`min-h-screen pb-20 transition-colors ${
      darkMode ? 'bg-gray-900' : 'bg-gray-50'
    }`}>
      <div className="bg-gradient-to-r from-[#0066FF] to-[#0052CC] text-white p-6 rounded-b-3xl mb-6">
        <button onClick={() => navigate('/home')} className="mb-6 p-2 hover:bg-white/10 rounded-full inline-flex">
          <ArrowLeft className="w-6 h-6" />
        </button>
        
        <div className="flex items-center space-x-4 mb-6">
          <UserAvatar user={user} size="lg" />
          <div className="flex-1">
            <h1 className="text-xl mb-1 font-semibold">{user?.name || 'Guest'}</h1>
            <p className="text-blue-100 text-sm">{user?.email || t('noEmail')}</p>
          </div>
          <button 
            onClick={() => navigate('/edit-profile')}
            className="p-2 hover:bg-white/10 rounded-full"
          >
            <Edit className="w-5 h-5" />
          </button>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div className="bg-white/10 backdrop-blur rounded-xl p-4">
            <div className="flex items-center space-x-2 mb-1">
              <Package className="w-4 h-4" />
              <span className="text-sm text-blue-100">{t('totalBookings')}</span>
            </div>
            <p className="text-2xl">{loading ? '...' : (stats?.total_bookings || 0)}</p>
          </div>
          <div className="bg-white/10 backdrop-blur rounded-xl p-4">
            <div className="flex items-center space-x-2 mb-1">
              <DollarSign className="w-4 h-4" />
              <span className="text-sm text-blue-100">{t('totalSpent')}</span>
            </div>
            <p className="text-2xl">{loading ? '...' : `${stats?.total_spent.toFixed(0) || 0}€`}</p>
          </div>
        </div>
      </div>

      <div className="px-6 space-y-4">
        {/* Saved Addresses */}
        <div className={`rounded-xl p-4 border transition-colors ${
          darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
        }`}>
          <h2 className={`mb-3 font-semibold ${
            darkMode ? 'text-white' : 'text-gray-900'
          }`}>{t('savedAddresses')}</h2>
          {user?.address ? (
            <button className={`w-full flex items-center space-x-3 p-3 rounded-lg ${
              darkMode ? 'bg-gray-700' : 'bg-gray-50'
            }`}>
              <MapPin className="w-5 h-5 text-gray-400" />
              <div className="flex-1 text-left">
                <p className={`text-sm font-medium ${
                  darkMode ? 'text-white' : 'text-gray-900'
                }`}>{t('home')}</p>
                <p className={`text-xs ${
                  darkMode ? 'text-gray-400' : 'text-gray-500'
                }`}>{user.address}</p>
              </div>
            </button>
          ) : (
            <button 
              onClick={() => navigate('/edit-profile')}
              className={`w-full flex items-center space-x-3 p-3 rounded-lg border-2 border-dashed hover:border-[#0066FF] transition-colors ${
                darkMode ? 'bg-gray-700 border-gray-600' : 'bg-gray-50 border-gray-300'
              }`}
            >
              <MapPin className="w-5 h-5 text-gray-400" />
              <div className="flex-1 text-left">
                <p className={`text-sm ${
                  darkMode ? 'text-gray-300' : 'text-gray-500'
                }`}>{t('noAddressSaved')}</p>
                <p className={`text-xs ${
                  darkMode ? 'text-gray-500' : 'text-gray-400'
                }`}>{t('tapToAddAddress')}</p>
              </div>
            </button>
          )}
        </div>

        {/* Payment Methods */}
        <div className={`rounded-xl p-4 border transition-colors ${
          darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
        }`}>
          <h2 className={`mb-3 font-semibold ${
            darkMode ? 'text-white' : 'text-gray-900'
          }`}>{t('paymentMethods')}</h2>
          <button 
            onClick={() => navigate('/payment-methods')}
            className={`w-full flex items-center space-x-3 p-3 rounded-lg transition-colors ${
              darkMode ? 'bg-gray-700 hover:bg-gray-600' : 'bg-gray-50 hover:bg-gray-100'
            }`}
          >
            <CreditCard className={`w-5 h-5 ${
              darkMode ? 'text-gray-400' : 'text-gray-500'
            }`} />
            <div className="flex-1 text-left">
              <p className={`text-sm font-medium ${
                darkMode ? 'text-white' : 'text-gray-900'
              }`}>{t('managePaymentMethods')}</p>
              <p className={`text-xs ${
                darkMode ? 'text-gray-400' : 'text-gray-500'
              }`}>{t('addRemovePayment')}</p>
            </div>
            <ArrowRight className={`w-5 h-5 ${
              darkMode ? 'text-gray-500' : 'text-gray-400'
            }`} />
          </button>
        </div>

        {/* Settings & Support */}
        <div className={`rounded-xl border overflow-hidden transition-colors ${
          darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
        }`}>
          <button 
            onClick={() => navigate('/settings')}
            className={`w-full flex items-center space-x-3 p-4 border-b transition-colors ${
              darkMode ? 'hover:bg-gray-700 border-gray-700' : 'hover:bg-gray-50 border-gray-100'
            }`}
          >
            <Settings className={`w-5 h-5 ${
              darkMode ? 'text-gray-400' : 'text-gray-600'
            }`} />
            <span className={`flex-1 text-left font-medium ${
              darkMode ? 'text-white' : 'text-gray-900'
            }`}>{t('settings')}</span>
            <ArrowLeft className={`w-5 h-5 rotate-180 ${
              darkMode ? 'text-gray-500' : 'text-gray-400'
            }`} />
          </button>
          <button 
            onClick={() => navigate('/help')}
            className={`w-full flex items-center space-x-3 p-4 transition-colors ${
              darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-50'
            }`}
          >
            <HelpCircle className={`w-5 h-5 ${
              darkMode ? 'text-gray-400' : 'text-gray-600'
            }`} />
            <span className={`flex-1 text-left font-medium ${
              darkMode ? 'text-white' : 'text-gray-900'
            }`}>{t('helpSupport')}</span>
            <ArrowLeft className={`w-5 h-5 rotate-180 ${
              darkMode ? 'text-gray-500' : 'text-gray-400'
            }`} />
          </button>
        </div>

        {/* Logout */}
        <div className="space-y-2">
          <button 
            onClick={() => {
              logout();
              navigate('/');
            }}
            className={`w-full flex items-center space-x-3 p-4 rounded-xl border transition-colors ${
              darkMode 
                ? 'bg-gray-800 border-red-900/50 text-red-400 hover:bg-red-900/20' 
                : 'bg-white border-red-200 text-red-600 hover:bg-red-50'
            }`}
          >
            <LogOut className="w-5 h-5" />
            <span className="flex-1 text-left font-medium">{t('logout')}</span>
          </button>
        </div>
      </div>

      <BottomNav active="profile" />
    </div>
  );
}
