import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Eye, EyeOff, Lock } from 'lucide-react';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage } from '../contexts/LanguageContext';
import { NotificationService } from '../contexts/NotificationService';
import apiService from '../services/api.service';

export default function ChangePasswordPage() {
  const navigate = useNavigate();
  const { darkMode } = useTheme();
  const { t } = useLanguage();
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showCurrentPassword, setShowCurrentPassword] = useState(false);
  const [showNewPassword, setShowNewPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    // Validation
    if (newPassword.length < 6) {
      NotificationService.error(t('error'), t('invalidPassword'));
      return;
    }

    if (newPassword !== confirmPassword) {
      NotificationService.error(t('error'), t('passwordMismatch'));
      return;
    }

    setLoading(true);

    try {
      const token = localStorage.getItem('token');
      if (!token) {
        NotificationService.error(t('notAuthenticated'), t('pleaseLoginAgain'));
        navigate('/login');
        return;
      }

      console.log('Token exists:', !!token);
      console.log('Sending request to change password...');

      // Call API to change password
      await apiService.changePassword(token, {
        current_password: currentPassword,
        new_password: newPassword,
      });

      NotificationService.success(t('success'), t('passwordUpdated'));
      
      // Clear fields
      setCurrentPassword('');
      setNewPassword('');
      setConfirmPassword('');

      // Redirect after 2 seconds
      setTimeout(() => {
        navigate('/settings');
      }, 2000);
    } catch (err: any) {
      NotificationService.error(t('error'), err.message || t('error'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={`min-h-screen transition-colors ${
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
          }`}>{t('changePassword')}</h1>
        </div>
      </div>

      {/* Form */}
      <div className="p-6">
        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Current Password */}
          <div>
            <label className={`block text-sm font-medium mb-2 ${
              darkMode ? 'text-gray-300' : 'text-gray-700'
            }`}>
              {t('currentPassword')}
            </label>
            <div className="relative">
              <Lock className={`absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 ${
                darkMode ? 'text-gray-500' : 'text-gray-400'
              }`} />
              <input
                type={showCurrentPassword ? 'text' : 'password'}
                value={currentPassword}
                onChange={(e) => setCurrentPassword(e.target.value)}
                required
                className={`w-full pl-10 pr-10 py-3 rounded-lg border focus:outline-none focus:ring-2 focus:ring-[#0066FF] transition-colors ${
                  darkMode 
                    ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' 
                    : 'bg-white border-gray-200 text-gray-900 placeholder-gray-400'
                }`}
                placeholder={t('enterCurrentPassword')}
              />
              <button
                type="button"
                onClick={() => setShowCurrentPassword(!showCurrentPassword)}
                className={`absolute right-3 top-1/2 -translate-y-1/2 ${
                  darkMode ? 'text-gray-500' : 'text-gray-400'
                }`}
              >
                {showCurrentPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
              </button>
            </div>
          </div>

          {/* New Password */}
          <div>
            <label className={`block text-sm font-medium mb-2 ${
              darkMode ? 'text-gray-300' : 'text-gray-700'
            }`}>
              {t('newPassword')}
            </label>
            <div className="relative">
              <Lock className={`absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 ${
                darkMode ? 'text-gray-500' : 'text-gray-400'
              }`} />
              <input
                type={showNewPassword ? 'text' : 'password'}
                value={newPassword}
                onChange={(e) => setNewPassword(e.target.value)}
                required
                className={`w-full pl-10 pr-10 py-3 rounded-lg border focus:outline-none focus:ring-2 focus:ring-[#0066FF] transition-colors ${
                  darkMode 
                    ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' 
                    : 'bg-white border-gray-200 text-gray-900 placeholder-gray-400'
                }`}
                placeholder={t('enterNewPassword')}
              />
              <button
                type="button"
                onClick={() => setShowNewPassword(!showNewPassword)}
                className={`absolute right-3 top-1/2 -translate-y-1/2 ${
                  darkMode ? 'text-gray-500' : 'text-gray-400'
                }`}
              >
                {showNewPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
              </button>
            </div>
            <p className={`text-xs mt-1 ${
              darkMode ? 'text-gray-500' : 'text-gray-500'
            }`}>
              {t('invalidPassword')}
            </p>
          </div>

          {/* Confirm Password */}
          <div>
            <label className={`block text-sm font-medium mb-2 ${
              darkMode ? 'text-gray-300' : 'text-gray-700'
            }`}>
              {t('confirmPassword')}
            </label>
            <div className="relative">
              <Lock className={`absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 ${
                darkMode ? 'text-gray-500' : 'text-gray-400'
              }`} />
              <input
                type={showConfirmPassword ? 'text' : 'password'}
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                required
                className={`w-full pl-10 pr-10 py-3 rounded-lg border focus:outline-none focus:ring-2 focus:ring-[#0066FF] transition-colors ${
                  darkMode 
                    ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' 
                    : 'bg-white border-gray-200 text-gray-900 placeholder-gray-400'
                }`}
                placeholder={t('confirmNewPassword')}
              />
              <button
                type="button"
                onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                className={`absolute right-3 top-1/2 -translate-y-1/2 ${
                  darkMode ? 'text-gray-500' : 'text-gray-400'
                }`}
              >
                {showConfirmPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
              </button>
            </div>
          </div>

          {/* Submit Button */}
          <button
            type="submit"
            disabled={loading}
            className={`w-full py-3 rounded-lg font-semibold text-white transition-opacity ${
              loading ? 'opacity-50 cursor-not-allowed' : 'hover:opacity-90'
            } bg-[#0066FF]`}
          >
            {loading ? t('loading') : t('update')}
          </button>
        </form>
      </div>
    </div>
  );
}
