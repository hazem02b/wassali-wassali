import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Eye, EyeOff, Moon, Sun } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { useLanguage } from '../contexts/LanguageContext';
import { useTheme } from '../contexts/ThemeContext';

export default function SignupTransporter() {
  const navigate = useNavigate();
  const { signup } = useAuth();
  const { t } = useLanguage();
  const { darkMode, toggleDarkMode } = useTheme();
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [agreed, setAgreed] = useState(false);
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (password !== confirmPassword) {
      setError(t('passwordsDontMatch'));
      return;
    }

    if (password.length < 6) {
      setError(t('invalidPassword'));
      return;
    }

    setLoading(true);
    try {
      await signup({ name, email, phone, password, type: 'transporter' });
      navigate('/transporter-dashboard');
    } catch (err: any) {
      setError(err.message || t('error'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={`min-h-screen p-6 pb-20 ${
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
      }`}>{t('becomeTransporter')}</h1>
      <p className={`mb-8 ${
        darkMode ? 'text-gray-400' : 'text-gray-600'
      }`}>{t('signUpAsTransporter')}</p>

      {error && (
        <div className={`mb-4 p-3 border rounded-xl text-sm ${
          darkMode ? 'bg-red-900/20 border-red-800 text-red-400' : 'bg-red-50 border-red-200 text-red-700'
        }`}>
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className={`block text-sm mb-2 ${
            darkMode ? 'text-gray-300' : ''
          }`}>{t('fullName')}</label>
          <input
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            className={`w-full px-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#FF9500] ${
              darkMode ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' : 'bg-gray-50 border-gray-200'
            }`}
            placeholder="John Doe"
            required
          />
        </div>

        <div>
          <label className={`block text-sm mb-2 ${
            darkMode ? 'text-gray-300' : ''
          }`}>{t('email')}</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className={`w-full px-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#FF9500] ${
              darkMode ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' : 'bg-gray-50 border-gray-200'
            }`}
            placeholder="john@example.com"
            required
          />
        </div>

        <div>
          <label className={`block text-sm mb-2 ${
            darkMode ? 'text-gray-300' : ''
          }`}>{t('phone')}</label>
          <input
            type="tel"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            className={`w-full px-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#FF9500] ${
              darkMode ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' : 'bg-gray-50 border-gray-200'
            }`}
            placeholder="+212 XX XXX XXX"
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
            className={`w-full px-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#FF9500] ${
              darkMode ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' : 'bg-gray-50 border-gray-200'
            }`}
            placeholder="••••••••"
            required
            minLength={6}
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

        <div className="relative">
          <label className={`block text-sm mb-2 ${
            darkMode ? 'text-gray-300' : ''
          }`}>{t('confirmPassword')}</label>
          <input
            type={showConfirmPassword ? 'text' : 'password'}
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            className={`w-full px-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#FF9500] ${
              darkMode ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' : 'bg-gray-50 border-gray-200'
            }`}
            placeholder="••••••••"
            required
            minLength={6}
          />
          <button
            type="button"
            onClick={() => setShowConfirmPassword(!showConfirmPassword)}
            className={`absolute right-3 top-[42px] ${
              darkMode ? 'text-gray-500' : 'text-gray-400'
            }`}
          >
            {showConfirmPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
          </button>
        </div>

        <div>
          <label className={`block text-sm mb-2 ${
            darkMode ? 'text-gray-300' : ''
          }`}>Vehicle Type</label>
          <select className={`w-full px-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#FF9500] ${
            darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-gray-50 border-gray-200'
          }`} required>
            <option value="">Select vehicle type</option>
            <option value="car">Car</option>
            <option value="van">Van</option>
            <option value="truck">Truck</option>
            <option value="motorcycle">Motorcycle</option>
          </select>
        </div>

        <div>
          <label className={`block text-sm mb-2 ${
            darkMode ? 'text-gray-300' : ''
          }`}>Driver License</label>
          <input
            type="file"
            accept="image/*,.pdf"
            className={`w-full px-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#FF9500] file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:bg-orange-50 file:text-[#FF9500] file:cursor-pointer hover:file:bg-orange-100 ${
              darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-gray-50 border-gray-200'
            }`}
          />
        </div>

        <div className="flex items-start space-x-2 pt-4">
          <input
            type="checkbox"
            id="terms"
            checked={agreed}
            onChange={(e) => setAgreed(e.target.checked)}
            className="mt-1 w-4 h-4 text-[#FF9500] rounded"
            required
          />
          <label htmlFor="terms" className={`text-sm ${
            darkMode ? 'text-gray-400' : 'text-gray-600'
          }`}>
            {t('agreeToTerms')}
          </label>
        </div>

        <button
          type="submit"
          className="w-full bg-[#FF9500] text-white py-4 rounded-xl transition-all active:scale-98 disabled:opacity-50 disabled:cursor-not-allowed mt-6"
          disabled={!agreed || loading}
        >
          {loading ? t('creating') : t('signUp')}
        </button>

        <p className={`text-center text-sm pt-4 ${
          darkMode ? 'text-gray-400' : 'text-gray-600'
        }`}>
          {t('alreadyHaveAccount')}{' '}
          <button
            type="button"
            onClick={() => navigate('/login')}
            className="text-[#FF9500]"
          >
            {t('login')}
          </button>
        </p>
      </form>
    </div>
  );
}