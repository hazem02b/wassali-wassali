import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Mail } from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';
import apiService from '../services/api.service';

export default function ForgotPassword() {
  const navigate = useNavigate();
  const { t } = useLanguage();
  const [userType, setUserType] = useState<'client' | 'transporter'>('client');
  const [email, setEmail] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const response = await apiService.forgotPassword(email, userType);
      setSuccess(true);
      // Redirect to reset password page after 2 seconds
      setTimeout(() => {
        navigate('/reset-password', { state: { email, userType } });
      }, 2000);
    } catch (err: any) {
      setError(err.message || 'Une erreur est survenue');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-white p-6">
      <div className="flex items-center mb-6">
        <button
          onClick={() => navigate('/login')}
          className="p-2 rounded-full hover:bg-gray-100 transition-colors"
        >
          <ArrowLeft className="w-6 h-6" />
        </button>
      </div>

      <div className="max-w-md mx-auto">
        <div className="text-center mb-8">
          <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <Mail className="w-8 h-8 text-[#0066FF]" />
          </div>
          <h1 className="text-2xl font-bold mb-2">{t('forgotPassword')}</h1>
          <p className="text-gray-600">
            {t('enterEmailForReset')}
          </p>
        </div>

        {success ? (
          <div className="bg-green-50 border border-green-200 text-green-700 p-4 rounded-xl text-center">
            <p className="font-semibold mb-1">{t('emailSent')}</p>
            <p className="text-sm">{t('checkEmailForCode')}</p>
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

              <button
                type="submit"
                disabled={loading}
                className="w-full bg-[#0066FF] text-white py-3 rounded-xl hover:bg-[#0052CC] transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? t('sending') : t('sendResetCode')}
              </button>
            </form>

            <div className="mt-6 text-center">
              <button
                onClick={() => navigate('/login')}
                className="text-[#0066FF] hover:underline"
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
