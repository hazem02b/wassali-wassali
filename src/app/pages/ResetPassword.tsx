import { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { ArrowLeft, Lock, Eye, EyeOff } from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';
import apiService from '../services/api.service';

export default function ResetPassword() {
  const navigate = useNavigate();
  const location = useLocation();
  const { t } = useLanguage();
  
  // Get email and userType from navigation state
  const stateEmail = (location.state as any)?.email || '';
  const stateUserType = (location.state as any)?.userType || 'client';
  
  const [email, setEmail] = useState(stateEmail);
  const [userType, setUserType] = useState<'client' | 'transporter'>(stateUserType);
  const [resetCode, setResetCode] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (newPassword !== confirmPassword) {
      setError(t('passwordsDontMatch'));
      return;
    }

    if (newPassword.length < 6) {
      setError(t('passwordTooShort'));
      return;
    }

    setLoading(true);

    try {
      await apiService.resetPassword(email, userType, resetCode, newPassword);
      setSuccess(true);
      // Redirect to login after 2 seconds
      setTimeout(() => {
        navigate('/login');
      }, 2000);
    } catch (err: any) {
      setError(err.message || t('invalidResetCode'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-white p-6">
      <div className="flex items-center mb-6">
        <button
          onClick={() => navigate('/forgot-password')}
          className="p-2 rounded-full hover:bg-gray-100 transition-colors"
        >
          <ArrowLeft className="w-6 h-6" />
        </button>
      </div>

      <div className="max-w-md mx-auto">
        <div className="text-center mb-8">
          <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <Lock className="w-8 h-8 text-[#0066FF]" />
          </div>
          <h1 className="text-2xl font-bold mb-2">{t('resetPassword')}</h1>
          <p className="text-gray-600">
            {t('enterCodeAndNewPassword')}
          </p>
        </div>

        {success ? (
          <div className="bg-green-50 border border-green-200 text-green-700 p-4 rounded-xl text-center">
            <p className="font-semibold mb-1">{t('passwordResetSuccess')}</p>
            <p className="text-sm">{t('redirectingToLogin')}</p>
          </div>
        ) : (
          <>
            {error && (
              <div className="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded-xl text-sm">
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
                    : 'bg-gray-100 text-gray-600'
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
                    : 'bg-gray-100 text-gray-600'
                }`}
              >
                {t('transporter')}
              </button>
            </div>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-2">
                  {t('email')}
                </label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                  placeholder="john@example.com"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium mb-2">
                  {t('resetCode')}
                </label>
                <input
                  type="text"
                  value={resetCode}
                  onChange={(e) => setResetCode(e.target.value.replace(/\D/g, '').slice(0, 6))}
                  className="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0066FF] text-center text-2xl tracking-widest font-bold"
                  placeholder="000000"
                  maxLength={6}
                  required
                />
                <p className="text-xs text-gray-500 mt-1 text-center">
                  {t('enterSixDigitCode')}
                </p>
              </div>

              <div>
                <label className="block text-sm font-medium mb-2">
                  {t('newPassword')}
                </label>
                <div className="relative">
                  <input
                    type={showPassword ? 'text' : 'password'}
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    className="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0066FF] pr-12"
                    placeholder="••••••••"
                    required
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700"
                  >
                    {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                  </button>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium mb-2">
                  {t('confirmPassword')}
                </label>
                <div className="relative">
                  <input
                    type={showConfirmPassword ? 'text' : 'password'}
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    className="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0066FF] pr-12"
                    placeholder="••••••••"
                    required
                  />
                  <button
                    type="button"
                    onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700"
                  >
                    {showConfirmPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                  </button>
                </div>
              </div>

              <button
                type="submit"
                disabled={loading}
                className="w-full bg-[#0066FF] text-white py-3 rounded-xl hover:bg-[#0052CC] transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? t('resetting') : t('resetPassword')}
              </button>
            </form>

            <div className="mt-6 text-center space-y-2">
              <button
                onClick={() => navigate('/forgot-password')}
                className="text-[#0066FF] hover:underline text-sm"
              >
                {t('didntReceiveCode')}
              </button>
              <br />
              <button
                onClick={() => navigate('/login')}
                className="text-gray-600 hover:underline text-sm"
              >
                {t('backToLogin')}
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
