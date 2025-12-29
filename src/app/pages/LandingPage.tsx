import { useNavigate } from 'react-router-dom';
import { Package, Zap, DollarSign, Shield } from 'lucide-react';
import LanguageSelector from '../components/LanguageSelector';
import { useLanguage } from '../contexts/LanguageContext';
import logoImage from '../../assets/wassali-logo.svg';

export default function LandingPage() {
  const navigate = useNavigate();
  const { t } = useLanguage();

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#0066FF] to-[#0052CC] text-white p-6 flex flex-col relative">
      {/* Language Selector */}
      <div className="absolute top-6 right-6 z-50">
        <LanguageSelector variant="dark" />
      </div>

      {/* Logo and Tagline */}
      <div className="text-center pt-16 pb-8">
        <div className="flex items-center justify-center mb-4">
          <img src={logoImage} alt="Wassali Logo" className="w-32 h-32" />
        </div>
        <p className="text-xl text-blue-100">{t('tagline')}</p>
      </div>

      {/* User Type Selection */}
      <div className="flex-1 flex flex-col justify-center space-y-4 max-w-sm mx-auto w-full">
        <button
          onClick={() => navigate('/signup-client')}
          className="bg-white text-[#0066FF] rounded-2xl p-6 shadow-lg transition-transform active:scale-95"
        >
          <div className="flex items-center space-x-4">
            <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
              <Package className="w-6 h-6 text-[#0066FF]" />
            </div>
            <div className="flex-1 text-left">
              <h3 className="text-lg mb-1">{t('continueAsClient')}</h3>
              <p className="text-sm text-gray-600">{t('sendPackagesEasily')}</p>
            </div>
          </div>
        </button>

        <button
          onClick={() => navigate('/signup-transporter')}
          className="bg-[#FF9500] text-white rounded-2xl p-6 shadow-lg transition-transform active:scale-95"
        >
          <div className="flex items-center space-x-4">
            <div className="w-12 h-12 bg-orange-600 rounded-full flex items-center justify-center">
              <Package className="w-6 h-6 text-white" />
            </div>
            <div className="flex-1 text-left">
              <h3 className="text-lg mb-1">{t('becomeTransporter')}</h3>
              <p className="text-sm text-orange-100">{t('earnByDelivering')}</p>
            </div>
          </div>
        </button>
      </div>

      {/* Benefits Cards */}
      <div className="grid grid-cols-3 gap-4 mt-8 mb-6">
        <div className="bg-white/10 backdrop-blur rounded-xl p-4 text-center">
          <Zap className="w-6 h-6 mx-auto mb-2" />
          <p className="text-sm">{t('fast')}</p>
        </div>
        <div className="bg-white/10 backdrop-blur rounded-xl p-4 text-center">
          <DollarSign className="w-6 h-6 mx-auto mb-2" />
          <p className="text-sm">{t('affordable')}</p>
        </div>
        <div className="bg-white/10 backdrop-blur rounded-xl p-4 text-center">
          <Shield className="w-6 h-6 mx-auto mb-2" />
          <p className="text-sm">{t('trusted')}</p>
        </div>
      </div>

      {/* Login Link */}
      <div className="text-center pb-8">
        <p className="text-blue-100 mb-2">{t('alreadyHaveAccount')}</p>
        <button
          onClick={() => navigate('/login')}
          className="text-white underline"
        >
          {t('login')}
        </button>
      </div>
    </div>
  );
}