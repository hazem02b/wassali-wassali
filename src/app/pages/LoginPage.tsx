import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Eye, EyeOff, Moon, Sun } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { useLanguage } from '../contexts/LanguageContext';
import { useTheme } from '../contexts/ThemeContext';

export default function LoginPage() {
  const navigate = useNavigate();
  const { login } = useAuth();
  const { t } = useLanguage();
  const { darkMode, toggleDarkMode } = useTheme();
  const [showPassword, setShowPassword] = useState(false);
  const [rememberMe, setRememberMe] = useState(false);
  const [userType, setUserType] = useState<'client' | 'transporter'>('client');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const result = await login(email, password, userType);
      // Redirection basée sur le VRAI rôle retourné par le backend
      // Récupérer l'utilisateur du localStorage qui vient d'être mis à jour
      const savedUser = localStorage.getItem('user');
      if (savedUser) {
        const user = JSON.parse(savedUser);
        if (user.type === 'client') {
          navigate('/home');
        } else if (user.type === 'transporter') {
          navigate('/transporter-dashboard');
        }
      }
    } catch (err: any) {
      setError(err.message || t('incorrectCredentials'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={`min-h-screen p-6 ${
      darkMode ? 'bg-gray-900' : 'bg-white'
    }`}>
      <div className="flex items-center justify-between mb-6">
        <button
          onClick={() => navigate('/')}
          className={`p-2 rounded-full transition-colors ${
            darkMode ? 'hover:bg-gray-800' : 'hover:bg-gray-100'
          }`}
        >
          <ArrowLeft className={`w-6 h-6 ${
            darkMode ? 'text-white' : ''
          }`} />
        </button>
        <button
          onClick={toggleDarkMode}
          className={`p-2 rounded-full transition-colors ${
            darkMode ? 'hover:bg-gray-800' : 'hover:bg-gray-100'
          }`}
          aria-label="Toggle dark mode"
        >
          {darkMode ? (
            <Sun className="w-6 h-6 text-yellow-400" />
          ) : (
            <Moon className="w-6 h-6 text-gray-700" />
          )}
        </button>
      </div>

      <h1 className={`text-2xl mb-2 ${
        darkMode ? 'text-white' : ''
      }`}>{t('welcomeBack')}</h1>
      <p className={`mb-8 ${
        darkMode ? 'text-gray-400' : 'text-gray-600'
      }`}>{t('loginToAccount')}</p>

      {error && (
        <div className={`mb-4 p-3 border rounded-xl text-sm ${
          darkMode ? 'bg-red-900/20 border-red-800 text-red-400' : 'bg-red-50 border-red-200 text-red-700'
        }`}>
          {error}
        </div>
      )}

      {/* User Type Toggle */}
      <div className="flex gap-2 mb-6">
        <button
          type="button"
          onClick={() => setUserType('client')}
          className={`flex-1 py-3 rounded-xl transition-colors ${
            userType === 'client'
              ? 'bg-[#0066FF] text-white'
              : darkMode ? 'bg-gray-800 text-gray-300' : 'bg-gray-100 text-gray-600'
          }`}
        >
          {t('client')}
        </button>
        <button
          type="button"
          onClick={() => setUserType('transporter')}
          className={`flex-1 py-3 rounded-xl transition-colors ${
            userType === 'transporter'
              ? 'bg-[#FF9500] text-white'
              : darkMode ? 'bg-gray-800 text-gray-300' : 'bg-gray-100 text-gray-600'
          }`}
        >
          {t('transporter')}
        </button>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className={`block text-sm mb-2 ${
            darkMode ? 'text-gray-300' : ''
          }`}>{t('email')}</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className={`w-full px-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#0066FF] ${
              darkMode ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' : 'bg-gray-50 border-gray-200'
            }`}
            placeholder="john@example.com"
            required
          />
        </div>

        <div className="relative">
          <label className={`block text-sm mb-2 ${
            darkMode ? 'text-gray-300' : ''
          }`}>{t('password')}</label>
          <input
            type={showPassword ? 'text' : 'password'}
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className={`w-full px-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#0066FF] ${
              darkMode ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' : 'bg-gray-50 border-gray-200'
            }`}
            placeholder="••••••••"
            required
          />
          <button
            type="button"
            onClick={() => setShowPassword(!showPassword)}
            className={`absolute right-3 top-[42px] ${
              darkMode ? 'text-gray-500' : 'text-gray-400'
            }`}
          >
            {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
          </button>
        </div>

        <div className="flex items-center justify-between pt-2">
          <div className="flex items-center space-x-2">
            <input
              type="checkbox"
              id="remember"
              checked={rememberMe}
              onChange={(e) => setRememberMe(e.target.checked)}
              className="w-4 h-4 text-[#0066FF] rounded"
            />
            <label htmlFor="remember" className={`text-sm ${
              darkMode ? 'text-gray-400' : 'text-gray-600'
            }`}>
              {t('rememberMe')}
            </label>
          </div>
          <button type="button" className="text-sm text-[#0066FF]">
            {t('forgotPassword')}
          </button>
        </div>

        <button
          type="submit"
          disabled={loading}
          className={`w-full text-white py-4 rounded-xl transition-all active:scale-98 mt-6 ${
            userType === 'client' ? 'bg-[#0066FF]' : 'bg-[#FF9500]'
          } ${loading ? 'opacity-50 cursor-not-allowed' : ''}`}
        >
          {loading ? t('connecting') : t('continue')}
        </button>

        <div className="relative my-6">
          <div className="absolute inset-0 flex items-center">
            <div className={`w-full border-t ${
              darkMode ? 'border-gray-700' : 'border-gray-200'
            }`}></div>
          </div>
          <div className="relative flex justify-center text-sm">
            <span className={`px-2 ${
              darkMode ? 'bg-gray-900 text-gray-400' : 'bg-white text-gray-500'
            }`}>{t('orContinueWith')}</span>
          </div>
        </div>

        <button
          type="button"
          className={`w-full border py-4 rounded-xl transition-all active:scale-98 flex items-center justify-center space-x-2 ${
            darkMode ? 'border-gray-700 text-gray-300' : 'border-gray-200 text-gray-700'
          }`}
        >
          <svg className="w-5 h-5" viewBox="0 0 24 24">
            <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
            <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
            <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
            <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
          </svg>
          <span>{t('signInWithGoogle')}</span>
        </button>

        <div className="mt-4 text-center">
          <button
            type="button"
            onClick={() => navigate('/forgot-password')}
            className="text-[#0066FF] hover:underline text-sm"
          >
            {t('forgotPassword')}
          </button>
        </div>

        <p className={`text-center text-sm pt-2 ${
          darkMode ? 'text-gray-400' : 'text-gray-600'
        }`}>
          {t('dontHaveAccount')}{' '}
          <button
            type="button"
            onClick={() => navigate(userType === 'client' ? '/signup-client' : '/signup-transporter')}
            className={userType === 'client' ? 'text-[#0066FF]' : 'text-[#FF9500]'}
          >
            {t('signUp')}
          </button>
        </p>
      </form>
    </div>
  );
}