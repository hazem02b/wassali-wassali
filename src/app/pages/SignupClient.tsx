import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Eye, EyeOff } from 'lucide-react';
import LanguageSelector from '../components/LanguageSelector';

export default function SignupClient() {
  const navigate = useNavigate();
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [agreed, setAgreed] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    navigate('/home');
  };

  return (
    <div className="min-h-screen bg-white p-6">
      <div className="flex items-center justify-between mb-6">
        <button
          onClick={() => navigate('/')}
          className="p-2 hover:bg-gray-100 rounded-full transition-colors"
        >
          <ArrowLeft className="w-6 h-6" />
        </button>
        <LanguageSelector variant="light" />
      </div>

      <h1 className="text-2xl mb-2">Create Account</h1>
      <p className="text-gray-600 mb-8">Sign up as a client to send packages</p>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm mb-2">Full Name</label>
          <input
            type="text"
            className="w-full px-4 py-3 bg-gray-50 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
            placeholder="John Doe"
            required
          />
        </div>

        <div>
          <label className="block text-sm mb-2">Email</label>
          <input
            type="email"
            className="w-full px-4 py-3 bg-gray-50 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
            placeholder="john@example.com"
            required
          />
        </div>

        <div>
          <label className="block text-sm mb-2">Tunisian Phone</label>
          <input
            type="tel"
            className="w-full px-4 py-3 bg-gray-50 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
            placeholder="+216 XX XXX XXX"
            required
          />
        </div>

        <div className="relative">
          <label className="block text-sm mb-2">Password</label>
          <input
            type={showPassword ? 'text' : 'password'}
            className="w-full px-4 py-3 bg-gray-50 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
            placeholder="••••••••"
            required
          />
          <button
            type="button"
            onClick={() => setShowPassword(!showPassword)}
            className="absolute right-3 top-[42px] text-gray-400"
          >
            {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
          </button>
        </div>

        <div className="relative">
          <label className="block text-sm mb-2">Confirm Password</label>
          <input
            type={showConfirmPassword ? 'text' : 'password'}
            className="w-full px-4 py-3 bg-gray-50 rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
            placeholder="••••••••"
            required
          />
          <button
            type="button"
            onClick={() => setShowConfirmPassword(!showConfirmPassword)}
            className="absolute right-3 top-[42px] text-gray-400"
          >
            {showConfirmPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
          </button>
        </div>

        <div className="flex items-start space-x-2 pt-4">
          <input
            type="checkbox"
            id="terms"
            checked={agreed}
            onChange={(e) => setAgreed(e.target.checked)}
            className="mt-1 w-4 h-4 text-[#0066FF] rounded"
            required
          />
          <label htmlFor="terms" className="text-sm text-gray-600">
            I agree to the Terms of Service and Privacy Policy
          </label>
        </div>

        <button
          type="submit"
          className="w-full bg-[#0066FF] text-white py-4 rounded-xl transition-all active:scale-98 disabled:opacity-50 disabled:cursor-not-allowed mt-6"
          disabled={!agreed}
        >
          Sign Up
        </button>

        <p className="text-center text-sm text-gray-600 pt-4">
          Already have an account?{' '}
          <button
            type="button"
            onClick={() => navigate('/login')}
            className="text-[#0066FF]"
          >
            Login
          </button>
        </p>
      </form>
    </div>
  );
}