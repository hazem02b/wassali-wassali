import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Bell, Moon, Sun, Globe, Lock, HelpCircle, Shield, Info } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage } from '../contexts/LanguageContext';

export default function SettingsPage() {
  const navigate = useNavigate();
  const { darkMode, toggleDarkMode } = useTheme();
  const { language, setLanguage, t } = useLanguage();
  const [notifications, setNotifications] = useState(() => {
    const saved = localStorage.getItem('notifications');
    return saved ? JSON.parse(saved) : true;
  });

  const toggleNotifications = () => {
    const newNotifications = !notifications;
    setNotifications(newNotifications);
    localStorage.setItem('notifications', JSON.stringify(newNotifications));
  };

  return (
    <div className={`min-h-screen pb-20 transition-colors ${
      darkMode ? 'bg-gray-900' : 'bg-gray-50'
    }`}>
      {/* Header */}
      <div className={`border-b p-4 sticky top-0 z-10 transition-colors ${
        darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
      }`}>
        <div className="flex items-center space-x-3">
          <button onClick={() => navigate(-1)} className={`p-2 rounded-full ${
            darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'
          }`}>
            <ArrowLeft className={`w-6 h-6 ${
              darkMode ? 'text-white' : 'text-gray-900'
            }`} />
          </button>
          <h1 className={`text-xl font-semibold ${
            darkMode ? 'text-white' : 'text-gray-900'
          }`}>{t('settings')}</h1>
        </div>
      </div>

      <div className="p-6 space-y-6">
        {/* Notifications */}
        <div className={`rounded-xl p-4 border transition-colors ${
          darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
        }`}>
          <h2 className={`text-base font-semibold mb-4 ${
            darkMode ? 'text-white' : 'text-gray-900'
          }`}>{t('preferences')}</h2>
          
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                  <Bell className="w-5 h-5 text-[#0066FF]" />
                </div>
                <div>
                  <p className={`font-medium ${
                    darkMode ? 'text-white' : 'text-gray-900'
                  }`}>{t('notifications')}</p>
                  <p className={`text-xs ${
                    darkMode ? 'text-gray-400' : 'text-gray-500'
                  }`}>Receive push notifications</p>
                </div>
              </div>
              <button
                onClick={toggleNotifications}
                className={`relative w-12 h-7 rounded-full transition-colors ${
                  notifications ? 'bg-[#0066FF]' : 'bg-gray-300'
                }`}
              >
                <div
                  className={`absolute top-1 left-1 w-5 h-5 bg-white rounded-full transition-transform ${
                    notifications ? 'translate-x-5' : 'translate-x-0'
                  }`}
                />
              </button>
            </div>

            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center">
                  {darkMode ? <Moon className="w-5 h-5 text-purple-600" /> : <Sun className="w-5 h-5 text-purple-600" />}
                </div>
                <div>
                  <p className={`font-medium ${
                    darkMode ? 'text-white' : 'text-gray-900'
                  }`}>{t('darkMode')}</p>
                  <p className={`text-xs ${
                    darkMode ? 'text-gray-400' : 'text-gray-500'
                  }`}>Switch to dark theme</p>
                </div>
              </div>
              <button
                onClick={toggleDarkMode}
                className={`relative w-12 h-7 rounded-full transition-colors ${
                  darkMode ? 'bg-purple-600' : 'bg-gray-300'
                }`}
              >
                <div
                  className={`absolute top-1 left-1 w-5 h-5 bg-white rounded-full transition-transform ${
                    darkMode ? 'translate-x-5' : 'translate-x-0'
                  }`}
                />
              </button>
            </div>

            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                  <Globe className="w-5 h-5 text-green-600" />
                </div>
                <div>
                  <p className={`font-medium ${
                    darkMode ? 'text-white' : 'text-gray-900'
                  }`}>{t('language')}</p>
                  <p className={`text-xs ${
                    darkMode ? 'text-gray-400' : 'text-gray-500'
                  }`}>{t('selectLanguage')}</p>
                </div>
              </div>
              <select
                value={language}
                onChange={(e) => setLanguage(e.target.value as 'en' | 'fr' | 'ar')}
                className={`px-3 py-1.5 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#0066FF] ${
                  darkMode ? 'bg-gray-700 text-white border border-gray-600' : 'bg-gray-100 text-gray-900'
                }`}
              >
                <option value="en">English</option>
                <option value="fr">Français</option>
                <option value="ar">العربية</option>
              </select>
            </div>
          </div>
        </div>

        {/* Security */}
        <div className={`rounded-xl p-4 border transition-colors ${
          darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
        }`}>
          <h2 className={`text-base font-semibold mb-4 ${
            darkMode ? 'text-white' : 'text-gray-900'
          }`}>{t('security')}</h2>
          
          <div className="space-y-3">
            <button
              onClick={() => navigate('/change-password')}
              className={`w-full flex items-center space-x-3 p-3 rounded-lg transition-colors ${
                darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-50'
              }`}
            >
              <div className="w-10 h-10 bg-orange-100 rounded-full flex items-center justify-center">
                <Lock className="w-5 h-5 text-orange-600" />
              </div>
              <div className="flex-1 text-left">
                <p className={`font-medium ${
                  darkMode ? 'text-white' : 'text-gray-900'
                  }`}>{t('changePassword')}</p>
                <p className={`text-xs ${
                  darkMode ? 'text-gray-400' : 'text-gray-500'
                }`}>Update your password</p>
              </div>
              <ArrowLeft className={`w-5 h-5 rotate-180 ${
                darkMode ? 'text-gray-500' : 'text-gray-400'
              }`} />
            </button>

            <button
              onClick={() => navigate('/privacy-settings')}
              className={`w-full flex items-center space-x-3 p-3 rounded-lg transition-colors ${
                darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-50'
              }`}
            >
              <div className="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center">
                <Shield className="w-5 h-5 text-red-600" />
              </div>
              <div className="flex-1 text-left">
                <p className={`font-medium ${
                  darkMode ? 'text-white' : 'text-gray-900'
                  }`}>{t('privacySettings')}</p>
                <p className={`text-xs ${
                  darkMode ? 'text-gray-400' : 'text-gray-500'
                }`}>Manage your privacy</p>
              </div>
              <ArrowLeft className={`w-5 h-5 rotate-180 ${
                darkMode ? 'text-gray-500' : 'text-gray-400'
              }`} />
            </button>
          </div>
        </div>

        {/* Support */}
        <div className={`rounded-xl p-4 border transition-colors ${
          darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
        }`}>
          <h2 className={`text-base font-semibold mb-4 ${
            darkMode ? 'text-white' : 'text-gray-900'
          }`}>{t('support')}</h2>
          
          <div className="space-y-3">
            <button
              onClick={() => navigate('/help')}
              className={`w-full flex items-center space-x-3 p-3 rounded-lg transition-colors ${
                darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-50'
              }`}
            >
              <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                <HelpCircle className="w-5 h-5 text-[#0066FF]" />
              </div>
              <div className="flex-1 text-left">
                <p className={`font-medium ${
                  darkMode ? 'text-white' : 'text-gray-900'
                  }`}>{t('helpSupport')}</p>
                <p className={`text-xs ${
                  darkMode ? 'text-gray-400' : 'text-gray-500'
                }`}>Get help and FAQs</p>
              </div>
              <ArrowLeft className={`w-5 h-5 rotate-180 ${
                darkMode ? 'text-gray-500' : 'text-gray-400'
              }`} />
            </button>

            <button
              onClick={() => navigate('/about')}
              className={`w-full flex items-center space-x-3 p-3 rounded-lg transition-colors ${
                darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-50'
              }`}
            >
              <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                darkMode ? 'bg-gray-700' : 'bg-gray-100'
              }`}>
                <Info className={`w-5 h-5 ${
                  darkMode ? 'text-gray-400' : 'text-gray-600'
                }`} />
              </div>
              <div className="flex-1 text-left">
                <p className={`font-medium ${
                  darkMode ? 'text-white' : 'text-gray-900'
                  }`}>{t('about')}</p>
                <p className={`text-xs ${
                  darkMode ? 'text-gray-400' : 'text-gray-500'
                }`}>Version 1.0.0</p>
              </div>
              <ArrowLeft className={`w-5 h-5 rotate-180 ${
                darkMode ? 'text-gray-500' : 'text-gray-400'
              }`} />
            </button>
          </div>
        </div>
      </div>

      <BottomNav active="profile" />
    </div>
  );
}
