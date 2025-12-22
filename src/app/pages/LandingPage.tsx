import { useNavigate } from 'react-router-dom';
import { Package, Zap, DollarSign, Shield } from 'lucide-react';
import LanguageSelector from '../components/LanguageSelector';
import logo from 'figma:asset/e99d77607d79fe76d51100c87e8c1575596ec122.png';

export default function LandingPage() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#0066FF] to-[#0052CC] text-white p-6 flex flex-col">
      {/* Language Selector */}
      <div className="absolute top-6 right-6">
        <LanguageSelector />
      </div>

      {/* Logo and Tagline */}
      <div className="text-center pt-16 pb-8">
        <div className="flex items-center justify-center mb-4">
          <img src={logo} alt="Wassali Logo" className="w-32 h-32 object-contain" />
        </div>
        <p className="text-xl text-blue-100">Ça arrive!</p>
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
              <h3 className="text-lg mb-1">Continue as Client</h3>
              <p className="text-sm text-gray-600">Send packages easily</p>
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
              <h3 className="text-lg mb-1">Become Transporter</h3>
              <p className="text-sm text-orange-100">Earn by delivering</p>
            </div>
          </div>
        </button>
      </div>

      {/* Benefits Cards */}
      <div className="grid grid-cols-3 gap-4 mt-8 mb-6">
        <div className="bg-white/10 backdrop-blur rounded-xl p-4 text-center">
          <Zap className="w-6 h-6 mx-auto mb-2" />
          <p className="text-sm">Fast</p>
        </div>
        <div className="bg-white/10 backdrop-blur rounded-xl p-4 text-center">
          <DollarSign className="w-6 h-6 mx-auto mb-2" />
          <p className="text-sm">Affordable</p>
        </div>
        <div className="bg-white/10 backdrop-blur rounded-xl p-4 text-center">
          <Shield className="w-6 h-6 mx-auto mb-2" />
          <p className="text-sm">Trusted</p>
        </div>
      </div>

      {/* Login Link */}
      <div className="text-center pb-8">
        <p className="text-blue-100 mb-2">Already have an account?</p>
        <button
          onClick={() => navigate('/login')}
          className="text-white underline"
        >
          Login
        </button>
      </div>
    </div>
  );
}